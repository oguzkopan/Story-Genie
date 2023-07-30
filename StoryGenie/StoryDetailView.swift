import SwiftUI
import AVFoundation
import Alamofire


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
