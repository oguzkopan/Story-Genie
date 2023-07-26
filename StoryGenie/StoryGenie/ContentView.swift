import SwiftUI

struct Story: Identifiable {
    let id = UUID()
    let title: String
    let content: String
}

struct StoryDetailView: View {
    let story: Story
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(story.title)
                .font(.title)
                .fontWeight(.bold)
            Text(story.content)
                .font(.body)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding()
        .navigationTitle(story.title)
    }
}

struct ContentView: View {
    // Sample data for demonstration purposes
    let preBuiltStories = [
        Story(title: "The Adventure Begins", content: "Once upon a time..."),
        Story(title: "The Magical Forest", content: "In a mysterious forest..."),
        Story(title: "The Enchanted Castle", content: "Deep inside the castle..."),
        // Add more pre-built stories here
    ]
    
    @State private var userGeneratedStories: [Story] = []
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Create Your Own Story")) {
                    NavigationLink(destination: CreateStoryView()) {
                        Text("Create a Story")
                    }
                }
                
                Section(header: Text("Explore Stories")) {
                    ForEach(preBuiltStories + userGeneratedStories) { story in
                        NavigationLink(destination: StoryDetailView(story: story)) {
                            Text(story.title)
                        }
                    }
                }
            }
            .navigationTitle("Storyteller App")
        }
    }
    
    private func addGeneratedStory(_ story: Story) {
        userGeneratedStories.append(story)
    }
}

struct CreateStoryView: View {
    @State private var storyPrompt = ""
    @State private var generatedStory = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Enter your story prompt:")
                .font(.headline)
            
            TextField("Once upon a time...", text: $storyPrompt)
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
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Create Story")
    }
    
    private func generateStory() {
        // Call the generative language model API with 'storyPrompt' as input
        // and store the generated story in 'generatedStory' variable
        // Replace this section with your actual API integration code
        generatedStory = "Once upon a time, \(storyPrompt)..."
    }
}
