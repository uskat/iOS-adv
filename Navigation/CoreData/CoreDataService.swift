
import Foundation
import CoreData

protocol CoreDataProtocol: AnyObject {
    func addPostToFavorites(_ post: Post, completion: @escaping (Bool) -> Void)
    func fetchPosts(predicate: NSPredicate?, completion: @escaping ([PostCoreDataModel]) -> Void)
    func deletePost(predicate: NSPredicate?, completion: @escaping (Bool) -> Void)
}

extension CoreDataProtocol {
    func fetchPosts(completion: @escaping ([PostCoreDataModel]) -> Void) {
        self.fetchPosts(predicate: nil, completion: completion)
    }
    
    func deletePost(completion: @escaping (Bool) -> Void) {
        self.deletePost(predicate: nil, completion: completion)
    }
}

final class CoreDataService {
    
    let objectModel: NSManagedObjectModel
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    // 4. NSManagedObjectContext
    private lazy var mainContext: NSManagedObjectContext = {
        $0.persistentStoreCoordinator = self.persistentStoreCoordinator
        return $0
    }(NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
    private lazy var backgroundContext: NSManagedObjectContext = {
        $0.mergePolicy = NSOverwriteMergePolicy
        $0.persistentStoreCoordinator = self.persistentStoreCoordinator
        return $0
    }(NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType))
    
    static let shared = CoreDataService()
    
    private init() { //при иниц CoreDataService будет иниц-ся база данных (хранилище)
        
        // 1. NSManagedObjectModel
        guard let url = Bundle.main.url(forResource: "Navigation", withExtension: "momd") else {
            fatalError("  ++++ There is no xcdatamodeld file. ++++  ")
        }
        
        //let path = url.pathExtension //momd
        guard let name = try? url.deletingPathExtension().lastPathComponent else {
            fatalError()
        } // CoreDataNavigation. -> убрали расширение
        
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("  +++ Can't create NSManagedObjectModel +++  ")
        }
        self.objectModel = model
        
        // 2. NSPersistentStoreCoordinator
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.objectModel)
        
        // 3. NSPersistentStore
        let storeName = name + ".sqlite" // CoreDataNavigation.sqlite
        let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first //
        let persistentStoreUrl = documentsDirectoryUrl?.appendingPathComponent(storeName) //сохраняем базу данных PersistentStore в директории Документы пользователя
        print("✅", persistentStoreUrl)
        
        guard let persistentStoreUrl = persistentStoreUrl else { return }
        
        let options = [NSMigratePersistentStoresAutomaticallyOption: true] // опция: при изменении атрибутов каких-либо сущностей миграция будет происходить автоматически
        do {   // с помощью координатора добавляем новое хранилище
            try self.persistentStoreCoordinator.addPersistentStore(
                type: .sqlite,           // тип хранилища
                at: persistentStoreUrl,  // путь к хранилищу (создали выше)
                options: options)        // с опциями
        } catch {
            fatalError("  +++ Can't create NSPersistentStore +++  ")
        }
    }
}

extension CoreDataService: CoreDataProtocol {
    func addPostToFavorites(_ post: Post, completion: @escaping (Bool) -> Void) {
        self.backgroundContext.perform {
            self.fetchPosts(predicate: NSPredicate(format: "id == %@", post.id)) { choosenPosts in
                guard choosenPosts.isEmpty else {
                    completion(false)
                    return
                }
                
                let postCoreDataModel = PostCoreDataModel(context: self.backgroundContext)
                postCoreDataModel.id = post.id
                postCoreDataModel.author = post.author
                postCoreDataModel.imageName = post.imageName
                postCoreDataModel.postDescription = post.postDescription
                postCoreDataModel.likes = post.likes
                postCoreDataModel.views = post.views
                
                guard self.backgroundContext.hasChanges else {
                    self.mainContext.perform {
                        completion(false)
                    }
                    return
                }
                
                do {
                    try self.backgroundContext.save()
                    self.mainContext.perform {
                        completion(true)
                    }
                } catch {
                    self.mainContext.perform {
                        completion(false)
                    }
                }
            }
        }
    }
    
    func fetchPosts(predicate: NSPredicate?, completion: @escaping ([PostCoreDataModel]) -> Void)  {
        self.backgroundContext.perform {
            let fetchRequest = PostCoreDataModel.fetchRequest()
            fetchRequest.predicate = predicate
            do {
                let storedPost = try self.backgroundContext.fetch(fetchRequest)
                self.mainContext.perform {
                    completion(storedPost)
                }
            } catch {
                self.mainContext.perform {
                    completion([])
                }
            }
        }
    }
    
    func deletePost(predicate: NSPredicate?, completion: @escaping (Bool) -> Void) {
        self.backgroundContext.perform {
            self.fetchPosts(predicate: predicate) { choosenPosts in
                choosenPosts.forEach {
                    self.backgroundContext.delete($0)
                }
                
                guard self.backgroundContext.hasChanges else {
                    self.mainContext.perform {
                        completion(false)
                    }
                    return
                }
                
                do {
                    try self.backgroundContext.save()
                    self.mainContext.perform {
                        completion(true)
                    }
                } catch {
                    self.mainContext.perform {
                        completion(false)
                    }
                }
            }
        }
    }
}
