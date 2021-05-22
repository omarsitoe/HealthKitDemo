//
//  SceneDelegate.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 5/9/21.
//

import UIKit
import CareKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        //let contentView = ContentView()
        
        // Questions for survey
        let question1 = "How calm, rested, relaxed do you feel today? (answer 1 = not at all, 5 = totally)"
        let question2 = "Have you been able to keep up with your diabetes care? (answer 1 = not at all, 5 = totally)"
        
        let store = CareData.careStore
        let manager = OCKSynchronizedStoreManager(wrapping: store)
        let task = CareData.SurveyTaskCreator(question1: question1, question2: question2)
        
        print("Task Title: \(String(describing: task.title))")
        print("Task Survey: \(String(describing: task.surveyQuestion1))")
        
        let taskQuery = SurveyTaskQuery()
        
        store.fetchTasks(query: taskQuery,
            callbackQueue: DispatchQueue.main,
                completion: { (result: (Result<[SurveyTask], OCKStoreError>)) in
            switch result {
            case .failure(let error) :
                print(error.localizedDescription)
            case .success( _) :
                print("Success!")
                let fetchedTask = try! result.get()[0]
                print("Fetched Task Title: \(String(describing: fetchedTask.title))")
                print("Fetched Task Quest: \(String(describing: fetchedTask.surveyQuestion1))")
            }
        })
        
        
        let careViewController = OCKDailyTasksPageViewController(storeManager: manager)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UINavigationController(rootViewController: careViewController)
            self.window = window
            window.makeKeyAndVisible()
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

