//


import Foundation
import Combine

@MainActor
final class CategoriesViewModel: ObservableObject {

    @Published var selected: NewsCategory = .general
    @Published private(set) var loader = PaginatedLoaderViewModel()

    private let service: NewsServiceProtocol
    private var didLoadOnce = false

    init(service: NewsServiceProtocol) {
        self.service = service
    }

    func onAppear() async {
        guard !didLoadOnce else { return }
        didLoadOnce = true
        await reload()
    }

    func selectCategory(_ cat: NewsCategory) async {
        selected = cat
        await reload()
    }

    func reload() async {
        let category = selected
        await loader.loadFirst { [service] page, pageSize in
            try await service.fetchTopHeadlines(query: nil, category: category, page: page, pageSize: pageSize)
        }
    }

    func loadNextPage() async {
        let category = selected
        await loader.loadNext { [service] page, pageSize in
            try await service.fetchTopHeadlines(query: nil, category: category, page: page, pageSize: pageSize)
        }
    }
}
