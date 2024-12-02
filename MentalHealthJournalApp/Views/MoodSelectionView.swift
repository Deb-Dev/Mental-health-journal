import SwiftUI

struct MoodSelectionView: View {
    @Binding var selectedMoods: [Mood]
    var onContinue: () -> Void

    @State private var moods: [Mood] = [.happy, .sad, .anxious, .stressed, .overwhelmed, .excited]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("How are you feeling today?")
                .font(.title2)
                .padding()

            // Mood icons grid
            ScrollView {
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()], spacing: 20) {
                    ForEach(moods, id: \.self) { mood in
                        Button(action: {
                            toggleMoodSelection(mood)
                        }) {
                            VStack {
                                Image(systemName: iconName(for: mood))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(selectedMoods.contains(mood) ? .blue : .gray)
                                Text(mood.rawValue.capitalized)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                .padding()
            }

            Spacer()

            Button(action: {
                onContinue()
            }) {
                Text("Continue")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selectedMoods.isEmpty ? Color.gray : Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(selectedMoods.isEmpty)
        }
        .navigationTitle("Select Mood")
    }

    func toggleMoodSelection(_ mood: Mood) {
        if selectedMoods.contains(mood) {
            selectedMoods.removeAll { $0 == mood }
        } else {
            selectedMoods.append(mood)
        }
    }

    func iconName(for mood: Mood) -> String {
        switch mood {
        case .happy:
            return "smiley"
        case .sad:
            return "frown"
        case .anxious:
            return "exclamationmark.triangle"
        case .stressed:
            return "flame"
        case .overwhelmed:
            return "waveform.path.ecg"
        case .excited:
            return "star"
        }
    }
}
