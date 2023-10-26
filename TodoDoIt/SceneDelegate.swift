//
//  SceneDelegate.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let vc = TabbarController()
        window?.rootViewController = vc
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
        // 백그라운드로 갈때 알림 푸쉬
        checkTodosAndPerformAction()
    }
    
    // 할일 검사후 알림
    func checkTodosAndPerformAction(){
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                // 할일 정보 가져오기
                let todoRepository = TodoRepository()
                let todos = todoRepository.fetchFilterDateSortByFinish(date: Date())
                
                // 끝나지 않은 할일이 있다면 알림 설정
                if !todos.isEmpty,
                   let firstTodo = todos.first, !firstTodo.finish {
                    self.sendNotification(title: "할일 알림", body: "아직 남은 할일이 있어요. 확인해보세요!")
                } else {
                    // 할일이 없으면 다른 메시지 보내기
                    self.sendNotification(title: "할일 알림", body: "오늘 하루도 수고하셨어요. 내일 할일을 설정해보세요!")
                }
            } else {
                print("권한없음")
            }
        }
    }
    
    // 알림 설정
    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        // 시간
        var dateComponents = DateComponents()
        dateComponents.hour = 20
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // identifier
        let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 보내기 실패: \(error)")
            } else {
                print("알림 보내기 성공")
            }
        }
    }
}
