
import UIKit
import iOSIntPackage

class ProfileHeaderView: UIView {
    
    private var topProfileImage = NSLayoutConstraint()
    private var leadingProfileImage = NSLayoutConstraint()
    private var trailingProfileImage = NSLayoutConstraint()
    private var widthProfileImage = NSLayoutConstraint()
    private var heightProfileImage = NSLayoutConstraint()
    
    private var statusEntry = true //кстл
    private var statusText = "Waiting for something....."
    private let space: CGFloat = 16
    var timer: Timer?
    var timer1: Timer?
    var counter: Float = 0.0
    
    //MARK: - ITEMs
    private let viewUnderImage: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = false
        $0.alpha = 0.0
        return $0
    }(UIView())
    
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = sizeProfileImage / 2
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray).cgColor
        imageView.contentMode = .scaleAspectFill        ///полное заполнение
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let profileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor.createColor(lightMode: .black, darkMode: .systemGray)
//        label.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        return label
    }()
    
    private lazy var mainButton: CustomButton = {
        let button = CustomButton(
            title: NSLocalizedString("profile.setStatusN", comment: ""),
            titleHighlighted: NSLocalizedString("profile.setStatusH", comment: ""), titleColor: UIColor.createColor(lightMode: .white, darkMode: .lightGray),
            tapAction: { [weak self] in self?.tapMainButton() })
        button.layer.cornerRadius = 4
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.createColor(lightMode: .black, darkMode: .lightGray).cgColor
        button.layer.shadowOpacity = 0.7
        return button
    }()
    
    let profileStatus: UILabel = {
        let status = UILabel()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        status.textColor = UIColor.createColor(lightMode: .darkGray, darkMode: .systemGray3)
        status.text = "Waiting for something....."
//        status.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        return status
    }()
    
    private lazy var editStatus: UITextField = {
        let status = UITextField()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        status.placeholder = NSLocalizedString("profile.typeStatus", comment: "")          ///текстовая подсказка в поле textField
        status.adjustsFontSizeToFitWidth = true         ///уменьшение шрифта, если введенный текст не помещается
        status.minimumFontSize = 10                     ///до какого значения уменьшается шрифт
        status.tag = 3
        status.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray4)
        status.layer.cornerRadius = 12
        status.layer.borderWidth = 1
        status.layer.borderColor = UIColor.createColor(lightMode: .black, darkMode: .systemGray3).cgColor
        status.tintColor = UIColor.createColor(lightMode: .AccentColor.normal, darkMode: .AccentColor.normal)                         ///цвет курсора
        status.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0) ///сдвиг курсора на 5пт в textField (для красоты)
        status.addTarget(self, action: #selector(beginToEditStatus), for: .allEditingEvents)
        status.addTarget(self, action: #selector(changeStatusText), for: .editingChanged)
        status.addTarget(self, action: #selector(endToEditStatus), for: .editingDidEndOnExit)
        return status
    }()
    
    private lazy var statusAlert: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor.createColor(lightMode: .systemRed, darkMode: .systemRed)
        $0.font = UIFont.systemFont(ofSize: 13, weight: .light)
        return $0
    }(UILabel())
    
    private lazy var buttonAccept: CustomButton = {
        let button = CustomButton(
            tapAction: { [weak self] in self?.tapAcceptStatusButton() })
        button.layer.cornerRadius = 9
        button.setImage(UIImage(systemName: "checkmark.rectangle.portrait"), for: .normal)
        button.tintColor = UIColor.createColor(lightMode: .white, darkMode: .lightGray)
        button.isHidden = true
        return button
    }()
    
    //======================================================================================================
    private lazy var buttonX: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 12
        $0.backgroundColor = UIColor.createColor(lightMode: .AccentColor.normal, darkMode: .AccentColor.normal)
        $0.setImage(UIImage(systemName: "x.circle"), for: .normal)
        $0.tintColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray)
        $0.alpha = 0.0
        $0.isHidden = true
        $0.addTarget(self, action: #selector(tapButtonX), for: .touchUpInside)
        return $0
    }(UIButton())
    //======================================================================================================
    
    private lazy var yodaPhrase: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "ЖИ-ШИ ПИШИ С БУКВОЙ И..."
        $0.textColor = UIColor.createColor(lightMode: .yellow, darkMode: .systemYellow)
        $0.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 22)
        $0.alpha = 0.0
        return $0
    }(UILabel())
    
    private lazy var yodaTimer: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = ""
        $0.textColor = UIColor.createColor(lightMode: .yellow, darkMode: .systemYellow)
        $0.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 40)
        $0.alpha = 0.0
        return $0
    }(UILabel())
    
    
    //MARK: - INITs
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTapGestureToHideKeyboard() ///скрываем клавиатуру при нажатии вне поля textField
        showProfileHeaderView()
        tapGestureOnProfileImage() ///жест: запускаем анимацию появления аватарки на весь экран
        //анимированное появление текста в TextField (в extension UITextField дописана функция анимации)
        self.editStatus.animate(newText: placeHolder(editStatus), characterDelay: 0.2)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - METHODs
    @objc private func tapButtonX() {
        print("tap x")
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn) { [self] in
            topProfileImage.constant = space
            leadingProfileImage.constant = space
            widthProfileImage.constant = sizeProfileImage
            heightProfileImage.constant = sizeProfileImage
            profileImage.layer.cornerRadius = sizeProfileImage / 2
            profileImage.layer.borderWidth = 3
            viewUnderImage.alpha = 0.0
            layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut) { [self] in
                buttonX.alpha = 0.0
            } completion: { _ in
                self.buttonX.isHidden = true
            }
        }
        
        timer?.invalidate()
        timer1?.invalidate()
    }
    
    @objc private func tapMainButton() {
        checkInputedData(&statusEntry, editStatus, statusAlert)
        profileStatus.text = statusText
        editStatus.text = ""
        endEditing(true)
        rotateAndSleep(0) ///прячем вспомогательную кнопку без анимации
    }
    
    @objc private func beginToEditStatus(_ textField: UITextField) {
        buttonAccept.isHidden = false
    }
    @objc private func changeStatusText(_ textField: UITextField) {
        buttonAccept.isHidden = false
        if let myText = textField.text {
            statusText = myText
        }
    }
    
    @objc private func endToEditStatus(_ textField: UITextField) {
        rotateAndSleep(0) ///прячем вспомогательную кнопку без анимации
    }
    
    private func hideKbd() {
        editStatus.endEditing(true)
    }
    
    //Метод вызывается, когда пользователь кликает на view за пределами TextField (убирает клавиатуру)
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if touches.first != nil {
//            endEditing(true)
//        }
//        super.touchesBegan(touches, with: event)
//    }
    
    @objc private func tapAcceptStatusButton() {
        checkInputedData(&statusEntry, editStatus, statusAlert)
        endEditing(true)
        profileStatus.text = statusText
        editStatus.text = ""
        rotateAndSleep(1) ///прячем вспомогательную кнопку с анимацией (после нажатия на неё)
    }
    
    private func showProfileHeaderView() {
        [profileLabel, mainButton, profileStatus, editStatus, buttonAccept].forEach { self.addSubview($0) }
        
        NSLayoutConstraint.activate([
            profileLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 27),
            profileLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: sizeProfileImage + 2 * space),
            profileLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -space),
            profileLabel.heightAnchor.constraint(equalToConstant: 30),

            mainButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: sizeProfileImage + 2 * space),
            mainButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: space),
            mainButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -space),
            mainButton.heightAnchor.constraint(equalToConstant: 50),

            profileStatus.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -space - 46),
            profileStatus.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: sizeProfileImage + 2 * space),
            profileStatus.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -space),
            profileStatus.heightAnchor.constraint(equalToConstant: 26),

            editStatus.bottomAnchor.constraint(equalTo: mainButton.topAnchor, constant: -space / 2 - 6),
            editStatus.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: sizeProfileImage + 2 * space),
            editStatus.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -space),
            editStatus.heightAnchor.constraint(equalToConstant: 40),

            buttonAccept.topAnchor.constraint(equalTo: editStatus.topAnchor, constant: 5),
            buttonAccept.trailingAnchor.constraint(equalTo: editStatus.trailingAnchor, constant: -5),
            buttonAccept.widthAnchor.constraint(equalToConstant: 30),
            buttonAccept.heightAnchor.constraint(equalToConstant: 30)
        ])
       
        [viewUnderImage, profileImage, buttonX, yodaPhrase, yodaTimer].forEach { self.addSubview($0) }
        viewUnderImage.addSubview(blurBackgroundEffect())
               
        topProfileImage = profileImage.topAnchor.constraint(equalTo: viewUnderImage.topAnchor, constant: space)
        leadingProfileImage = profileImage.leadingAnchor.constraint(equalTo: viewUnderImage.leadingAnchor, constant: space)
        widthProfileImage = profileImage.widthAnchor.constraint(equalToConstant: sizeProfileImage)
        heightProfileImage = profileImage.heightAnchor.constraint(equalToConstant: sizeProfileImage)
        
        NSLayoutConstraint.activate([
            viewUnderImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            viewUnderImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            viewUnderImage.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            viewUnderImage.heightAnchor.constraint(equalToConstant: screenHeight),
            
            topProfileImage, leadingProfileImage, widthProfileImage, heightProfileImage,
            
            buttonX.topAnchor.constraint(equalTo: viewUnderImage.topAnchor, constant: 20),
            buttonX.trailingAnchor.constraint(equalTo: viewUnderImage.trailingAnchor, constant: -20),
            buttonX.widthAnchor.constraint(equalToConstant: 24),
            buttonX.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

//MARK: =================================== METHODs ===================================
    private func rotateAndSleep(_ key: Int) {
        if key == 1 { ///анимация вращения вокруг своей оси на вспомогательной кнопке
            var perspective = CATransform3DIdentity
            perspective.m34 = 1 / -200
            buttonAccept.imageView!.layer.transform = perspective
            let rotate = CABasicAnimation(keyPath: "transform.rotation.y")
            rotate.fromValue = 0
            rotate.byValue = CGFloat.pi * 2
            rotate.duration = 2
            buttonAccept.imageView!.layer.add(rotate, forKey: nil)
        }
        //скрываем кнопку через 2 секунды (чтобы успела пройти анимация)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: { ///задержка выполнения любой команды
            self.buttonAccept.isHidden = true
        })
    }

    //MARK: жесты и анимация
    private func tapGestureOnProfileImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnImage))
        profileImage.addGestureRecognizer(tapGesture)
    }

    @objc private func tapOnImage() {
        print("tap")
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut) { [self] in
            viewUnderImage.addSubview(blurBackgroundEffect())
            if (UIScreen.main.bounds.height > UIScreen.main.bounds.width) {
                topProfileImage.constant = UIScreen.main.bounds.height / 2 - absoluteWidth / 2 - 80
                leadingProfileImage.constant = 0
                trailingProfileImage.constant = 0
            } else {
                topProfileImage.constant = 0
                leadingProfileImage.constant = UIScreen.main.bounds.width / 2 - absoluteWidth / 2
                trailingProfileImage.constant = UIScreen.main.bounds.width / 2 + absoluteWidth / 2
            }
            widthProfileImage.constant = absoluteWidth
            heightProfileImage.constant = absoluteWidth
            profileImage.layer.cornerRadius = 0
            profileImage.layer.borderWidth = 0
            viewUnderImage.alpha = 0.85
            layoutIfNeeded()
            viewUnderImage.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut) { [self] in
                buttonX.isHidden = false
                buttonX.alpha = 1.0
            } completion: { _ in  }
        }
        
        let imageProcessor = ImageProcessor()
        imageProcessor.processImage(sourceImage: UIImage(named: "yoda")!, filter: .bloom(intensity: 5.0)) {
            self.profileImage.image = $0
            self.flyingLabel()
        }

        timer1 = Timer.scheduledTimer(withTimeInterval: 7.0, repeats: false, block: { _ in
            self.profileImage.image = UIImage(named: "yoda") ?? UIImage()
            self.counter = 0.0
        })
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            self.counter += 0.1
            self.yodaTimer.text = String(format: "%.1f", self.counter) + "сек"
        })
    }
    
    func blurBackgroundEffect() -> UIVisualEffectView {
        //код BlurEffect укороченный без констрейнтов
        let effect = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
        effect.alpha = 0.85
        effect.translatesAutoresizingMaskIntoConstraints = false
        effect.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return effect
    }
}

