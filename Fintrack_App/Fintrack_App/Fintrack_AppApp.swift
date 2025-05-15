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
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  @StateObject private var authViewModel = AuthViewModel()
  @StateObject private var colorSchemeManager = ColorSchemeManager()

  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
          .environmentObject(authViewModel)
          .environmentObject(colorSchemeManager)
      }
      .preferredColorScheme(colorSchemeManager.isDarkMode ? .dark : .light)
    }
  }
}
