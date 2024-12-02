class CopingStrategyService {
    func getStrategies(for mood: Mood) -> [String] {
        switch mood {
        case .happy:
            return ["Keep up the good work!", "Share your happiness with others."]
        case .sad:
            return ["Try a relaxation exercise.", "Talk to a friend or family member."]
        case .anxious:
            return ["Practice deep breathing.", "Write down your worries."]
        case .stressed:
            return ["Take a short walk.", "Listen to calming music."]
        case .overwhelmed:
            return ["Take a short walk.", "Listen to calming music."]

        case .excited:
            return ["Take a short walk.", "Listen to calming music."]

        }
    }
}
