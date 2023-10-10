
import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func signIn(login: String, pass: String, completion: @escaping (Bool) -> Void)
}

final class LoginInspector: LoginViewControllerDelegate {
    let checker = Checker.shared
    
    func signIn(login: String, pass: String, completion: @escaping (Bool) -> Void) {
        checker.signIn(login: login, pass: pass, completion: completion) 
    }
}
