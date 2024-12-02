import SwiftUI

struct JournalEntryDetailView: View {
    let entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(entry.date, style: .date)
                .font(.headline)

            if let mood = entry.mood {
                Text("Mood: \(mood.rawValue.capitalized)")
                    .foregroundColor(colorForMood(mood))
            }

            ScrollView {
                Text(entry.content)
                    .padding(.top)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Entry Details")
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
