import SwiftUI

struct JournalEntriesView: View {
    @EnvironmentObject var journalViewModel: JournalViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(journalViewModel.entries.sorted(by: { $0.date > $1.date })) { entry in
                    NavigationLink(destination: JournalEntryDetailView(entry: entry)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(entry.date, style: .date)
                                    .font(.headline)
                                Text(entry.content)
                                    .lineLimit(1)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            if let mood = entry.mood {
                                Text(mood.rawValue.capitalized)
                                    .foregroundColor(colorForMood(mood))
                            }
                        }
                    }
                }
                .onDelete(perform: deleteEntry)
            }
            .navigationTitle("Journal Entries")
            .toolbar {
                EditButton()
            }
        }
    }

    func deleteEntry(at offsets: IndexSet) {
        journalViewModel.entries.remove(atOffsets: offsets)
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
struct JournalEntriesView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntriesView()
            .environmentObject(JournalViewModel())
    }
}
