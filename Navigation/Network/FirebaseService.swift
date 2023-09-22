
import Foundation
import FirebaseAuth

enum FirebaseError: Error {
    case notAuthorized
    case signOutError(reason: String)
}

protocol FirebaseServiceProtocol: AnyObject {
    var isAuthorized: Bool { get }
    func signUp(
        withEmail email: String,
        withPass pass: String,
        completion: @escaping (Result<UserModel, FirebaseError>) -> Void)
    func signIn(
        withEmail email: String,
        withPass pass: String,
        completion: @escaping (Result<UserModel, FirebaseError>) -> Void)
    func signOut() throws
}

class FirebaseService {

    static let shared = FirebaseService()
    private init () {}
    
    func responseMethod(
        _ response: (authData: AuthDataResult?, error: Error?),
        completion: @escaping (Result<UserModel, FirebaseError>) -> Void
    ) {
        let completionOnMainThread: (Result<UserModel, FirebaseError>) -> Void = {
            result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        if let error = response.error {
            completionOnMainThread(.failure(.signOutError(reason: error.localizedDescription)))
            return
        }
        
        guard
            let fbUser = response.authData?.user
//            let fbCredential = response.authData?.credential
        else {
            completionOnMainThread(.failure(.notAuthorized))
            return
        }
        
//        let credential = CredentialModel(from: response.authData?.credential)
        let user = UserModel(from: fbUser)

        completionOnMainThread(.success(user))
    }
}

extension FirebaseService: FirebaseServiceProtocol {
    
    var isAuthorized: Bool {
        Auth.auth().currentUser != nil
    }
    
    func signUp(withEmail email: String,
                withPass pass: String,
                completion: @escaping (Result<UserModel, FirebaseError>) -> Void) {
        let auth = Auth.auth()
        auth.createUser(withEmail: email,
                        password: pass)
        {
            (authData, error) in
               self.responseMethod(
                   (authData: authData, error: error),
                   completion: completion)
        }
    }
    
    func signIn(withEmail email: String,
                withPass pass: String,
                completion: @escaping (Result<UserModel, FirebaseError>) -> Void) {
        let auth = Auth.auth()
        auth.signIn(
            withEmail: email,
            password: pass)
        { (authData, error) in
            self.responseMethod(
                (authData: authData, error: error),
                completion: completion)
        }
    }
    
    func signOut() throws {
        let auth = Auth.auth()
        do {
            try auth.signOut()
        } catch {
            throw FirebaseError.signOutError(reason: error.localizedDescription)
        }
    }
    
    func getCurrentUser() -> User? {
        Auth.auth().currentUser
    }
}
