import XCTest
@testable import TodoMenuBar

final class TodoStoreTests: XCTestCase {
    var store: TodoStore!

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "TodoMenuBar.items")
        store = TodoStore()
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "TodoMenuBar.items")
        store = nil
        super.tearDown()
    }

    func testAddTrimsWhitespaceAndIgnoresEmpty() {
        store.add("  Buy milk  ")
        store.add("   ")
        XCTAssertEqual(store.items.count, 1)
        XCTAssertEqual(store.items.first?.title, "Buy milk")
    }

    func testToggleFlipsIsDone() {
        store.add("Task")
        let item = store.items[0]
        XCTAssertFalse(item.isDone)
        store.toggle(item)
        XCTAssertTrue(store.items[0].isDone)
        store.toggle(item)
        XCTAssertFalse(store.items[0].isDone)
    }

    func testRenameUpdatesTitle() {
        store.add("Old title")
        let item = store.items[0]
        store.rename(item, to: "New title")
        XCTAssertEqual(store.items[0].title, "New title")
    }

    func testRenameIgnoresEmptyTitle() {
        store.add("Keep me")
        let item = store.items[0]
        store.rename(item, to: "   ")
        XCTAssertEqual(store.items[0].title, "Keep me")
    }

    func testDeleteRemovesItem() {
        store.add("Task A")
        store.add("Task B")
        let toDelete = store.items[0]
        store.delete(toDelete)
        XCTAssertEqual(store.items.count, 1)
        XCTAssertFalse(store.items.contains { $0.id == toDelete.id })
    }

    func testClearCompletedRemovesOnlyDoneItems() {
        store.add("Done task")
        store.add("Pending task")
        store.toggle(store.items[0])
        store.clearCompleted()
        XCTAssertEqual(store.items.count, 1)
        XCTAssertEqual(store.items.first?.title, "Pending task")
    }

    func testPersistenceRoundTrip() {
        store.add("Persisted task")
        let reloaded = TodoStore()
        XCTAssertEqual(reloaded.items.count, 1)
        XCTAssertEqual(reloaded.items.first?.title, "Persisted task")
    }
}
