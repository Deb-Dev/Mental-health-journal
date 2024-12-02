import Foundation

struct JournalEntry: Identifiable, Codable {
    var id: UUID
    var date: Date
    var content: String
    var tags: [String]
    var mood: Mood?
}
