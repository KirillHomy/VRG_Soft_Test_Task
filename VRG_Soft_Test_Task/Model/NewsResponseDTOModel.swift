//


import Foundation

struct NewsResponseDTOModel: Decodable {
    let status: String
    let totalResults: Int
    let articles: [ArticleDTOModel]
}

struct ArticleDTOModel: Decodable {
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
}
