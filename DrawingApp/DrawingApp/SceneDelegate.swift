//
//  SceneDelegate.swift
//  DrawingApp
//
//  Created by 조호근 on 3/18/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let mainVC = MainViewController()
        mainVC.injectDependencies(plane: Plane(),
                                  rectangleFactory: RectangleFactory(),
                                  photoFactory: PhotoFactory(),
                                  labelFactory: LabelFactory()
        )
        
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .white
        window.rootViewController = mainVC
        self.window = window
        window.makeKeyAndVisible()
    }
}
