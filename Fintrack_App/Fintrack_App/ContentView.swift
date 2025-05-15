import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var colorSchemeManager: ColorSchemeManager

    var body: some View {
        if authViewModel.isAuthenticated {
            DashboardView()
                .environmentObject(authViewModel)
                .environmentObject(colorSchemeManager)
        } else {
            AuthView()
                .environmentObject(authViewModel)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
        .environmentObject(ColorSchemeManager())
}
