//


import Foundation

enum NewsCategory: String, CaseIterable, Identifiable {
    
    case general, business, entertainment, health, science, sports, technology
    
    var id: String { rawValue }
    var title: String { rawValue.capitalized }
}