extension ProfileHeaderView {
    private func flyingLabel() {
        self.yodaPhrase.alpha = 1.0
        self.yodaTimer.alpha = 1.0
        let phraseXconstraint = self.yodaPhrase.leadingAnchor.constraint(equalTo: self.profileImage.leadingAnchor, constant: 6)
        let phraseYconstraint = self.yodaPhrase.bottomAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: -200)
        let timerXconstraint = self.yodaTimer.centerXAnchor.constraint(equalTo: self.profileImage.centerXAnchor)
        let timerYconstraint = self.yodaTimer.bottomAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: -6)
        NSLayoutConstraint.activate([phraseXconstraint, phraseYconstraint, timerXconstraint, timerYconstraint])
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 5.0, delay: 0.0, options: .curveEaseOut) { [weak self] in
            phraseXconstraint.constant += 100
            phraseYconstraint.constant += -150
            self?.yodaPhrase.alpha = 0.5
            self?.yodaTimer.alpha = 0.5
            self?.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 1.8, delay: 0.0, options: .curveLinear) { [weak self] in
                self?.yodaPhrase.alpha = 0.0
                self?.yodaTimer.alpha = 0.0
                self?.yodaTimer.text = ""
//                self.layoutIfNeeded()
            } completion: { _ in
                NSLayoutConstraint.deactivate([phraseXconstraint, phraseYconstraint, timerXconstraint, timerYconstraint])
            }
        }
    }
}
