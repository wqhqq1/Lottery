//
//  SceneDelegate.swift
//  lottery
//
//  Created by wqhqq on 2020/7/25.
//

import UIKit
import SwiftUI

var urlModeResult: Bool = false

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        #if targetEnvironment(macCatalyst)
        do {
            UIApplication.shared.connectedScenes.compactMap{$0 as? UIWindowScene}.forEach { windowScene in
                windowScene.sizeRestrictions?.minimumSize = CGSize(width: 1000, height: 800)
                windowScene.sizeRestrictions?.maximumSize = CGSize(width: 1000, height: 800)
            }
        }
        #endif
        
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        if connectionOptions.urlContexts.first?.url == URL(string: "lottery://result") {
            let urlcontentView = tabview(showSheet: true).environmentObject(Prizes())
            sheetModeResult = true
            if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = UIHostingController(rootView: urlcontentView)
                self.window = window
                window.makeKeyAndVisible()
            }
        }
        else {
            sheetModeResult = false
            if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = UIHostingController(rootView: tabview(showSheet: false).environmentObject(Prizes()))
                self.window = window
                window.makeKeyAndVisible()
            }
        }
        // Use a UIHostingController as window root view controller.
    }
    func scene(_ scene: UIScene,
               openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if URLContexts.first?.url == URL(string: "lottery://result") {
            let urlcontentView = tabview(showSheet: true).environmentObject(Prizes())
            sheetModeResult = true
            if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = UIHostingController(rootView: urlcontentView)
                self.window = window
                window.makeKeyAndVisible()
            }
        }
        else {
            sheetModeResult = false
            if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.canResizeToFitContent = false
                window.rootViewController = UIHostingController(rootView: tabview(showSheet: false).environmentObject(Prizes()))
                self.window = window
                window.makeKeyAndVisible()
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

