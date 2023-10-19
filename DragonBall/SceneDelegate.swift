//
//  SceneDelegate.swift
//  DragonBall
//
//  Created by Pablo Márquez Marín on 11/10/23.
//

import UIKit

class SceneDelegate: UIResponder, 
                        UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        rootViewController?.viewModel = LoginViewModel(
            apiProvider: ApiProvider(), 
            secureDataProvider: SecureDataProvider()
        )
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: rootViewController ?? UIViewController())
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

