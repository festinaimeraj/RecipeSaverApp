import SwiftUI

struct TabBar: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white 
    }

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            AddRecipeView()
                .tabItem {
                    Label("New", systemImage: "plus")
                }
            FavoriteView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
    }
}
