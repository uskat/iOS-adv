
import UIKit
import Foundation


//MARK: ===================================  LOGIN  ===================================
func placeHolder(_ textField: UITextField) -> String {
    switch textField.tag {
    case 1: return NSLocalizedString("login", comment: "")
    case 2: return NSLocalizedString("pass", comment: "")
    case 3: return NSLocalizedString("profile.typeStatus", comment: "")
    case 4: return NSLocalizedString("name", comment: "")
    default: return "Type something..."
    }
}
    
public func checkInputedData(_ textField: UITextField, _ alert: UILabel) {
    var lengthFrom = 0
    var lengthTo = 0
    var message = ""
    switch textField.tag {
    case 1: lengthFrom = 1
            lengthTo = 3
            message = "Login must be at least 3 chars"
    case 2: lengthFrom = 1
            lengthTo = 6
            message = "Password must be at least 6 chars"
    case 3: lengthFrom = 1000
            lengthTo = 1000
    default: print("status textField ?")
    }
    
    if let count = textField.text?.count {
        switch count {
        case 0:                     shakeMeBaby(textField)
                                    changeTextFieldColorAndText(textField, placeHolder(textField))
                                    checkStatus(false)
        case lengthFrom..<lengthTo: if textField.tag == 3 {
                                        print("Сообщение об ошибке для строки profileStatus не выводим!")
                                    } else {
                                        shakeMeBaby(textField)
                                        alertMessageOnTextField(alert, message)
                                        checkStatus(false)
                                    }
        case lengthTo...:           checkStatus(true)
        default:                    break
        }
    }
}

private func changeTextFieldColorAndText(_ textField: UITextField, _ message: String) {
    textField.attributedPlaceholder = NSAttributedString(string: message, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
        textField.attributedPlaceholder = NSAttributedString(string: placeHolder(textField), attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
    })
}

public func alertMessageOnTextField(_ alert: UILabel, _ message: String) {
    alert.text = message
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
        alert.text = ""
    })
}
    
private func shakeMeBaby(_ shakedItem: UITextField) {
    let shake = CABasicAnimation(keyPath: "position")
    let xDelta = CGFloat(3)
    shake.duration = 0.07
    shake.repeatCount = 4
    shake.autoreverses = true

    let from_point = CGPoint(x: shakedItem.center.x - xDelta, y: shakedItem.center.y)
    let from_value = NSValue(cgPoint: from_point)

    let to_point = CGPoint(x: shakedItem.center.x + xDelta, y: shakedItem.center.y)
    let to_value = NSValue(cgPoint: to_point)

    shake.fromValue = from_value
    shake.toValue = to_value
    shake.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    shakedItem.layer.add(shake, forKey: "position")
}

private func checkStatus(_ status: Bool) {
    let viewModel = ProfileViewModel()
    viewModel.statusEntry = viewModel.statusEntry ? status : false
}
