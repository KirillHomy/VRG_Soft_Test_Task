//


import SwiftUI

struct PaginatedListView<Row: View>: View {

    @ObservedObject var loader: PaginatedLoaderViewModel
    let onReload: () async -> Void
    let onLoadNextPage: () async -> Void
    let row: (Article) -> Row

    var body: some View {
        VStack(spacing: 0) {
            statusBar

            List {
                ForEach(loader.items) { article in
                    row(article)
                }

                if loader.canLoadMore() {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .onAppear {
                        guard loader.canTriggerNextFromSentinel() else { return }
                        Task { await onLoadNextPage() }
                    }
                } else if !loader.items.isEmpty {
                    HStack {
                        Spacer()
                        Text("End of list")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
            }
            .refreshable { await onReload() }
        }
    }

    private var statusBar: some View {
        HStack(spacing: 12) {
            if loader.isRefreshing {
                Label("Refreshing…", systemImage: "arrow.clockwise")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            if loader.isLoadingNextPage {
                Label("Loading more…", systemImage: "hourglass")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if let date = loader.lastUpdatedAt {
                Text("Updated: \(date.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.top, 6)
    }
}
