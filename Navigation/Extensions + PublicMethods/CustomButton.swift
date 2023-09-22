
import UIKit

//MARK: кастомная кнопка с изменением альфа-канала для разных её состояний
class CustomButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            if (isHighlighted) {
                alpha = 0.8
            } else {
                alpha = 1
            }
        }
    }
    override var isSelected: Bool {
        didSet {
            if (isSelected) {
                alpha = 0.8
            } else {
                alpha = 1
            }
        }
    }
    
    var tapAction: (() -> Void)?
    
    init(title: String = "", titleHighlighted: String? = nil,
         titleColor: UIColor = .white, titleHighlightedColor: UIColor? = nil,
         background: UIColor = .systemBlue,
         tapAction: (() -> Void)? = nil) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = background
        
        self.tapAction = tapAction
        setTitle(title, for: .normal)
        setTitle(titleHighlighted ?? title, for: .highlighted)
        setTitleColor(titleColor, for: .normal)
        setTitleColor(titleHighlightedColor ?? titleColor, for: .highlighted)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    @objc private func buttonTapped() {
        print("Кнопка CustomButon нажата: передаем нажатие в контроллер")
        tapAction?()
    }
}
