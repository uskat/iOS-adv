
import UIKit
import FirebaseAuth

//class UserModel {
//    var login: String
//    var password: String
//    var name: String
//    var avatar: UIImage
//    var status: String
//
//    init(login: String = "", password: String = "", name: String = "", avatar: UIImage = UIImage(), status: String = "") {
//        self.login = login
//        self.password = password
//        self.name = name
//        self.avatar = avatar
//        self.status = status
//    }
//}

struct UserModel {

    var login: String

    init(from user: User) {
        self.login = user.email ?? ""
    }
}
