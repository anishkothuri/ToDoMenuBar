//
//  AppearanceMode.swift
//  TodoMenuBar
//
//  The three appearance choices offered from the popup's appearance menu.
//  "System" follows whatever your Mac is set to (System Settings >
//  Appearance) and updates automatically if that changes; "Light" and
//  "Dark" pin the popup to that look regardless of the system setting.
//

import SwiftUI

enum AppearanceMode: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var label: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }

    var icon: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }

    /// nil tells SwiftUI to defer to the system appearance.
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
