
import UIKit

//MARK: код для обработки HEX цветов
//(вводятся в формате 0xFF или 0xFFFFFF)
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
    //How to use this ^^^ code:
    //let color = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF, a: 0.5)
    //let color2 = UIColor(rgb: 0xFFFFFF, a: 0.5)
    
    struct AccentColor {
        static var normal: UIColor  { return UIColor(rgb: 0x4885CC, a: 1.0) }
        static var highlightened: UIColor { return UIColor(rgb: 0x4885CC, a: 0.8) } ///не используется
        static var selected: UIColor { return UIColor(rgb: 0x4885CC, a: 0.8) }      ///не используется
        static var disabled: UIColor { return UIColor(rgb: 0x4885CC, a: 0.8) }      ///не используется
    }
}
