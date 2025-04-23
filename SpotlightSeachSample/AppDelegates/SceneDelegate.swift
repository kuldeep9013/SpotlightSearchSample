//
//  SceneDelegate.swift
//  SpotlightSeachSample
//
//  Created by Kuldeep Solanki on 23/04/25.
//

import UIKit
import CoreSpotlight

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func scene(_ scene: UIScene,
               continue userActivity: NSUserActivity) {
        
        if userActivity.activityType == CSSearchableItemActionType {
            if let identifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                print("Spotlight tapped: \(identifier)")
                SpotlightManager().handleSpotlightActivity(userActivity)
                // Route to the correct view controller based on identifier
            }
        }
    }
    
}

