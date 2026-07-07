import XCTest
@testable import ActionFigureLog

@MainActor
final class ActionFigureLogTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
    }

    func testSeedDataLoadsBelowFreeLimit() {
        XCTAssertLessThan(store.items.count, Store.freeTierLimit)
    }

    func testAddIncreasesCount() {
        let before = store.items.count
        store.add(FigureItem(name: "Test", line: "A", wave: "B"))
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteRemovesItem() {
        let item = FigureItem(name: "ToDelete", line: "A", wave: "B")
        store.add(item)
        store.delete(item)
        XCTAssertFalse(store.items.contains(item))
    }

    func testIsAtFreeLimitFalseInitially() {
        XCTAssertFalse(store.isAtFreeLimit)
    }

    func testIsAtFreeLimitTrueAfterFilling() {
        while store.items.count < Store.freeTierLimit {
            store.add(FigureItem(name: "Filler \(store.items.count)", line: "A", wave: "B"))
        }
        XCTAssertTrue(store.isAtFreeLimit)
    }

    func testUpdateChangesFields() {
        var item = FigureItem(name: "Orig", line: "A", wave: "B")
        store.add(item)
        item.name = "Changed"
        store.update(item)
        XCTAssertEqual(store.items.first(where: { $0.id == item.id })?.name, "Changed")
    }

    func testDeleteAtOffsets() {
        let before = store.items.count
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, before - 1)
    }

    func testPersistenceRoundTrip() {
        store.add(FigureItem(name: "Persisted", line: "A", wave: "B"))
        let reloaded = Store()
        XCTAssertTrue(reloaded.items.contains(where: { $0.name == "Persisted" }))
    }
}
