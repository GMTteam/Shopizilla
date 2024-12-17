//
//  SceneDelegate.swift
//  Shopizilla
//
//  Created by Anh Tu on 02/04/2022.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import FirebaseDynamicLinks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        window?.overrideUserInterfaceStyle = .light
        window?.tintColor = .black
        
        openDynamicLink(connectionOptions: connectionOptions)
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
        UIApplication.shared.applicationIconBadgeNumber = 0
        Connect.connected(online: .online)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        Connect.connected(online: .busy)
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

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: [UIApplication.OpenURLOptionsKey.annotation])
        GIDSignIn.sharedInstance.handle(url)
        Auth.auth().canHandle(url)
    }
}

//MARK: - Dynamic Link

extension SceneDelegate {
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        openShareLink(userActivity)
    }
    
    private func openDynamicLink(connectionOptions: UIScene.ConnectionOptions) {
        if let userActivity = connectionOptions.userActivities.first {
            openShareLink(userActivity)
        }
    }
    
    private func openShareLink(_ userActivity: NSUserActivity) {
        if let url = userActivity.webpageURL {
            DynamicLinks.dynamicLinks().handleUniversalLink(url) { (dynamicLink, error) in
                if let error = error {
                    print("Found error: \(error.localizedDescription)")
                    return
                }

                if let dynamicLink = dynamicLink {
                    self.handleIncomingDynamicLink(dynamicLink)
                }
            }
        }
    }
    
    private func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else { return }
        print("Dynamic Link URL: \(url)")

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return }
        print("queryItems: \(queryItems)")
        
        guard let viewController = getParentVC() else {
            return
        }

        if components.path == "/product",
           let uid = queryItems.first(where: { $0.name == "uid" })?.value {
            if let product = appDL.allProducts.first(where: { $0.uid == uid }) {
                goToProductVC(viewController: viewController, product: product)
                
            } else {
                Product.fetchProduct(uid: uid) { product in
                    if let product = product {
                        goToProductVC(viewController: viewController, product: product)
                    }
                }
            }
        }
        
        if components.path == "/paypal",
           let state = queryItems.first(where: { $0.name == "state" })?.value {
            print("*** state: \(state)")
            NotificationCenter.default.post(name: .payPalKey, object: state)
        }
    }
    
    func getParentVC() -> UIViewController? {
        var parentVC: UIViewController?
        
        if let tabBarVC = window?.rootViewController as? TabBarController,
           let viewControllers = tabBarVC.viewControllers {
            let index = tabBarVC.selectedIndex
            
            if let navi = viewControllers[index] as? NavigationController {
                let vcs = navi.viewControllers

                for vc in vcs {
                    if let index = vcs.firstIndex(of: vc) {
                        parentVC = vcs[index]
                        break
                    }
                }
            }
        }
        
        return parentVC
    }
}
