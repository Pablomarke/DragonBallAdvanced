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

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
       let splashStoryboard = UIStoryboard(name: "SplashView",
                                            bundle: .main)
        let rootViewController = splashStoryboard.instantiateViewController(withIdentifier: "SplashView") as?  SplashViewController
        rootViewController?.viewModel = SplashViewModel(
            secureDataProvider: SecureDataProvider(),
            apiProvider: ApiProvider()
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

