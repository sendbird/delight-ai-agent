//
//  TestFontRegistry.swift
//  QuickStart
//

import UIKit
import CoreText

/// Registers the `.ttf` files bundled under `QuickStart/Testing/Fonts`.
///
/// Shared by the mock UI test host and the internal settings screen, so both
/// load the same test fonts the same way.
enum TestFontRegistry {
    /// Family name of the bundled `NotoSansJP-Regular.ttf`.
    static let japaneseFontFamily = "Noto Sans JP"
    /// PostScript name of the same font, for building per-style `UIFont`s.
    static let japaneseFontName = "NotoSansJP-Regular"

    /// Deliberately runtime registration rather than an `Info.plist`
    /// `UIAppFonts` entry: this way the fonts load only when a caller asks
    /// for them, never on an ordinary QuickStart run.
    /// Release builds do not carry the files at all (see `Fonts/TestFonts.md`),
    /// so "not found" is the expected outcome there.
    static func registerBundledFonts() {
        let urls = Bundle.main.urls(forResourcesWithExtension: "ttf", subdirectory: nil) ?? []

        for url in urls {
            var error: Unmanaged<CFError>?
            if CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error) == false {
                // Already-registered is benign; anything else is worth seeing
                // in the host log while debugging a font mismatch.
                print("[TestFontRegistry] Font registration skipped for \(url.lastPathComponent): \(String(describing: error?.takeUnretainedValue()))")
            }
        }
    }

    /// Whether `family` can be used as `SBAFontSet.fontFamily` in this build.
    static func isAvailable(_ family: String) -> Bool {
        UIFont.familyNames.contains(family)
    }
}
