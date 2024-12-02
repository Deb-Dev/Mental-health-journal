import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var notificationsEnabled = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }

                Section(header: Text("Notifications")) {
                    Toggle("Enable Reminders", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { value, newValue in
                            if newValue {
                                NotificationManager.shared.requestPermission()
                                // Schedule notifications
                            } else {
                                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                            }
                        }
                }

                Section(header: Text("Privacy")) {
                    Button(action: {
                        // Implement data export
                    }) {
                        Text("Export My Data")
                    }

                    Button(action: {
                        // Implement data deletion
                    }) {
                        Text("Delete My Data")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
