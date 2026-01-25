//


import SwiftUI
import SwiftData

@main
struct VRG_Soft_Test_TaskApp: App {

    private let container: ModelContainer
    @StateObject private var favoritesStore: FavoritesStore

    init() {
        do {
            container = try ModelContainer(for: FavoriteArticleModel.self)
        } catch {
            fatalError("SwiftData container error: \(error)")
        }

        let store = FavoritesStore(context: container.mainContext)
        _favoritesStore = StateObject(wrappedValue: store)
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(\.modelContext, container.mainContext)
                .environmentObject(favoritesStore)
                .task { await favoritesStore.reload() }
        }
    }
}
