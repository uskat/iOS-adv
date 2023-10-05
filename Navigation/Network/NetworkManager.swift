//
//  NetworkManager.swift
//  Navigation
//
//  Created by Diego Abramoff on 03.07.23.
//

import Foundation

enum AppConfiguration: String, CaseIterable {
    case films = "https://swapi.dev/api/films/"
    case vehicles = "https://swapi.dev/api/vehicles/"
    case starships = "https://swapi.dev/api/starships/"
    
    static var allCases: [AppConfiguration] {
        return [.films, .vehicles, .starships]
    }
    
    static var randomURL: String {
        AppConfiguration.allCases.randomElement()!.rawValue
    }

    var url: URL? {
        URL(string: self.rawValue)
    }
}

struct NetworkManager {
        
    static func request(for url: String) {
        guard let url = URL(string: url) else { return }
//        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
//            print("data:")
//            print("-----------------")
            if let data = data {
//                if let string = String(data: data, encoding: .utf8) {
//                    print("\(string)")
//                }
            }
//            print("=================")
//            print("response")
//            if let response = response as? HTTPURLResponse {
//                print("   .allHeaderFields:")
//                print("-----------------")
//                print("   \(response.allHeaderFields)")
//                print("=================")
//                print("   .statusCode:")
//                print("-----------------")
//                print("   \(response.statusCode)")
//            }
//            print("=================")
//            print("error:")
//            print("-----------------")
            if let error = error {
                print("\(error)")
            }
        }
        dataTask.resume()
    }
}
