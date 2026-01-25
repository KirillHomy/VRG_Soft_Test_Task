//


import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    @Published var searchText: String = ""
    @Published private(set) var loader = PaginatedLoaderViewModel()

    private let service: NewsServiceProtocol
    private var searchTask: Task<Void, Never>?
    private var didLoadOnce = false 

    init(service: NewsServiceProtocol) {
        self.service = service
    }

    func onAppear() async {
        guard !didLoadOnce else { return }
        didLoadOnce = true
        await reload()
    }

    func reload() async {
        await loader.loadFirst { [service, searchText] page, pageSize in
            try await service.fetchTopHeadlines(
                query: searchText,
                category: nil,
                page: page,
                pageSize: pageSize
            )
        }
    }

    func loadNextPage() async { 
        guard loader.canLoadMore() else { return }
        await loader.loadNext { [service, searchText] page, pageSize in
            try await service.fetchTopHeadlines(
                query: searchText,
                category: nil,
                page: page,
                pageSize: pageSize
            )
        }
    }

    func onSearchChanged() {
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 350_000_000)
            guard !Task.isCancelled else { return }
            await self?.reload()
        }
    }
}
