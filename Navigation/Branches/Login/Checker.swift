
import UIKit

final class Checker {
    static let shared = Checker()
    private init() {}
    
    func signIn(login: String, pass: String) {
        let firebaseService = FirebaseService.shared
        let userService = CurrentUserService.shared
        firebaseService.signIn(withEmail: login, withPass: pass, completion: { result in
            switch result {
            case .success(let user):
                print("✅ authorization was successful. Dump = \(dump(user))")
                userService.user = user
            case .failure(let error):
                print("🚫 authorization failed. Dump = \(dump(error))")
            }
        })
    }
    
    func signUp(login: String, pass: String) {
        
    }
}


/*
private func loadUserData(for login: String) {
    let vc = ProfileViewController(viewModel: viewModel)
    activitySign.startAnimating()
    firestoreManager.getData(for: login) { profile in
        print("profile = \(profile!)")
        vc.userData = profile
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
        self.activitySign.stopAnimating()
        if vc.userData != nil {
            self.viewModel.load(to: .profile)
        } else {
            self.alertOfLogIn(title: "Error",
                              message: "Connection failed. Check your connection and try again later.")
            try? self.viewModel.firebaseService.signOut()
        }
    })
}
 */
