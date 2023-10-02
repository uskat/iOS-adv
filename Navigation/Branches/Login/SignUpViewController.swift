
import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    private let viewModel = ProfileViewModel()
    private let notification = NotificationCenter.default ///уведомление для того чтобы отслеживать перекрытие клавиатурой UITextField

//MARK: - ITEMs
    private let scrollLoginView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
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

    private let stackLogin: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 0.5
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.backgroundColor = .systemGray6
        $0.clipsToBounds = true
        return $0
    }(UIStackView())

    private lazy var loginTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.5
        $0.placeholder = NSLocalizedString("login", comment: "")
        $0.tag = 1
        $0.tintColor = UIColor.AccentColor.normal                           ///цвет курсора
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)  ///сдвиг курсора на 5пт в textField (для красоты)
        $0.autocapitalizationType = .none
        $0.backgroundColor = .systemGray6
        return $0
    }(UITextField())

    private lazy var loginAlert: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .systemRed
        $0.font = UIFont.systemFont(ofSize: 13, weight: .light)
        return $0
    }(UILabel())

    private lazy var passTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.placeholder = NSLocalizedString("pass", comment: "")
        $0.tag = 2
        $0.tintColor = UIColor.AccentColor.normal                           ///цвет курсора
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)  ///сдвиг курсора на 5пт в textField (для красоты)
        $0.backgroundColor = .systemGray6
        $0.isSecureTextEntry = true
        return $0
    }(UITextField())

    private lazy var passAlert: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .systemRed
        $0.font = UIFont.systemFont(ofSize: 13, weight: .light)
        return $0
    }(UILabel())

    private lazy var nameTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.5
        $0.placeholder = NSLocalizedString("name", comment: "")
        $0.tag = 4
//            $0.delegate = self
        $0.tintColor = UIColor.AccentColor.normal                           ///цвет курсора
        $0.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)  ///сдвиг курсора на 5пт в textField (для красоты)
        $0.backgroundColor = .systemGray6
        return $0
    }(UITextField())
    
    private lazy var signUpButton: CustomButton = {
        let button = CustomButton(
            title: NSLocalizedString("signup", comment: ""),
            background: UIColor.AccentColor.normal,
            tapAction:  { [weak self] in self?.tapSignUpButton() })
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        return button
    }()

    var errorsLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        $0.textColor = .systemRed
        $0.alpha = 0.30
        $0.numberOfLines = 9
        return $0
    }(UILabel())

//MARK: - INITs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addTapGestureToHideKeyboard()
        showLoginItems()
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
        nameTextField.animate(newText: placeHolder(nameTextField), characterDelay: 0.2)
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

    private func tapSignUpButton() {
        print("sign up tapped")
        var reason = """
        """
        var reasonCount = 0
        
        if validateEmail(loginTextField) != "" {
            reason += validateEmail(loginTextField)
            reasonCount += 1
        }
        
        if passTextField.text?.count ?? 0 < 6 {
            reason += "Password must contain more than 6 characters\n"
            reasonCount += 1
        }
        
        if nameTextField.text?.count ?? 0 < 3 {
            reason += "Username must contain more than 3 characters\n"
            reasonCount += 1
        }
        
        if reasonCount == 0 {
            if let login = loginTextField.text, let pass = passTextField.text, let name = nameTextField.text {
                viewModel.firebaseService.signUp(withEmail: login, withPass: pass, completion: { result in
                    let userService = CurrentUserService.shared
                    switch result {
                    case .success(let user):
                        userService.addUserData(to: user.login, name: name, status: "Hello, my padawan!")
                        do {
                            try self.viewModel.firebaseService.signOut()
                        } catch {
                            print("")
                        }
                        self.alertOfSignUp(title: "You have registered successfully",
                                           message: "To log in, enter your email and password.",
                                           refreshTag: true)
                        print("✅ registration was successful. Dump = \(dump(user))")
                    case .failure(let error):
                        self.alertOfSignUp(title: "Registration failed",
                                           message: "\(error)")
                        print("⛔️ registration failed, cause = \(error)")
                    }
                })
            }
        } else {
            self.alertOfSignUp(title: "Registration failed",
                               message: "\(reason)")
        }
    }

    private func alertOfSignUp(title: String, message: String, refreshTag: Bool = false) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let done = UIAlertAction(title: "Ок",
                                 style: .default) { _ in
            print("Ок")
            if refreshTag {
                self.navigationController?.popToRootViewController(animated: true)
                self.view.endEditing(true)
            }
        }
        alert.addAction(done)
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

        [logoItem, stackLogin, errorsLabel, signUpButton].forEach({ contentView.addSubview($0) })
        [loginTextField, passTextField, nameTextField].forEach({ stackLogin.addArrangedSubview($0) })
        [loginAlert, passAlert].forEach({ contentView.addSubview($0) })

        NSLayoutConstraint.activate([
            logoItem.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoItem.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoItem.widthAnchor.constraint(equalToConstant: 100),
            logoItem.heightAnchor.constraint(equalToConstant: 100),

            stackLogin.topAnchor.constraint(equalTo: logoItem.bottomAnchor, constant: 80),
            stackLogin.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackLogin.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackLogin.heightAnchor.constraint(equalToConstant: 150),

            signUpButton.topAnchor.constraint(equalTo: stackLogin.bottomAnchor, constant: 16),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),

            errorsLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 16),
            errorsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            errorsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            errorsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            loginAlert.centerYAnchor.constraint(equalTo: loginTextField.centerYAnchor),
            loginAlert.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor, constant: -5),
            loginAlert.widthAnchor.constraint(equalToConstant: 220),

            passAlert.centerYAnchor.constraint(equalTo: passTextField.centerYAnchor),
            passAlert.trailingAnchor.constraint(equalTo: passTextField.trailingAnchor, constant: -5),
            passAlert.widthAnchor.constraint(equalToConstant: 220),
        ])
    }
}

//MARK: убираем клавиатуру по нажатию Enter (Return)
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
