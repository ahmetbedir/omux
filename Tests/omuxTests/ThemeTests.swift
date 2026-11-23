import AppKit
import XCTest
@testable import omux

final class ThemeTests: XCTestCase {
    func testResolveManualIgnoresSystemAppearance() {
        XCTAssertEqual(
            Theme.resolve(followSystem: false, manual: Theme.dracula.rawValue, dark: Theme.nord.rawValue,
                          light: Theme.githubLight.rawValue, systemIsDark: false),
            .dracula
        )
        XCTAssertEqual(
            Theme.resolve(followSystem: false, manual: Theme.solarizedLight.rawValue, dark: Theme.nord.rawValue,
                          light: Theme.githubLight.rawValue, systemIsDark: true),
            .solarizedLight
        )
        XCTAssertEqual(
            Theme.resolve(followSystem: false, manual: "nonexistent", dark: Theme.nord.rawValue,
                          light: Theme.githubLight.rawValue, systemIsDark: false),
            .black
        )
    }

    func testResolveFollowsSystemAppearance() {
        XCTAssertEqual(
            Theme.resolve(followSystem: true, manual: Theme.light.rawValue, dark: Theme.catppuccin.rawValue,
                          light: Theme.catppuccinLatte.rawValue, systemIsDark: true),
            .catppuccin
        )
        XCTAssertEqual(
            Theme.resolve(followSystem: true, manual: Theme.black.rawValue, dark: Theme.catppuccin.rawValue,
                          light: Theme.catppuccinLatte.rawValue, systemIsDark: false),
            .catppuccinLatte
        )
    }

    func testResolveFallsBackWhenPolarityMismatches() {
        XCTAssertEqual(
            Theme.resolve(followSystem: true, manual: Theme.black.rawValue, dark: Theme.light.rawValue,
                          light: Theme.githubLight.rawValue, systemIsDark: true),
            .black
        )
        XCTAssertEqual(
            Theme.resolve(followSystem: true, manual: Theme.black.rawValue, dark: Theme.dracula.rawValue,
                          light: Theme.dracula.rawValue, systemIsDark: false),
            .light
        )
    }

    func testCounterpartPairsMatchingThemes() {
        XCTAssertEqual(Theme.catppuccin.counterpart, .catppuccinLatte)
        XCTAssertEqual(Theme.catppuccinLatte.counterpart, .catppuccin)
        XCTAssertEqual(Theme.solarizedDark.counterpart, .solarizedLight)
        XCTAssertEqual(Theme.solarizedLight.counterpart, .solarizedDark)
        XCTAssertEqual(Theme.midnight.counterpart, .githubLight)
        XCTAssertEqual(Theme.githubLight.counterpart, .midnight)
        XCTAssertEqual(Theme.dracula.counterpart, .light)
        XCTAssertEqual(Theme.light.counterpart, .black)
    }

    func testSystemAppearanceDetectsAquaAndDarkAqua() {
        XCTAssertTrue(SystemAppearance.isDark(NSAppearance(named: .darkAqua)))
        XCTAssertFalse(SystemAppearance.isDark(NSAppearance(named: .aqua)))
    }

    private func hex(_ color: NSColor) -> UInt32 {
        let c = color.usingColorSpace(.sRGB) ?? color
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
        XCTAssertEqual(hex(theme.chrome), 0x122738)
        XCTAssertEqual(hex(theme.foreground), 0xFFFFFF)
        XCTAssertEqual(hex(theme.caret), 0xFFC600)
        XCTAssertEqual(hex(theme.accent), 0x0088FF)
        XCTAssertEqual(hex(Theme.black.caret), hex(Theme.black.foreground))

        let expectedSwatch: [UInt32] = [0xFF628C, 0x3AD900, 0xFFC600, 0x0088FF, 0xFB94FF, 0x80FCFF]
        XCTAssertEqual(theme.swatch.map(hex), expectedSwatch)

        // Bright black (#0050A4) is index 8 in the ANSI palette
        let brightBlack = theme.palette[8]
        XCTAssertEqual(brightBlack.red, 0x00 * 257)
        XCTAssertEqual(brightBlack.green, 0x50 * 257)
        XCTAssertEqual(brightBlack.blue, 0xA4 * 257)
    }
}
