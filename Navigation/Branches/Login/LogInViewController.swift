
import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    private let viewModel: ProfileViewModel
    private let firestoreManager = FirestoreManager.shared
//    let bruteForce = BruteForce()
    let userService = CurrentUserService.shared
    var loginDelegate: LoginViewControllerDelegate?
    private let notification = NotificationCenter.default ///уведомление для того чтобы отслеживать перекрытие клавиатурой UITextField
    
//MARK: - ITEMs
    private let scrollLoginView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray5)
        return $0
    }(UIScrollView())
    
    private let contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private let logoItem: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "logo")
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView())
    
    private let loginStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 0.5
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.createColor(lightMode: .lightGray, darkMode: .lightGray).cgColor
        $0.backgroundColor = UIColor.createColor(lightMode: .systemGray6, darkMode: .systemGray6)
        $0.clipsToBounds = true
        return $0
    }(UIStackView())

    private lazy var loginTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.placeholder = NSLocalizedString("login", comment: "")
        $0.tag = 1
        $0.delegate = self
        $0.tintColor = UIColor.createColor(lightMode: .AccentColor.normal, darkMode: .AccentColor.normal)                           ///цвет курсора
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)  ///сдвиг курсора на 5пт в textField (для красоты)
        $0.autocapitalizationType = .none
        $0.backgroundColor = UIColor.createColor(lightMode: .systemGray6, darkMode: .systemGray4)
        return $0
    }(UITextField())
   
    private lazy var loginAlert: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor.createColor(lightMode: .systemRed, darkMode: .systemRed)
        $0.font = UIFont.systemFont(ofSize: 13, weight: .light)
        return $0
    }(UILabel())
    
    private lazy var loginView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderColor = UIColor.createColor(lightMode: .lightGray, darkMode: .lightGray).cgColor
        $0.layer.borderWidth = 0.5
//        $0.backgroundColor = UIColor.createColor(lightMode: .systemGray6, darkMode: .systemGray6)
        return $0
    }(UIView())
    
    private lazy var passTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.placeholder = NSLocalizedString("pass", comment: "")
        $0.tag = 2
        $0.delegate = self
        $0.tintColor = UIColor.createColor(lightMode: .AccentColor.normal, darkMode: .AccentColor.normal)                           ///цвет курсора
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)  ///сдвиг курсора на 5пт в textField (для красоты)
        $0.backgroundColor = UIColor.createColor(lightMode: .systemGray6, darkMode: .systemGray4)
        $0.isSecureTextEntry = true
        return $0
    }(UITextField())
    
    private lazy var passAlert: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor.createColor(lightMode: .systemRed, darkMode: .systemRed)
        $0.font = UIFont.systemFont(ofSize: 13, weight: .light)
        return $0
    }(UILabel())

    private lazy var loginButton: CustomButton = {
        let button = CustomButton(
            title: NSLocalizedString("signin", comment: ""),
            background: UIColor.createColor(lightMode: .AccentColor.normal, darkMode: .AccentColor.normal),
            tapAction:  { [weak self] in self?.tapLoginButton() })
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.createColor(lightMode: .black, darkMode: .black).cgColor
        button.layer.shadowOpacity = 0.7
        return button
    }()
    
    private lazy var signUpButton: CustomButton = {
        let button = CustomButton(
            title: NSLocalizedString("signup", comment: ""),
            titleColor: UIColor.createColor(lightMode: .AccentColor.normal, darkMode: .AccentColor.normal),
            background: UIColor.createColor(lightMode: .systemGray6, darkMode: .systemGray6),
            tapAction:  { [weak self] in self?.tapSignUpButton() })
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.createColor(lightMode: .AccentColor.normal, darkMode: .AccentColor.normal).cgColor
        button.layer.borderWidth = 1
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.createColor(lightMode: .black, darkMode: .black).cgColor
        button.layer.shadowOpacity = 0.7
        return button
    }()
    
    var errorsLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        $0.textColor = UIColor.createColor(lightMode: .systemRed, darkMode: .systemRed)
        $0.alpha = 0.30
        $0.numberOfLines = 9
        return $0
    }(UILabel())
    
    private lazy var activitySign: UIActivityIndicatorView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.style = .large
        $0.color = UIColor.createColor(lightMode: .AccentColor.normal, darkMode: .AccentColor.normal)
        return $0
    }(UIActivityIndicatorView())
    
    
