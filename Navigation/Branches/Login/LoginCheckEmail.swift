
import UIKit

public enum ErrorInEmail: String {
    case dots = "The address cannot contain the character \".\" at the beginning, at the end, or twice"
                        //"Адрес не может содержать символ \".\" в начале, в конце или дважды"
    case at = "Email must contains \"@\" symbol"
                        //"Email должен содержать символ \"@\""
    case domainLength = "Level 1 domain must not be shorter than 2 characters"
                        //"Домен 1-го уровня не должен быть короче 2 символов"
    case totalLength = "Total email length must not exceed 256 characters"
                        //"Общая длина Email не должна превышать 256 символов"
    case nameLength = "The length of the email address name must be between 1 and 64 characters"
                        //"Длина имени почтового адреса должна быть от 1 до 64 символов"
    case chars = "Email contains invalid characters"
                        //"Email содержит недопустимые символы"
    case domain = "Domain name is too short"
                        //"Слишком короткое доменное имя"
}

class EmailValidator {

    var errors: [ErrorInEmail] = []
    var email: String
    var status: Bool = true
    var level: Int = 1
    
    init(email: String) {
        self.email = email
    }
    
    func allBad(_ error: ErrorInEmail) {
        errors.append(error)
        status = false
    }
    
    func checkDomain() -> Bool {
        errors = []
        let email1 = email.reversed()
        var count = 0
        if !email.contains("@") {
            allBad(.at)
            level = 0
        }
        if email.count > 256 {
            allBad(.totalLength)
        }
        for (_, char) in email1.enumerated() {
            if char == "." && count >= 2 {
                break
            } else {
                if count >= email1.count - 3 {
                    allBad(.domainLength)
                    break
                }
            }
            count += 1
        }
        
        switch level {
        case 1:
                if email[email.startIndex] == "." {//проверка первого символа
                    allBad(.dots)
                } else {
                    if email[email.startIndex] == "@" {
                        allBad(.nameLength)
                    }
                }
                level += 1
        case 2:
            count = 0
            var dots = 0
            for (_, char) in email.enumerated() { //поиск @, проверки каждого символа адреса, последнего символа и длины адреса
                count += 1
                if char == "." {
                    if dots == 1 {
                        allBad(.dots)
                    } else {
                        dots += 1
                    }
                }
                if !(char >= "a" || char <= "z" || char >= "A" || char <= "Z" || char == "-" || char == "_") {
                    allBad(.chars)
                }
                if char == "@" {
                    if dots == 1 {
                        allBad(.dots)
                    }
                    switch count {
                    case ...1:   allBad(.nameLength)
                                 //break
                    case 2...64: print("Длина имени почтового адреса соответствует спецификации")
                    case 64...:  allBad(.nameLength)
                                 //break
                    default:     print("Непонятно как мы сюда можем попасть, но что поделать")
                    }
                } else {
                    if count >= email.count - 5 {
                        allBad(.domain)
                    } else {
                        level += 1
                    }
                }
            }
        case 3: print("")//проверка каждого символа имени сервера
        default: print("nothing")
        }
        return status
    }

}
