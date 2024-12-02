import SwiftUI
import Charts

struct InsightsView: View {
    @EnvironmentObject var journalViewModel: JournalViewModel

    var body: some View {
        NavigationView {
            VStack {
                Text("Mood Over Time")
                    .font(.headline)
                    .padding()

                if journalViewModel.entries.isEmpty {
                    Text("No data available. Start journaling to see insights.")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    Chart {
                        ForEach(journalViewModel.entries) { entry in
                            if let mood = entry.mood {
                                LineMark(
                                    x: .value("Date", entry.date),
                                    y: .value("Mood", moodScore(mood))
                                )
                            }
                        }
                    }
                    .chartYScale(domain: -1...2)
                    .padding()
                }
            }
            .navigationTitle("Insights")
        }
    }

    func moodScore(_ mood: Mood) -> Int {
        switch mood {
        case .happy:
            return 2
        case .stressed:
            return 1
        case .anxious:
            return 0
        case .sad:
            return -1
        case .overwhelmed:
            return -1
        case .excited:
            return 1
        }
    }
}
