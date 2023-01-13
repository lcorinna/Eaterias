//
//  AppDelegate.swift
//  Eaterias
//
//  Created by Lashaun Corinna on 12/21/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //        UINavigationBar.appearance().barTintColor = .yellow
        //        UINavigationBar.appearance().tintColor = .blue
        //
        //        UITabBar.appearance().tintColor = .red
        //        UITabBar.appearance().barTintColor = .yellow
        //        UITabBar.appearance().selectionIndicatorImage = UIImage(named: "tabSelectBG ")
        
        let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 20))
        statusBarView.backgroundColor = .yellow
        self.window?.rootViewController?.view.insertSubview(statusBarView, at: 0)
        
        if let barFont = UIFont(name: "AppleSDGothicNeo-Light", size: 24) {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: barFont]
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        self.coreDataStack.saveContext()
    }
}

