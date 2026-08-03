//
//  MenuBarIconStyle.swift
//  TodoMenuBar
//
//  Lets the user pick which SF Symbol shows in the menu bar.
//

import Foundation

enum MenuBarIconStyle: String, CaseIterable, Identifiable {
    case checkmark
    case checklist
    case listBullet
    case clipboard

    var id: String { rawValue }

    var label: String {
        switch self {
        case .checkmark: return "Checkmark"
        case .checklist: return "Checklist"
        case .listBullet: return "List"
        case .clipboard: return "Clipboard"
        }
    }

    var symbolName: String {
        switch self {
        case .checkmark: return "checkmark"
        case .checklist: return "checklist"
        case .listBullet: return "list.bullet"
        case .clipboard: return "list.bullet.clipboard"
        }
    }
}
