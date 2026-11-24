import XCTest
@testable import omux
@testable import OmuxCore

final class SessionNameTests: XCTestCase {
    func testTopicDropsClaudeCodeStatusGlyph() {
        XCTAssertEqual(TabItem.name(fromTitle: "✳ Fix login bug"), "Fix login bug")
        XCTAssertEqual(TabItem.name(fromTitle: "⠂ Fix login bug"), "Fix login bug")
        XCTAssertEqual(TabItem.name(fromTitle: "Oturum adları"), "Oturum adları")
        XCTAssertEqual(TabItem.name(fromTitle: "✳ 3D viewer"), "3D viewer")
    }

    func testTitlesThatAreNotATopicAreIgnored() {
        XCTAssertNil(TabItem.name(fromTitle: ""))
        XCTAssertNil(TabItem.name(fromTitle: "✳"))
        XCTAssertNil(TabItem.name(fromTitle: "✳ Claude Code"))
        XCTAssertNil(TabItem.name(fromTitle: "claude"))
        XCTAssertNil(TabItem.name(fromTitle: "claude --session-id 10a1d7e0-1234-5678"))
        XCTAssertNil(TabItem.name(fromTitle: "zsh"))
        XCTAssertNil(TabItem.name(fromTitle: "-zsh"))
        XCTAssertNil(TabItem.name(fromTitle: "bash"))
        XCTAssertNil(TabItem.name(fromTitle: "~/Code/channel-api-backend-production"))
        XCTAssertNil(TabItem.name(fromTitle: "/Users/bdr/Code/omux"))
        XCTAssertNil(TabItem.name(fromTitle: "bdr@TDC-JV972D67HH:~/Code/app"))
        XCTAssertNil(TabItem.name(fromTitle: String(repeating: "a", count: 81)))
        XCTAssertEqual(TabItem.name(fromTitle: "Email user@example.com: fix bounce"), "Email user@example.com: fix bounce")
    }

    func testOnlyMadeUpNamesFollowTheTitle() {
        XCTAssertTrue(TabItem(name: "Session 3").autoName)
        XCTAssertTrue(TabItem(name: "Session").autoName)
        XCTAssertFalse(TabItem(name: "API work").autoName)
        XCTAssertFalse(TabItem(name: "Session 3 notes").autoName)
    }

    func testSavedWorkspacesDecodeAutoName() throws {
        let decode = { (json: String) in try JSONDecoder().decode(TabItem.self, from: Data(json.utf8)) }
        XCTAssertTrue(try decode(#"{"name":"Session 2"}"#).autoName)
        XCTAssertFalse(try decode(#"{"name":"Renamed"}"#).autoName)
        XCTAssertFalse(try decode(#"{"name":"Fix login bug","autoName":false}"#).autoName)
        XCTAssertTrue(try decode(#"{"name":"Fix login bug","autoName":true}"#).autoName)
        let tab = try decode(#"{"name":"Fix login bug","autoName":true}"#)
        XCTAssertTrue(try JSONDecoder().decode(TabItem.self, from: JSONEncoder().encode(tab)).autoName)
    }
}
