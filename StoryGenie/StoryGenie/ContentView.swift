import SwiftUI
import AVFoundation
import Combine

class SpeechManager: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    private let speechSynthesizer = AVSpeechSynthesizer()

    @Published var isSpeaking: Bool = false
    @Published var currentProgress: Float = 0.0 // Track the speech progress

    override init() {
        super.init()
        speechSynthesizer.delegate = self
    }

    func speak(utterance: AVSpeechUtterance) {
        speechSynthesizer.speak(utterance)
    }

    func pause() {
        speechSynthesizer.pauseSpeaking(at: .immediate)
    }

    func stop() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }

    // AVSpeechSynthesizerDelegate methods
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let speechLength = Float(utterance.speechString.count)
        let currentProgress = Float(characterRange.location) / speechLength
        self.currentProgress = currentProgress
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
        currentProgress = 0.0
    }
}



struct StoryDetailView: View {
    @ObservedObject var speechManager = SpeechManager()
    let story: StoryContent
    
    @State private var isSpeaking: Bool = false
    @State private var currentSpeechUtterance: AVSpeechUtterance?
    @State private var selectedProgress: Float = 0.0 // Track the user-selected progress
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
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
                    if isSpeaking {
                        pauseSpeech()
                    } else {
                        speakStory()
                    }
                }) {
                    Image(systemName: isSpeaking ? "pause.fill" : "play.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                
                Button(action: stopSpeech) {
                    Image(systemName: "stop.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .clipShape(Circle())
                }
            }
            .padding(.bottom, 20)

            // Slider to select speech progress
            Slider(value: $selectedProgress, in: 0.0...1.0, onEditingChanged: { editing in
                if !editing {
                    updateSpeechProgress()
                }
            })
            .padding(.horizontal)
        }
        .navigationTitle(story.title)
    }
    
    private func speakStory() {
        let speechUtterance = AVSpeechUtterance(string: story.content)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Set the language for speech
        currentSpeechUtterance = speechUtterance // Set the current speech utterance
        speechSynthesizer.speak(speechUtterance)
        isSpeaking = true
    }
    
    private func pauseSpeech() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.pauseSpeaking(at: .immediate)
            isSpeaking = false
        } else {
            if let currentUtterance = currentSpeechUtterance {
                speechSynthesizer.continueSpeaking() // Continue from where we paused
                isSpeaking = true
            }
        }
    }
    
    private func stopSpeech() {
        currentSpeechUtterance = nil // Reset the current speech utterance
        speechSynthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }
    
    private func updateSpeechProgress() {
        if let currentUtterance = currentSpeechUtterance {
            let totalLength = currentUtterance.speechString.count
            let targetLength = Int(Float(totalLength) * selectedProgress)
            let targetRange = NSRange(location: 0, length: targetLength)
            currentUtterance.preUtteranceDelay = 0.0 // Set this to 0 to update the progress immediately
            currentUtterance.postUtteranceDelay = 0.0 // Set this to 0 to update the progress immediately
            speechSynthesizer.speak(currentUtterance)
        }
    }
}





struct ContentView: View {
    
    let preBuiltStories: [StoryContent] = parseStoriesFromTextFiles(filenames: ["TheAdventureBegins", "MobyDick", "Story3"])

    @State private var userGeneratedStories: [StoryContent] = []
    
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
