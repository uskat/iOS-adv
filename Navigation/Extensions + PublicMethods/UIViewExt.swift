
import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView { ///анимированное появление текста - сама анимация к UILabel и UITextField (см.extensions к ним)
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: "kCATransitionFade")
    }
}

//Убираем клавиатуру при тапе вне textField в любой view
extension UIView {
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }

    var topSuperview: UIView? {
        var view = superview
        while view?.superview != nil {
            view = view!.superview
        }
        return view
    }

    @objc func dismissKeyboard() {
        topSuperview?.endEditing(true)
    }
}
