//
//  AppDelegate.swift
//  sampleappMessageKit
//
//  Created by 北田菜穂 on 2020/12/03.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var uuid : String?
    
    static var shared : AppDelegate? {
        get {
            return UIApplication.shared.delegate as? AppDelegate
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        //
        let idfv : String = UIDevice.current.identifierForVendor?.uuidString ?? ""
        print("idfv=\(idfv)")
        
        //uuid
        let defaults = UserDefaults.standard
        var savedUuid : String? = defaults.string(forKey: "uuid")
        if savedUuid == nil {
            let uuid = UUID().uuidString
            defaults.setValue(uuid, forKey: "uuid")
            savedUuid = uuid
        }
        self.uuid = savedUuid
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

