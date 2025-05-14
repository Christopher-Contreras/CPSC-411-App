//
//  Fintrack_AppApp.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 3/25/25.
//
import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      
    print("✅ Firebase configured successfully")

    return true
  }
}

@main
struct Fintrack_AppApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()

  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
              .environmentObject(authViewModel)
      }
    }
  }
}
