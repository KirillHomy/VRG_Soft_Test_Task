//


import SwiftUI

struct EmptyStateView: View {
    let title: String
    let subtitle: String

    var body: some View {
        ContentUnavailableView(title,
                               systemImage: "newspaper",
                               description: Text(subtitle))
        .padding()
    }
}
