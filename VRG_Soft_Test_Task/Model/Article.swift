//


import Foundation

struct Article: Identifiable, Equatable {
    let id: String     
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String

    init(dto: ArticleDTOModel) {
        self.id = dto.url
        self.title = dto.title
        self.description = dto.description
        self.url = dto.url
        self.urlToImage = dto.urlToImage
        self.publishedAt = dto.publishedAt
    }
}
