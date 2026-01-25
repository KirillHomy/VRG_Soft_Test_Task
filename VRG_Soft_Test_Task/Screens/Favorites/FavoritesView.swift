//


import SwiftUI
import SwiftData

struct FavoritesView: View {

    @Environment(\.modelContext) private var context
    @EnvironmentObject private var favorites: FavoritesStore

    @Query(sort: \FavoriteArticleModel.createdAt, order: .reverse)
    private var items: [FavoriteArticleModel]

    var body: some View {
        NavigationStack {
            Group {
                if items.isEmpty {
                    EmptyStateView(title: "No favorites",
                                   subtitle: "Add articles to favorites to see them here.")
                } else {
                    List {
                        ForEach(items) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(item.title)
                                    .font(.headline)
                                if let description = item.desc,
                                    !description.isEmpty {
                                    Text(description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary).lineLimit(3)
                                }
                                Text(item.publishedAt)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 8)
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
            .navigationTitle("Favorites")
            .refreshable { await favorites.reload() }
            .task { await favorites.reload() }
        }
    }

    private func delete(_ indexSet: IndexSet) {
        let toDelete = indexSet.map { items[$0] }
        toDelete.forEach { context.delete($0) }
        do { try context.save() } catch { }
        Task { await favorites.reload() }
    }
}
