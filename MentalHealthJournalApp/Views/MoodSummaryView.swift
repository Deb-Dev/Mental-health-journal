import SwiftUI

struct MoodSummaryView: View {
    @EnvironmentObject var journalViewModel: JournalViewModel

    var body: some View {
        VStack {
            Text("Your Recent Mood")
                .font(.title2)
                .padding(.bottom, 5)

            if let recentMood = journalViewModel.entries.last?.mood {
                Text(recentMood.rawValue.capitalized)
                    .font(.largeTitle)
                    .foregroundColor(colorForMood(recentMood))
            } else {
                Text("No entries yet")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }

    func colorForMood(_ mood: Mood) -> Color {
        switch mood {
        case .happy:
            return .green
        case .sad:
            return .blue
        case .anxious, .stressed:
            return .orange
        case .overwhelmed:
            return .orange

        case .excited:
            return .orange

        }
    }
}
