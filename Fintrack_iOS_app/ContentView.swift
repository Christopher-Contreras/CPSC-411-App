//
//  ContentView.swift
//  Fintrack_App
//
//  Created by csuftitan on 3/25/25.
//

import SwiftUI
import FirebaseCore


struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel()

    var body: some View {
        DashboardView()
            .environmentObject(authViewModel)
    }
}

//#Preview {
//    ContentView()
//}