//MARK: - INITs
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        showLoginItems()
        view.addTapGestureToHideKeyboard() ///скрываем клавиатуру при нажатии вне поля textField
        #if DEBUG
            loginTextField.text = "22@ru.ru"
            passTextField.text = "222222"
        #else
            loginTextField.text = "11@ru.ru"
            passTextField.text = "111111"
        #endif
//        setupLogoGestures() ///запуск bruteforce
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true ///прячем NavigationBar
        notification.addObserver(self,
                                 selector: #selector(keyboardAppear),
                                 name: UIResponder.keyboardWillShowNotification,
                                 object: nil)
        notification.addObserver(self,
                                 selector: #selector(keyboardDisappear),
                                 name: UIResponder.keyboardWillHideNotification,
                                 object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        notification.removeObserver(self,
                                    name: UIResponder.keyboardWillShowNotification,
                                    object: nil)
        notification.removeObserver(self,
                                    name: UIResponder.keyboardWillHideNotification,
                                    object: nil)
    }
        
    override func viewDidAppear(_ animated: Bool) {
        loginTextField.animate(newText: placeHolder(loginTextField), characterDelay: 0.2)
        passTextField.animate(newText: placeHolder(passTextField), characterDelay: 0.2)
    }
    
    
//MARK: - METHODs
    @objc private func keyboardAppear(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollLoginView.contentInset.bottom = keyboardSize.height + 80
            scrollLoginView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0,
                                                                         left: 0,
                                                                         bottom: keyboardSize.height,
                                                                         right: 0)
        }
    }
    
    @objc private func keyboardDisappear() {
        scrollLoginView.contentInset = .zero
        scrollLoginView.verticalScrollIndicatorInsets = .zero
    }
        
    private func tapLoginButton() {
        viewModel.statusEntry = true
        
        checkInputedData(loginTextField, loginAlert)
        UIView.animate(withDuration: 4.5, delay: 0.0, options: .curveEaseOut) { [self] in
            errorsLabel.text = validateEmail(loginTextField)
            errorsLabel.alpha = 1.0
            view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn) { [self] in
                errorsLabel.text = ""
                errorsLabel.alpha = 0.0
                view.layoutIfNeeded()
            } completion: { _ in  }
        }
        
        checkInputedData(passTextField, passAlert)
        
        if viewModel.statusEntry {
            if let login = loginTextField.text, let pass = passTextField.text {
                activitySign.startAnimating()
                loginDelegate?.signIn(login: login, pass: pass)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    if let user = self.userService.user {
                        self.userService.getUserData(from: user.login)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                            self.activitySign.stopAnimating()
                            if self.userService.userData != nil {
                                self.viewModel.load(to: .profile)
                            } else {
                                self.alertOfLogIn(title: "Error",
                                                  message: "Connection failed. Check your connection and try again later.")
                                try? self.viewModel.firebaseService.signOut()
                            }
                        })
                    } else {
                        self.alertOfLogIn(title: "Incorrect login or password",
                                          message: "Please, check inputed data.")
                    }
                })
            }
        }
    }

    private func tapSignUpButton() {
        print("sign up tapped")
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func alertOfLogIn(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Ok",
                                   style: .destructive) {
            _ in print("Отмена")
        }
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    private func validateEmail(_ textField: UITextField) -> String {
        var listOfErrorsToScreen = """
        """
        if textField.tag == 1 {
            if let email = textField.text {
                let validator = EmailValidator(email: email)
                print("Validator checked")
                if !validator.checkDomain() {
                    for (_, value) in validator.errors.enumerated() {
                        listOfErrorsToScreen = listOfErrorsToScreen + value.rawValue + "\n"
                    }
                    print("Cписок ошибок - \(listOfErrorsToScreen)")
                }
            }
        }
        return listOfErrorsToScreen
    }
        
    private func showLoginItems() {
        view.addSubview(scrollLoginView)
        
        NSLayoutConstraint.activate([
            scrollLoginView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollLoginView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollLoginView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollLoginView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        scrollLoginView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollLoginView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollLoginView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollLoginView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollLoginView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollLoginView.widthAnchor)
        ])
        
        [logoItem, loginStack, activitySign, loginButton, signUpButton, errorsLabel].forEach({ contentView.addSubview($0) })
        loginView.addSubview(loginTextField)
        [loginView, passTextField].forEach({ loginStack.addArrangedSubview($0) })
        [loginAlert, passAlert].forEach({ contentView.addSubview($0) })
        
        NSLayoutConstraint.activate([
            logoItem.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 120),
            logoItem.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoItem.widthAnchor.constraint(equalToConstant: 100),
            logoItem.heightAnchor.constraint(equalToConstant: 100),
            
            loginTextField.topAnchor.constraint(equalTo: loginView.topAnchor),
            loginTextField.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            loginTextField.trailingAnchor.constraint(equalTo: loginView.trailingAnchor),
            loginTextField.bottomAnchor.constraint(equalTo: loginView.bottomAnchor),

            loginStack.topAnchor.constraint(equalTo: logoItem.bottomAnchor, constant: 120),
            loginStack.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginStack.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginStack.heightAnchor.constraint(equalToConstant: 100),
            
            activitySign.topAnchor.constraint(equalTo: logoItem.bottomAnchor, constant: 20),
            activitySign.centerXAnchor.constraint(equalTo: logoItem.centerXAnchor),

            loginButton.topAnchor.constraint(equalTo: loginStack.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: logoItem.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            //loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            errorsLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            errorsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            errorsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            errorsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            loginAlert.centerYAnchor.constraint(equalTo: loginTextField.centerYAnchor),
            loginAlert.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor, constant: -5),
            loginAlert.widthAnchor.constraint(equalToConstant: 220),
            
            passAlert.centerYAnchor.constraint(equalTo: passTextField.centerYAnchor),
            passAlert.trailingAnchor.constraint(equalTo: passTextField.trailingAnchor, constant: -5),
            passAlert.widthAnchor.constraint(equalToConstant: 220),
            
            signUpButton.topAnchor.constraint(equalTo: loginButton.topAnchor),
            signUpButton.leadingAnchor.constraint(equalTo: logoItem.trailingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

//MARK: убираем клавиатуру по нажатию Enter (Return)
extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

//extension LogInViewController {
//    private func setupLogoGestures() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLogo))
//        logoItem.addGestureRecognizer(tapGesture)
//    }
//
//    @objc private func tapLogo (){
//        users[4].password = bruteForce.generatePass()
//        print("generate new pass = \(users[4].password)")
//
//        let queue = OperationQueue()
//        let operation = Operation()
//
//        queue.addBarrierBlock {
//            OperationQueue.main.addOperation { [weak self] in
//                self?.startIndicator()
//            }
//            self.bruteForce.findPass()
//        }
//
//        operation.completionBlock = {
//            OperationQueue.main.addOperation { [weak self] in
//                self?.stopIndicator()
//            }
//        }
//
//        queue.addOperation(operation)
//    }
//
//    func startIndicator() {
//        self.activitySign.startAnimating()
//        print("animate")
//        self.activitySign.isHidden = false
//    }
//
//    func stopIndicator() {
//        self.activitySign.stopAnimating()
//        print("stop animate")
//        self.activitySign.isHidden = true
//        self.pass.isSecureTextEntry = false
//        self.pass.text = self.bruteForce.password
//    }
//}
