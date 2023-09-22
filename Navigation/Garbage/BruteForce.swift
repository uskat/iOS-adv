//
//  BruteForce.swift
//  Navigation
//
//  Created by Diego Abramoff on 07.06.23.
//

import Foundation

class BruteForce {
    let allowedChars = String().printable
    var password: String = ""
    
    func generatePass() -> String {
        let passLength = 4
        return  String((0..<passLength)
                        .map{ _ in String().printable.randomElement() }
                        .compactMap{ $0 })
    }
    
    func findPass() {
        var currentChar: Character = allowedChars.last!
        var currentSerialNumber = -1
        var isDigitChanged: Bool = false
        while password != users[4].password {
            enumerationOf(char: &currentChar, in: &currentSerialNumber, with: &isDigitChanged, of: &password)
        }
        print("password have been founded = \(password)")
    }
    
    func enumerationOf(char lastChar: inout Character,
                       in serial: inout Int,
                       with isDigitChanged: inout Bool,
                       of newPass: inout String) {
        guard let index = allowedChars.firstIndex(of: lastChar) else { return }
        var arrayOfPass = Array(newPass)
        
        if lastChar == allowedChars.last! {
            if checkLast(serial, in: newPass) {
                lastChar = allowedChars.first!
                if serial >= 0 {
                    arrayOfPass[serial] = lastChar
                }
                arrayOfPass.append(lastChar)
                newPass = String(arrayOfPass)
                serial = 0
            } else {
                arrayOfPass[serial] = allowedChars.first!
                newPass = String(arrayOfPass)
                serial += 1
                lastChar = arrayOfPass[serial]
                isDigitChanged = true
                enumerationOf(char: &lastChar, in: &serial, with: &isDigitChanged, of: &newPass)
            }
        } else {
            let nextIndex = allowedChars.index(after: index)
            lastChar = allowedChars[nextIndex]
            arrayOfPass[serial] = lastChar
            newPass = String(arrayOfPass)
            if isDigitChanged {
                serial = 0
                lastChar = allowedChars.first!
                isDigitChanged = false
            }
        }
        
        func checkLast(_ serial: Int, in pass: String) -> Bool {
            if serial == pass.count - 1 {
                return true
            } else {
                return false
            }
        }
    }
}
