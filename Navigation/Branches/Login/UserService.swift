
import Foundation

protocol UserService {
}

public class CurrentUserService: UserService {
    var user: UserModel?
    var userData: UserProfile?
    let firestoreManager = FirestoreManager.shared
    static let shared = CurrentUserService()
    private init () {}

    func addUserData(to login: String, name: String, status: String, completion: @escaping (Bool) -> Void) {
        firestoreManager.setData(to: login, name: name, status: status, completion: completion)
    }
    
    func getUserData(from login: String, completion: @escaping (Bool) -> Void) {
        self.firestoreManager.getData(for: login) { profile in
            if let profile = profile {
                self.userData = profile
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

//class TestUserService: UserService {
//    var user: UserModel?
//    static let shared = TestUserService()
//    private init () {}
//
//    func checkUser(_ login: String) -> UserModel? {
//        let user = UserModel(login: users[1].login,
//                      password: users[1].password,
//                      name: users[1].name,
//                      avatar: users[1].userImage,
//                      status: users[1].status)
//        return login == users[1].name ? user : nil
//        return nil
//
//    }
//}

/*
 func getUserData(from login: String, completion: @escaping (Bool) -> Void) {
     DispatchQueue.global(qos: .background).async {
         self.firestoreManager.getData(for: login) { profile in
             if let profile = profile {
                 print("UserService. profile OK = \(profile)")
                 self.userData = profile
                 DispatchQueue.main.async {
                     completion(true)
                 }
             } else {
                 print("UserService. profile FALSE = \(profile)")
                 DispatchQueue.main.async {
                     completion(false)
                 }
             }
         }
     }
 }
 
 */
