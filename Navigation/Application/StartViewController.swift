
import UIKit

class StartViewController: UIViewController {

    var mainImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "logo2")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    var secondaryImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "logo22")
        $0.contentMode = .scaleAspectFit
        $0.alpha = 0.0
        return $0
    }(UIImageView())
    
    var txt: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isEditable = false
        $0.backgroundColor = .clear
        $0.textColor = .black
        return $0
    }(UITextView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        txt.text = """
        """             ///Отладка запуска, если пользователь остался залогинен
        setupUI()
        animateLogo()
        loadUserData()
    }

    private func loadUserData() {
        let firebaseService = FirebaseService.shared
        let firestoreManager = FirestoreManager.shared
        let userService = CurrentUserService.shared

        if firebaseService.isAuthorized {
            txt.text += "START Auth = \(firebaseService.isAuthorized)\n" ///Отладка запуска, если пользователь остался залогинен
            
            if let login = firebaseService.getCurrentUser()?.email {
                firestoreManager.getData(for: login) { profile in
                    userService.userData = profile
                    self.txt.text += "START profile = \(String(describing: userService.userData))\n"///Отладка запуска, если пользователь остался залогинен

                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(7), execute: {
                self.txt.text += "NEXT profile = \(String(describing: userService.userData?.name))\n"///Отладка запуска, если пользователь остался залогинен
                if userService.userData?.name == nil {
                    try? firebaseService.signOut()
                }
            })
        } else {
            txt.text += "START Auth = \(firebaseService.isAuthorized)\n" ///Отладка запуска, если пользователь остался залогинен
        }
    }
    
    private func animateLogo() {
        UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveLinear) { [weak self] in
            self?.mainImage.alpha = 0.7
            self?.secondaryImage.alpha = 1.0
        } completion: { _ in
            UIView.animate(withDuration: 2.5, delay: 0.0, options: .curveEaseOut) { [weak self] in
                self?.mainImage.alpha = 0.0
                self?.secondaryImage.alpha = 0.0
                self?.mainImage.transform = CGAffineTransformMakeScale(1.35, 1.35)
                self?.secondaryImage.transform = CGAffineTransformMakeScale(1.35, 1.35)
            } completion: { _ in }
        }
    }
    
    private func setupUI() {
        [secondaryImage, mainImage, txt].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            secondaryImage.topAnchor.constraint(equalTo: view.topAnchor),
            secondaryImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondaryImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            secondaryImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainImage.topAnchor.constraint(equalTo: view.topAnchor),
            mainImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            txt.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
            txt.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            txt.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            txt.bottomAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
