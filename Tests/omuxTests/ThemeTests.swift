import AppKit
import XCTest
@testable import omux

final class ThemeTests: XCTestCase {
    private func hex(_ color: NSColor) -> UInt32 {
        let c = color.usingColorSpace(.calibratedRGB) ?? color
        let r = UInt32((c.redComponent * 255).rounded())
        let g = UInt32((c.greenComponent * 255).rounded())
        let b = UInt32((c.blueComponent * 255).rounded())
        return (r << 16) | (g << 8) | b
    }

    func testAllThemesHaveValidPalettesAndSwatches() {
        for theme in Theme.allCases {
            XCTAssertEqual(theme.palette.count, 16, "\(theme.rawValue) should have 16 ANSI colors")
            XCTAssertEqual(theme.swatch.count, 6, "\(theme.rawValue) should have 6 swatch colors")
        }
        XCTAssertEqual(Theme.darkThemes.count + Theme.lightThemes.count, Theme.allCases.count)
    }

    func testCobalt2Colors() {
        let theme = Theme.cobalt2
        XCTAssertEqual(theme.label, "Cobalt2")
        XCTAssertFalse(theme.isLight)
        XCTAssertEqual(theme.colorScheme, .dark)
        XCTAssertTrue(Theme.darkThemes.contains(.cobalt2))

        XCTAssertEqual(hex(theme.background), 0x193549)
        XCTAssertEqual(hex(theme.chrome), 0x15232D)
        XCTAssertEqual(hex(theme.foreground), 0xFFFFFF)
        XCTAssertEqual(hex(theme.accent), 0x0088FF)

        let expectedSwatch: [UInt32] = [0xFF628C, 0x3AD900, 0xFFC600, 0x0088FF, 0xFB94FF, 0x80FCFF]
        XCTAssertEqual(theme.swatch.map(hex), expectedSwatch)

        // Bright black (#0050A4) is index 8 in the ANSI palette
        let brightBlack = theme.palette[8]
        XCTAssertEqual(brightBlack.red, 0x00 * 257)
        XCTAssertEqual(brightBlack.green, 0x50 * 257)
        XCTAssertEqual(brightBlack.blue, 0xA4 * 257)
    }
}
