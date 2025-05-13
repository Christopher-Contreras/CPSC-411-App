//
//  ContentView.swift
//  Fintrack_App
//
//  Created by csuftitan on 3/25/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel()

    var body: some View {
        if authViewModel.isAuthenticated {
            DashboardView()
                .environmentObject(authViewModel)
        } else {
            AuthView()
                .environmentObject(authViewModel)
        }
    }
}

#Preview {
    ContentView()
}
