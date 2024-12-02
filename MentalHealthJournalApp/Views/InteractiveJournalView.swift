import SwiftUI
import SwiftUI

struct InteractiveJournalView: View {
    @State private var selectedMoods: [Mood] = []
    @State private var messages: [Message] = []
    @State private var showMoodSelection: Bool = true
    @State private var isLoading: Bool = false
    @State private var userInput: String = ""
    @EnvironmentObject var journalViewModel: JournalViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            if showMoodSelection {
                MoodSelectionView(selectedMoods: $selectedMoods, onContinue: {
                    if !selectedMoods.isEmpty {
                        startConversation()
                        withAnimation {
                            showMoodSelection = false
                        }
                    }
                })
            } else {
                ConversationView(messages: messages, onSelectSuggestedResponse: { selectedResponse in
                    handleSuggestedResponse(selectedResponse)
                })
                if isLoading {
                    ProgressView()
                        .padding()
                } else {
                    HStack {
                        TextField("Your response...", text: $userInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onSubmit {
                                sendMessage()
                            }
                        Button(action: {
                            sendMessage()
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.accentColor)
                        }
                        .disabled(userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("New Journal Entry")
        .navigationBarItems(trailing: Button("Finish") {
            finishSession()
        })
        .onAppear {
            if messages.isEmpty {
                showMoodSelection = true
            }
        }
    }

    func startConversation() {
        isLoading = true
        
        // Prepare an empty conversation since this is the start
        let conversation: [Message] = []
        
        APIService.shared.generatePrompts(moods: selectedMoods.map { $0.rawValue }, previousConversation: conversation) { assistantMessage in
            DispatchQueue.main.async {
                self.isLoading = false
                if let assistantMessage = assistantMessage {
                    self.messages.append(assistantMessage)
                } else {
                    let errorMessage = Message(role: .assistant, content: "How are you feeling today?")
                    self.messages.append(errorMessage)
                }
            }
        }
    }

    func handleSuggestedResponse(_ response: String) {
        // Add the user's selected response to the messages
        let userMessage = Message(role: .user, content: response)
        messages.append(userMessage)

        // Fetch assistant's response
        fetchAssistantResponse()
    }

    func sendMessage() {
        guard !userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        // Add user's message
        let userMessage = Message(role: .user, content: userInput)
        messages.append(userMessage)
        userInput = ""

        // Fetch assistant's response
        fetchAssistantResponse()
    }
    func fetchAssistantResponse() {
        isLoading = true
        
        // Prepare conversation history
        let conversation = messages
        
        APIService.shared.generatePrompts(moods: selectedMoods.map { $0.rawValue }, previousConversation: conversation) { assistantMessage in
            DispatchQueue.main.async {
                self.isLoading = false
                if let assistantMessage = assistantMessage {
                    self.messages.append(assistantMessage)
                } else {
                    let errorMessage = Message(role: .assistant, content: "I'm sorry, I couldn't generate a response at this time.")
                    self.messages.append(errorMessage)
                }
            }
        }
    }

    func finishSession() {
        // Combine all user messages into one entry
        let journalContent = messages
            .filter { $0.role == .user }
            .map { $0.content }
            .joined(separator: "\n\n")

        journalViewModel.addEntry(content: journalContent, tags: [], moods: selectedMoods)
        presentationMode.wrappedValue.dismiss()
    }
}
struct ConversationView: View {
    var messages: [Message]
    var onSelectSuggestedResponse: (String) -> Void // Add this line

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(messages) { message in
                    VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 5) {
                        HStack {
                            if message.role == .assistant {
                                MessageBubble(message: message.content, isFromUser: false)
                                Spacer()
                            } else {
                                Spacer()
                                MessageBubble(message: message.content, isFromUser: true)
                            }
                        }
                        .padding(.horizontal)

                        // Display suggested responses if any
                        if message.role == .assistant, let suggestions = message.suggestedResponses {
                            SuggestedResponsesView(suggestions: suggestions, onSelect: onSelectSuggestedResponse)
                                .padding(.horizontal)
                        }
                    }
                    .id(message.id) // Add this line for scrolling
                }
            }
            .onChange(of: messages.count) { _,_ in
                // Scroll to the bottom when new message is added
                if let lastMessage = messages.last {
                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                }
            }
        }
    }
}
struct SuggestedResponsesView: View {
    var suggestions: [String]
    var onSelect: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(suggestions, id: \.self) { suggestion in
                Button(action: {
                    onSelect(suggestion)
                }) {
                    HStack {
                        Image(systemName: "quote.bubble")
                            .foregroundColor(.white)
                        Text(suggestion)
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                .buttonStyle(PressableButtonStyle())
                .buttonStyle(PressableButtonStyle())
            }
        }
        .padding(.vertical)
    }
}

struct MessageBubble: View {
    var message: String
    var isFromUser: Bool

    var body: some View {
        Text(message)
            .padding()
            .foregroundColor(isFromUser ? .white : .black)
            .background(isFromUser ? Color.accentColor : Color.gray.opacity(0.2))
            .cornerRadius(10)
            .frame(maxWidth: 250, alignment: isFromUser ? .leading : .trailing)
            .padding(isFromUser ? .leading : .trailing, 50)
            .padding(.vertical, 5)
    }
}

struct Message: Identifiable {
    var id = UUID()
    var role: Role
    var content: String
    var suggestedResponses: [String]? // Add this line

    enum Role: String {
            case user = "user"
            case assistant = "assistant"
        }
}
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .brightness(configuration.isPressed ? -0.05 : 0)
    }
}
