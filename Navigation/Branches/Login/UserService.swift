
import Foundation

protocol UserService {
}

public class CurrentUserService: UserService {
    var user: UserModel?
    var userData: UserProfile?
    let firestoreManager = FirestoreManager.shared
    static let shared = CurrentUserService()
    private init () {}

    func addUserData(to login: String, name: String, status: String) {
        firestoreManager.setData(to: login, name: name, status: status)
    }
    
    func getUserData(from login: String) {
        firestoreManager.getData(for: login) { profile in
            self.userData = profile
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
