//


import Foundation

protocol NewsServiceProtocol {
    func fetchTopHeadlines(
        query: String?,
        category: NewsCategory?,
        page: Int,
        pageSize: Int
    ) async throws -> (articles: [Article], total: Int)
}
