
import UIKit

class FeedModel {
    private let secretWord = "111"
    
    func check(word: String) -> UIColor {
        return word == secretWord ? .systemGreen : .systemRed
    }
}

struct PlanetModel: Decodable {
    var name: String
    var orbitalPeriod: String
    var population: String
    var residents: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case orbitalPeriod = "orbital_period"
        case population
        case residents
    }
}

struct CitizenModel: Decodable {
    var name: String
}
