
//import StorageService
import UIKit

//MARK: ===================================  HEADER ===================================
public var screenWidth: CGFloat {
    return UIScreen.main.bounds.width
}
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}
public let sizeProfileImage: CGFloat = absoluteWidth / 3

//MARK: ===================================  LOGIN  ===================================
public var dictionaryOfUsers: [String: Int] = [ ///словарь емейлов пользователей
    "11@ru.ru": 0,
    "22@ru.ru": 1,
    "33@ru.ru": 2,
    "44@ru.ru": 3,
    "55@ru.ru": 4
]

public struct Users {
    var login: String
    var password: String
    var name: String
    var userImage: UIImage
    var status: String
}

public var users: [Users] = [   ///профили пользователей
    Users(login: "11@ru.ru", password: "111111", name: "Obi Wan Kenobi",
          userImage: UIImage(named: "obiwan")!,
          status: "Hello, my padavan"),
    Users(login: "22@ru.ru", password: "222222", name: "Darth Vader",
          userImage: UIImage(named: "darthvader")!,
          status: "Come with me, son!"),
    Users(login: "33@ru.ru", password: "333333", name: "Master Yoda",
          userImage: UIImage(named: "yoda")!,
          status: "Fear is the path to the Dark side!"),
    Users(login: "44@ru.ru", password: "444444", name: "Imperial trooper",
          userImage: UIImage(named: "trooper")!,
          status: "These aren't the droids we're looking for!"),
    Users(login: "55@ru.ru", password: "", name: "Imperial trooper",
          userImage: UIImage(named: "trooper")!,
          status: "These aren't the droids we're looking for!"),
]

//MARK: ================================== ProfileVC ==================================
//public var posts: [Post] = Post.addPosts()
public var favoritePosts: [Post] = []
//public var favoritePosts: [Int] = [3]

//MARK: ================================== MainTabBar =================================
public var topBarHeight: CGFloat = 0

public var absoluteWidth: CGFloat {
    return  UIScreen.main.bounds.height < UIScreen.main.bounds.width ?
            UIScreen.main.bounds.height : UIScreen.main.bounds.width
}
