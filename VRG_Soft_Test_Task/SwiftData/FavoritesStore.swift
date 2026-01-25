//


import Foundation
import SwiftData
import Combine

@MainActor
final class FavoritesStore: ObservableObject {

    @Published private(set) var favoriteIDs: Set<String> = []

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func isFavorite(_ id: String) -> Bool {
        favoriteIDs.contains(id)
    }

    func reload() async {
        do {
            let descriptor = FetchDescriptor<FavoriteArticleModel>()
            let items = try context.fetch(descriptor)
            favoriteIDs = Set(items.map { $0.id })
        } catch {
            favoriteIDs = []
        }
    }

    func toggle(article: Article) async {
        if isFavorite(article.id) {
            await remove(id: article.id)
        } else {
            await add(article: article)
        }
    }

    func add(article: Article) async {
        let fav = FavoriteArticleModel(article: article)
        context.insert(fav)
        do { try context.save() } catch { }
        favoriteIDs.insert(article.id)
    }

    func remove(id: String) async {
        do {
            let descriptor = FetchDescriptor<FavoriteArticleModel>(
                predicate: #Predicate { $0.id == id }
            )
            let items = try context.fetch(descriptor)
            items.forEach { context.delete($0) }
            try context.save()
        } catch { }
        favoriteIDs.remove(id)
    }
}
