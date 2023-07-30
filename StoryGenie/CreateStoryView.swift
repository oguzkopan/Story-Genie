import SwiftUI
import Alamofire

struct Message: Codable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}


struct CreateStoryView: View {
    @State private var storyPrompt = ""
    @State private var generatedStory = ""
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel

    var body: some View {
        ScrollView { // Wrap the content in ScrollView
            VStack(alignment: .leading, spacing: 16) {
                Text("Can you generate a children story about")
                    .font(.headline)

                TextField("Enter your story prompt..", text: $storyPrompt)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: generateStory) {
                    Text("Generate Story")
                }

                if !generatedStory.isEmpty {
                    Text("Generated Story:")
                        .font(.headline)

                    Text(generatedStory)
                        .font(.body)
                        .multilineTextAlignment(.leading)

                    Button(action: saveAsFavorite) { // Add a button to save as favorite
                        Text("Save as Favorite")
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Create Story")
        }
    }

    private func generateStory() {
        // Create an instance of the OpenAIService class
        let openAIService = OpenAIService()

        // Create an array of messages containing the user prompt
        let messages = [Message(id: UUID(), role: .user, content: storyPrompt, createAt: Date())]

        // Call the sendMessage method from the OpenAIService class to get the generated story
        openAIService.sendMessage(messages: messages) { result in
            switch result {
            case .success(let response):
                if let choice = response.choices?.first {
                    generatedStory = choice.message.content
                } else {
                    generatedStory = "No story generated."
                }
            case .failure(let error):
                generatedStory = "Error generating story: \(error.localizedDescription)"
            }
        }
    }

    private func saveAsFavorite() {
        let favoriteStory = GeneratedStory(content: generatedStory, createdAt: Date())
        favoritesViewModel.addFavorite(favoriteStory) // Use the FavoritesViewModel to add the favorite
    }
}

