//


import SwiftUI

struct CategoriesView: View {

    @StateObject var vm: CategoriesViewModel
    @EnvironmentObject private var favorites: FavoritesStore

    var body: some View {
        CategoriesContent(
            selected: $vm.selected,
            loader: vm.loader,
            onSelect: { cat in
                await vm.selectCategory(cat)
            },
            onReload: { await vm.reload() },
            onLoadNextPage: { await vm.loadNextPage() },
            onToggleFavorite: { article in await favorites.toggle(article: article) },
            isFavorite: { favorites.isFavorite($0) }
        )
        .task { await vm.onAppear() }
    }
}

struct CategoriesContent: View {

    @Binding var selected: NewsCategory
    @ObservedObject var loader: PaginatedLoaderViewModel

    let onSelect: (NewsCategory) async -> Void
    let onReload: () async -> Void
    let onLoadNextPage: () async -> Void
    let onToggleFavorite: (Article) async -> Void
    let isFavorite: (String) -> Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(NewsCategory.allCases) { cat in
                            Button {
                                Task { await onSelect(cat) }
                            } label: {
                                Text(cat.title)
                                    .font(.subheadline.weight(.semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(selected == cat
                                                ? Color.primary.opacity(0.12)
                                                : Color.secondary.opacity(0.08))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }

                if loader.isRefreshing && loader.items.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else if loader.items.isEmpty && loader.errorText == nil {
                    EmptyStateView(title: "No news", subtitle: "Try another category.")

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
            .navigationTitle("Categories")
            .animation(.default, value: selected)
        }
    }
}
