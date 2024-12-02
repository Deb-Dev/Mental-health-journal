import SwiftUI

@main
struct MentalHealthJournalApp: App {
    @StateObject private var journalViewModel = JournalViewModel()
    @StateObject private var authService = AuthenticationService()
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var isAuthenticated = true
    @State private var authError: Error?

    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                ContentView()
                    .environmentObject(journalViewModel)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
            } else {
                AuthenticationView()
                    .onAppear {
                        authenticateUser()
                    }
                    .alert(isPresented: Binding<Bool>(
                        get: { authError != nil },
                        set: { _ in authError = nil }
                    )) {
                        Alert(
                            title: Text("Authentication Failed"),
                            message: Text(authError?.localizedDescription ?? "Please try again."),
                            dismissButton: .default(Text("Retry")) {
                                authenticateUser()
                            }
                        )
                    }
            }
        }
    }

    private func authenticateUser() {
        authService.authenticate { success, error in
            if success {
                isAuthenticated = true
            } else {
                authError = error
            }
        }
    }
}
