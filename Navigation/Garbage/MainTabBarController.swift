
//import UIKit
//
//class MainTabBarController: UITabBarController {
 
//MARK: - PROPs
//    let firstVC = FeedViewController()
//    let secondVC = LogInViewController()
    
//MARK: - INITs
//    override func viewDidLoad() {
//        super.viewDidLoad()
        
        //вычисляем высоту NavigationBar и StatusBar для сдвига элементов Profile
//        topBarHeight = findNavigationBarHeight() + findStatusBarHeight()
        //красим все бары в один цвет
//        UINavigationBar.appearance().backgroundColor = .systemGray6
//        //UIBarButtonItem.appearance().tintColor = UIColor.magenta
//        UITabBar.appearance().backgroundColor = .systemGray6
//    }
    

//MARK: - METHODs
//    func setupControllers() {
//        firstVC.tabBarItem.title = "Feed"
//        firstVC.tabBarItem.image = UIImage(systemName: "rectangle.grid.2x2")
//        firstVC.navigationItem.title = "Feed"
//        secondVC.tabBarItem.title = "Profile"
//        secondVC.tabBarItem.image = UIImage(systemName: "person.crop.circle")
//        let firstNavigationVC = UINavigationController(rootViewController: firstVC)
//        let secondNavigationVC = UINavigationController(rootViewController: secondVC)
//        viewControllers = [firstNavigationVC, secondNavigationVC]
//    }
    
//    func findNavigationBarHeight() -> CGFloat {
//        if let height = loginVC.navigationController?.navigationBar.frame.height {
//            return height //k2
//        } else { return 0 }
//    }
//
//    func findTabBarHeight() -> CGFloat {
//        if let height = self.tabBarController?.tabBar.frame.height {
//            return height //k3
//        } else { return 0 }
//    }
//
//    func findStatusBarHeight() -> CGFloat {  //k1
//        return UIApplication.shared.statusBarFrame.size.height
//    }
//}
