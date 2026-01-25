//


import SwiftUI

struct ArticleCell: View {

    let article: Article
    let onStarTap: () -> Void
    let isFavorite: Bool

    private var imageURL: URL? {
        guard let s = article.urlToImage,
              let url = URL(string: s),
              !s.isEmpty
        else { return nil }
        return url
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            VStack(alignment: .leading, spacing: 6) {
                Text(article.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                if let description = article.description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                }

                Text(article.publishedAt)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 6)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 10) {
                Button(action: onStarTap) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .imageScale(.large)
                }
                .buttonStyle(.plain)
                Spacer()
                ArticleImageView(url: imageURL)
            }
        }
        .padding(.vertical, 8)
    }
}

private struct ArticleImageView: View {
    let url: URL?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.secondary.opacity(0.12))

            if let url {
                AsyncImage(url: url, transaction: Transaction(animation: .default)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .controlSize(.small)

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .transition(.opacity)

                    case .failure:
                        Image(systemName: "photo")
                            .imageScale(.medium)
                            .foregroundStyle(.secondary)

                    @unknown default:
                        Image(systemName: "photo")
                            .imageScale(.medium)
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                Image(systemName: "photo")
                    .imageScale(.medium)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 84, height: 84)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(RoundedRectangle(cornerRadius: 12))
    }
}

