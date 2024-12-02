import Foundation

class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = [] {
            didSet {
                saveEntries()
            }
        }

        init() {
            loadEntries()
        } 
    
    func addEntry(content: String, tags: [String], moods: [Mood]? = nil) {
        let newEntry = JournalEntry(
            id: UUID(),
            date: Date(),
            content: content,
            tags: tags,
            mood: moods?.first // Mood will be set after analysis
        )
        entries.append(newEntry)
        // Trigger mood analysis
        analyzeMood(for: newEntry)
    }
    func saveEntries() {
            if let encodedData = try? JSONEncoder().encode(entries) {
                UserDefaults.standard.set(encodedData, forKey: "journalEntries")
            }
        }

        func loadEntries() {
            if let savedData = UserDefaults.standard.data(forKey: "journalEntries"),
               let decodedEntries = try? JSONDecoder().decode([JournalEntry].self, from: savedData) {
                entries = decodedEntries
            }
        }
}

import NaturalLanguage

extension JournalViewModel {
    func analyzeMood(for entry: JournalEntry) {
        let sentimentScore = performSentimentAnalysis(on: entry.content)
        // Map sentimentScore to Mood
        var mood: Mood?
        switch sentimentScore {
        case let x where x > 0.5:
            mood = .happy
        case let x where x < -0.5:
            mood = .sad
        default:
            mood = .stressed
        }
        // Update the entry with mood
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].mood = mood
        }
    }

    func performSentimentAnalysis(on text: String) -> Double {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        let sentiment = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore).0
        let score = Double(sentiment?.rawValue ?? "0") ?? 0.0
        return score
    }
}
