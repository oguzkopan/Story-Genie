import Foundation

struct StoryContent: Identifiable { // Add Identifiable conformance here
    let id = UUID() // Unique identifier for each story
    let title: String
    let content: String
}

func parseStoriesFromTextFiles(filenames: [String]) -> [StoryContent] {
    var stories: [StoryContent] = []
    
    for filename in filenames {
        do {
            if let fileURL = Bundle.main.url(forResource: filename, withExtension: "txt") {
                let content = try String(contentsOf: fileURL)
                let lines = content.components(separatedBy: "\n")
                
                if lines.count >= 2 {
                    let title = lines[0]
                    let content = lines[1...].joined(separator: "\n") // Combine all lines after the title to get the content
                    let story = StoryContent(title: title, content: content)
                    stories.append(story)
                }
            }
        } catch {
            print("Error reading \(filename).txt: \(error.localizedDescription)")
        }
    }
    
    return stories
}
