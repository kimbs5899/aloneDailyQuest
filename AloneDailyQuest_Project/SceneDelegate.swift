//
//  SceneDelegate.swift
//  AloneDailyQuest_Project
//
//  Created by Designer on 11/16/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, delegateViewController {
    
    func moveView() {
        let tabBarVc = UITabBarController()
        let QuestListVC = UINavigationController(rootViewController: QuestViewController())
        //퀘스트리스트 네비뷰 첫화면
        
        //탭바 이름 설정
        QuestListVC.title = "일일퀘스트"
        
        //탭바로 사용하기 위한 뷰 컨트롤러 설정
        tabBarVc.setViewControllers([QuestListVC], animated: true)
        tabBarVc.modalPresentationStyle = .fullScreen
        tabBarVc.tabBar.backgroundColor = .white
        
        //탭바 이미지 설정 (임시로 애플 제공하는것으로 사용)
        guard let items = tabBarVc.tabBar.items else { return }
        items[0].image = UIImage(systemName: "books.vertical.fill")
        
        window?.rootViewController = tabBarVc
        window?.makeKeyAndVisible()
    }
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene) // SceneDelegate의 프로퍼티에 설정해줌
        
        // 어카운트 뷰
//        let mainViewController = AccountViewController() // 맨 처음 보여줄 ViewController  ⭐️푸쉬 할때 바꾸기
//        
//        mainViewController.delegate = self
//        
//        window?.rootViewController = mainViewController
//        window?.makeKeyAndVisible()
        
        // 프로필 뷰
        let mainViewController = ProfileViewController()
        
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

protocol delegateViewController: AnyObject {
    func moveView()
}
