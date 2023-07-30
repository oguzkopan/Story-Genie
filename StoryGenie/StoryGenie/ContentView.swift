import SwiftUI
import AVFoundation
import Alamofire


struct ContentView: View {
    @State private var isLoggedIn: Bool = false
    @State private var userGeneratedStories: [StoryContent] = []
    @State private var showFavorites = false

    // Create an instance of FavoritesViewModel and inject it into the environment
    @StateObject private var favoritesViewModel = FavoritesViewModel()

    let preBuiltStories: [StoryContent] = parseStoriesFromTextFiles(filenames: ["TheAdventureBegins", "MobyDick", "TheGuardiansOfLore"])

    var body: some View {
        NavigationView {
            VStack(spacing: 16) { // Add more spacing here
                List {
                    Section(header:
                        VStack(alignment: .center, spacing: 0) {
                            Text("TURN YOUR DREAMS INTO FAIRY TALES")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity) // Make the header expand to full width
                    ) {
                        NavigationLink(destination: CreateStoryView()) {
                            Text("Create Your Own Story")
                                .frame(maxWidth: .infinity, alignment: .leading) // Left-align the text
                        }
                    }
                }
                .listStyle(GroupedListStyle()) // Apply a list style
                .navigationTitle("Storyteller App")
                .navigationBarTitleDisplayMode(.inline) // Display the title in the navigation bar
                .foregroundColor(.blue) // Set the text color for the entire view
                .background(Color.gray.opacity(0.5)) // Set the background color
                .frame(height: 120)

                // Add the navigation link to the FavoritesView
                NavigationLink(
                    destination: FavoritesView(),
                    isActive: $showFavorites,
                    label: { EmptyView() }
                )
                .hidden() // Hide the navigation link, but it will still work

                // Add a toolbar button to navigate to the Favorites page
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showFavorites = true // Set the showFavorites state to true when the button is tapped
                        }) {
                            Image(systemName: "heart.fill")
                        }
                    }
                }

                // Add the grid for the "Explore Stories" section below the list
                ScrollView {
                    Text("Explore Stories")
                        .font(.headline)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 16)], spacing: 16) {
                        ForEach(preBuiltStories + userGeneratedStories) { story in
                            NavigationLink(destination: StoryDetailView(story: story)) {
                                VStack {
                                    Image(systemName: "book")
                                        .font(.largeTitle)
                                    Text(story.title)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(width: (UIScreen.main.bounds.width - 48) / 3, height: 160)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 4)
                            }
                        }
                    }
                    .padding()
                }
            }
            .padding(16) // Add more padding here
        }
        .environmentObject(favoritesViewModel)
    }

    private func addGeneratedStory(_ story: StoryContent) {
        userGeneratedStories.append(story)
    }
}
