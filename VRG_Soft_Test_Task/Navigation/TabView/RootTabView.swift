//


import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView(vm: HomeViewModel(service: NewsService()))
                .tabItem { Label("Home", systemImage: "house") }

            CategoriesView(vm: CategoriesViewModel(service: NewsService()))
                .tabItem { Label("Categories", systemImage: "square.grid.2x2") }

            FavoritesView()
                .tabItem { Label("Favorites", systemImage: "star.fill") }
        }
    }
}
