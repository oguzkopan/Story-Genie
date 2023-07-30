import Foundation
import Alamofire


class OpenAIService {
    private let endpointUrl = "https://api.openai.com/v1/chat/completions"
    
    func sendMessage(messages: [Message], completion: @escaping (Result<OpenAIChatResponse, Error>) -> Void) {
        let openAIMessages = messages.map({ OpenAIChatMessage(role: $0.role, content: $0.content) })
        
        let body = OpenAIChatBody(model: "gpt-3.5-turbo", messages: openAIMessages)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAIAPIKey)"
        ]
        
        AF.request(endpointUrl, method: .post, parameters: body, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: OpenAIChatResponse.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

// Rest of the code follows...


struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
}

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}


struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoice]?

    private enum CodingKeys: String, CodingKey {
        case choices
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        choices = try container.decodeIfPresent([OpenAIChatChoice].self, forKey: .choices)
    }
}

struct OpenAIChatChoice: Decodable {
    let message: OpenAIChatMessage
    
    private enum CodingKeys: String, CodingKey {
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(OpenAIChatMessage.self, forKey: .message)
    }
}


class GeneratedStory: ObservableObject, Identifiable, Codable {
    let id = UUID()
    let content: String
    let createdAt: Date

    init(content: String, createdAt: Date) {
        self.content = content
        self.createdAt = createdAt
    }

    // Implement the required initializer for Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try container.decode(String.self, forKey: .content)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
    }

    // Implement the required method for Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
        try container.encode(createdAt, forKey: .createdAt)
    }

    // Add the CodingKeys enumeration to map the property names during encoding/decoding
    enum CodingKeys: String, CodingKey {
        case content
        case createdAt
    }

    func toGeneratedStoryContent() -> StoryContent {
        return StoryContent(title: "Favorite Story", content: content, createdAt: createdAt)
    }
}


extension GeneratedStory {
    func toStoryContent() -> StoryContent {
        return StoryContent(title: "Favorite Story", content: content, createdAt: createdAt)
    }
}
