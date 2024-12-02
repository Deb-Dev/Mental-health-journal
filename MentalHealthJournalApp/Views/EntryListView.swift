import SwiftUI
struct EntryListView: View {
    @ObservedObject var viewModel: JournalViewModel

    var body: some View {
        List(viewModel.entries) { entry in
            HStack {
                Text(entry.date, style: .date)
                Spacer()
                if let mood = entry.mood {
                    Text(mood.rawValue.capitalized)
                        .foregroundColor(colorForMood(mood))
                }
            }
        }
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
