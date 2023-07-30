import SwiftUI
import Alamofire
import Combine


class FavoritesViewModel: ObservableObject {
    @Published private(set) var favorites: [GeneratedStory] = []

    func addFavorite(_ favorite: GeneratedStory) {
        favorites.append(favorite)
        saveFavorites()
        print("Added favorite: \(favorite.content)")
    }

    private func saveFavorites() {
        do {
            let data = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(data, forKey: "Favorites")
        } catch {
            print("Error saving favorites: \(error)")
        }
    }

    // Load favorites from UserDefaults when the ViewModel is initialized
    init() {
        loadFavorites()
    }

    func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "Favorites") {
            do {
                favorites = try JSONDecoder().decode([GeneratedStory].self, from: data)
                print("Loaded favorites: \(favorites)")
            } catch {
                print("Error loading favorites: \(error)")
            }
        }
    }
}


struct FavoritesView: View {
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel

    var body: some View {
        NavigationView {
            List(favoritesViewModel.favorites, id: \.id) { favorite in
                NavigationLink(destination: StoryDetailView(story: favorite.toStoryContent())) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(favorite.content)
                            .font(.body)
                            .lineLimit(2) // Limit the number of lines to 2
                            .multilineTextAlignment(.leading)

                        // Additional views or information about the favorite story can be added here.
                        Text("Created on: \(formattedDate(favorite.createdAt))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationBarTitle("Favorite Stories")
        }
        .onAppear {
            favoritesViewModel.loadFavorites() // Load favorites when the view appears
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
