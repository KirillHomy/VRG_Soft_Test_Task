//

import SwiftUI

struct HomeView: View {
    @StateObject var vm: HomeViewModel
    @EnvironmentObject private var favorites: FavoritesStore

    var body: some View {
        HomeContent(
            loader: vm.loader,
            searchText: $vm.searchText,
            onSearchChanged: vm.onSearchChanged,
            onReload: { await vm.reload() },
            onLoadNextPage: { await vm.loadNextPage() },
            onToggleFavorite: { article in await favorites.toggle(article: article) },
            isFavorite: { favorites.isFavorite($0) }
        )
        .task { await vm.onAppear() }
    }
}

struct HomeContent: View {
    @ObservedObject var loader: PaginatedLoaderViewModel

    @Binding var searchText: String
    let onSearchChanged: () -> Void
    let onReload: () async -> Void
    let onLoadNextPage: () async -> Void
    let onToggleFavorite: (Article) async -> Void
    let isFavorite: (String) -> Bool

    var body: some View {
        NavigationStack {
            Group {
                if loader.isRefreshing && loader.items.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else if loader.items.isEmpty && loader.errorText == nil {
                    EmptyStateView(title: "No news",
                                   subtitle: "Try another query.")

                } else {
                    PaginatedListView(
                        loader: loader,
                        onReload: onReload,
                        onLoadNextPage: onLoadNextPage
                    ) { article in
                        ArticleCell(
                            article: article,
                            onStarTap: { Task { await onToggleFavorite(article) } },
                            isFavorite: isFavorite(article.id)
                        )
                    }
                }
            }
            .navigationTitle("News")
            .searchable(text: $searchText, prompt: "Search")
            .onChange(of: searchText) { _, _ in onSearchChanged() }
        }
    }
}
