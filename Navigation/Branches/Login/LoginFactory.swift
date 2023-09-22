
import UIKit

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

struct MyLoginFactory: LoginFactory {
    static let shared = MyLoginFactory()
    private init () {}
    
    func makeLoginInspector() -> LoginInspector {
        print("makeLoginInspector ok. \(LoginInspector())")
        return LoginInspector()
    }
}
