import SwiftUI
import AVFoundation

class SpeechManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    private let speechSynthesizer = AVSpeechSynthesizer()

    @Published var isSpeaking: Bool = false

    override init() {
        super.init()
        speechSynthesizer.delegate = self
    }

    func speak(utterance: AVSpeechUtterance) {
        speechSynthesizer.speak(utterance)
        isSpeaking = true
    }

    func pause() {
        speechSynthesizer.pauseSpeaking(at: .immediate)
        isSpeaking = false
    }

    func stop() {
        speechSynthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}

struct StoryDetailView: View {
    @ObservedObject var speechManager = SpeechManager()
    let story: StoryContent

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(story.title)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(story.content)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                }
                .padding()
            }

            HStack {
                Button(action: {
                    if speechManager.isSpeaking {
                        speechManager.pause()
                    } else {
                        speakStory()
                    }
                }) {
                    Image(systemName: speechManager.isSpeaking ? "pause.fill" : "play.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }

                Button(action: {
                    speechManager.stop()
                }) {
                    Image(systemName: "stop.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .clipShape(Circle())
                }
            }
            .padding(.bottom, 20)
        }
        .navigationTitle(story.title)
    }

    private func speakStory() {
        let speechUtterance = AVSpeechUtterance(string: story.content)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Set the language for speech
        speechManager.speak(utterance: speechUtterance)
    }
}



struct ContentView: View {
    @State private var isLoggedIn: Bool = false
    @State private var userGeneratedStories: [StoryContent] = []
    
    let preBuiltStories: [StoryContent] = parseStoriesFromTextFiles(filenames: ["TheAdventureBegins", "MobyDick", "Story3"])

    var body: some View {
        NavigationView {
            ZStack{
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
                .listStyle(GroupedListStyle()) // Apply a list style
                .navigationTitle("Storyteller App")
                .navigationBarTitleDisplayMode(.inline) // Display the title in the navigation bar
                .foregroundColor(.blue) // Set the text color for the entire view
                .background(Color.gray.opacity(0.1)) // Set the background color
            }
        }
    }
    
    private func addGeneratedStory(_ story: StoryContent) {
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
