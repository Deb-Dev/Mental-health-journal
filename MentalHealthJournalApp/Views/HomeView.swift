import SwiftUI

struct HomeView: View {
    @EnvironmentObject var journalViewModel: JournalViewModel

    var body: some View {
        NavigationView {
            VStack {
                MoodSummaryView()
                Spacer()
                NavigationLink(destination: InteractiveJournalView()) {
                    Text("New Journal Entry")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                Spacer()
            }
            .navigationTitle("Home")
        }
    }
}
