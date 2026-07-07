import Foundation

struct FigureItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var line: String
    var wave: String
    var notes: String = ""
    var dateAdded: Date = Date()
    var isFavorite: Bool = false
}
