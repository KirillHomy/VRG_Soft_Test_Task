//


import Foundation
import SwiftData

@Model
final class FavoriteArticleModel {
    @Attribute(.unique) var id: String
    var title: String
    var desc: String?
    var url: String
    var imageUrl: String?
    var publishedAt: String
    var createdAt: Date

    init(article: Article) {
        self.id = article.id
        self.title = article.title
        self.desc = article.description
        self.url = article.url
        self.imageUrl = article.urlToImage
        self.publishedAt = article.publishedAt
        self.createdAt = Date()
    }
}
