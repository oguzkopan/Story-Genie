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


struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}

