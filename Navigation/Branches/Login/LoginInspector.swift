
import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func signIn(login: String, pass: String)
}

final class LoginInspector: LoginViewControllerDelegate {
    let checker = Checker.shared
    
    func signIn(login: String, pass: String) {
        checker.signIn(login: login, pass: pass)
    }
}
