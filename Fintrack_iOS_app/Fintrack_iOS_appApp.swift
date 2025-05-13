//
//  Fintrack_iOS_appApp.swift
//  Fintrack_iOS_app
////  Created by Alisa Gao on 3/25/25.
//
import SwiftUI
import FirebaseCore

//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions:
//                     [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        print("✅ Firebase configured successfully")
//        return true
//    }
//}
//
//@main
//struct FintrackApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @StateObject var authViewModel = AuthViewModel()
//
//    var body: some Scene {
//        WindowGroup {
//            if authViewModel.isAuthenticated {
//                DashboardView()
//                    .environmentObject(authViewModel)
//            } else {
//                AuthView()
//                    .environmentObject(authViewModel)
//            }
//        }
//    }
//}
@main
struct FintrackApp: App {
    // Register AppDelegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                DashboardView()
                    .environmentObject(authViewModel)
            } else {
                AuthView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("✅ Firebase configured successfully")
        return true
    }
}
