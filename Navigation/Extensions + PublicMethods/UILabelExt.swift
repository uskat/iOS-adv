
import UIKit
import AVFoundation

extension UILabel { ///анимированное появление текста в поле UILabel

    func animate(newText: String, characterDelay: TimeInterval) {
        DispatchQueue.main.async {
            self.text = ""
            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                    self.fadeTransition(characterDelay) /// это анимация проявления
                    //let systemSoundID: SystemSoundID = 1104
                    //AudioServicesPlaySystemSound (systemSoundID)
                }
            }
        }
    }
}
