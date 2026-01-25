//


import Foundation

final class NewsService: NewsServiceProtocol {

    private let apiKey = Constants.newsAPIKey

    func fetchTopHeadlines(
        query: String?,
        category: NewsCategory?,
        page: Int,
        pageSize: Int
    ) async throws -> (articles: [Article], total: Int) {

        var components = URLComponents(string: "https://newsapi.org/v2/top-headlines")!
        var items: [URLQueryItem] = [
            .init(name: "apiKey", value: apiKey),
            .init(name: "page", value: "\(page)"),
            .init(name: "pageSize", value: "\(pageSize)"),
            .init(name: "country", value: "us")
        ]

        if let query, !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            items.append(.init(name: "q", value: query))
        }

        if let category {
            items.append(.init(name: "category", value: category.rawValue))
        }

        components.queryItems = items
        guard let url = components.url else { throw URLError(.badURL) }

        let (data, response) = try await URLSession.shared.data(from: url)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw NSError(domain: "NewsAPI", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode)"])
        }

        let decoded = try JSONDecoder().decode(NewsResponseDTOModel.self, from: data)
        return (decoded.articles.map(Article.init(dto:)), decoded.totalResults)
    }
}
