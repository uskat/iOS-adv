
import UIKit
import AVFoundation

extension UITextField { ///анимированное появление текстовой подсказки в поле UITextField

    func animate(newText: String, characterDelay: TimeInterval) {
        DispatchQueue.main.async {
            self.placeholder = ""
            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.placeholder?.append(character)
                    self.fadeTransition(characterDelay) /// это анимация проявления
                    //let systemSoundID: SystemSoundID = 1104
                    //AudioServicesPlaySystemSound (systemSoundID)
                }
            }
        }
    }
}
