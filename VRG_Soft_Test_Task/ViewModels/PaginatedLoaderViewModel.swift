//


import Foundation
import Combine

@MainActor
final class PaginatedLoaderViewModel: ObservableObject {

    @Published private(set) var items: [Article] = []
    @Published private(set) var errorText: String?

    @Published private(set) var isRefreshing: Bool = false
    @Published private(set) var isLoadingNextPage: Bool = false
    @Published private(set) var lastUpdatedAt: Date? = nil

    private var page: Int = 1
    private var total: Int = Int.max
    private let pageSize: Int = 5

    private var lastTriggerCount: Int = -1

    func canLoadMore() -> Bool {
        items.count < total && !isRefreshing && !isLoadingNextPage
    }
    
    func canTriggerNextFromSentinel() -> Bool {
        guard canLoadMore() else { return false }

        if items.count == lastTriggerCount { return false }

        lastTriggerCount = items.count
        return true
    }

    func loadFirst(
        _ fetch: @escaping (_ page: Int, _ pageSize: Int) async throws -> (articles: [Article], total: Int)
    ) async {
        isRefreshing = true
        errorText = nil
        defer { isRefreshing = false }

        // reset
        page = 1
        total = Int.max
        items = []
        lastTriggerCount = -1

        do {
            let result = try await fetch(page, pageSize)
            total = result.total
            items = result.articles
            page = 2
            lastUpdatedAt = Date()
        } catch {
            errorText = error.localizedDescription
        }
    }

    func loadNext(
        _ fetch: @escaping (_ page: Int, _ pageSize: Int) async throws -> (articles: [Article], total: Int)
    ) async {
        guard !isLoadingNextPage else { return }
        guard items.count < total else { return }

        isLoadingNextPage = true
        errorText = nil
        defer { isLoadingNextPage = false }

        do {
            let result = try await fetch(page, pageSize)
            total = result.total

            if result.articles.isEmpty {
                total = items.count
                return
            }

            items.append(contentsOf: result.articles)
            page += 1
            lastUpdatedAt = Date()
        } catch {
            errorText = error.localizedDescription
        }
    }
}
