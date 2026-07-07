import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [FigureItem] = []
    @Published var categoryToggles: [String: Bool] = [
        "Show Favorites First": false,
        "Show Notes on Cards": true
    ]

    /// Free-tier cap. Must stay comfortably above the seed-data count so a fresh
    /// install never trips the paywall on first launch.
    static let freeTierLimit = 8

    private let fileName = "actionfigurelog_items.json"

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir.appendingPathComponent(fileName)
    }

    init() {
        load()
        if items.isEmpty {
            items = [
            FigureItem(name: "My First Figure", line: "Sample Line", wave: "Sample Wave"),
            FigureItem(name: "Second Figure", line: "Another Line", wave: "Another Wave"),
            FigureItem(name: "Third Figure", line: "Third Line", wave: "Third Wave")
            ]
            save()
        }
    }

    var isAtFreeLimit: Bool {
        items.count >= Store.freeTierLimit
    }

    func add(_ item: FigureItem) {
        items.append(item)
        save()
    }

    func update(_ item: FigureItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: FigureItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([FigureItem].self, from: data) {
            items = decoded
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
