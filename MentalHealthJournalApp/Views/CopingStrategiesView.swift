import SwiftUI

struct CopingStrategiesView: View {
    @EnvironmentObject var journalViewModel: JournalViewModel
    private let copingStrategyService = CopingStrategyService()

    var body: some View {
        NavigationView {
            List {
                ForEach(copingStrategies, id: \.self) { strategy in
                    Text(strategy)
                }
            }
            .navigationTitle("Coping Strategies")
        }
    }

    var copingStrategies: [String] {
        guard let recentMood = journalViewModel.entries.last?.mood else {
            return ["No strategies available. Please add a journal entry to receive personalized strategies."]
        }
        return copingStrategyService.getStrategies(for: recentMood)
    }
}
