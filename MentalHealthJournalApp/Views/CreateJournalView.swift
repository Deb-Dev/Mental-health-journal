import SwiftUI

struct CreateJournalView: View {
    @State private var content: String = ""
    @State private var selectedTags: [String] = []
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var journalViewModel: JournalViewModel

    var body: some View {
        VStack {
            TextEditor(text: $content)
                .padding()
                .navigationTitle("New Entry")
                .navigationBarTitleDisplayMode(.inline)

            // Optional: Tag selection UI

            Button(action: saveEntry) {
                Text("Save")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    func saveEntry() {
        journalViewModel.addEntry(content: content, tags: selectedTags)
        presentationMode.wrappedValue.dismiss()
    }
}
