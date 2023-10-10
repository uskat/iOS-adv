
import UIKit
import FirebaseAuth

//Firebase
struct UserModel {

    var login: String

    init(from user: User) {
        self.login = user.email ?? ""
    }
}

//Keychain for biometrics
struct Credentials {
    var login: String
    var pass: String
    var service = "user credentials"
}
