import SwiftUI

struct ContentView: View {
    @EnvironmentObject var journalViewModel: JournalViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            JournalEntriesView()
                .tabItem {
                    Label("Journal", systemImage: "book")
                }

            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.bar")
                }

            CopingStrategiesView()
                .tabItem {
                    Label("Coping", systemImage: "lightbulb")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
