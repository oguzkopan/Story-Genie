import SwiftUI
import AVFoundation
import Alamofire


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
