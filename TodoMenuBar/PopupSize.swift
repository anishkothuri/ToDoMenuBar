//
//  PopupSize.swift
//  TodoMenuBar
//
//  Lets the user pick how big the popup is, independent of appearance.
//

import Foundation

enum PopupSize: String, CaseIterable, Identifiable {
    case compact
    case standard
    case large

    var id: String { rawValue }

    var label: String {
        switch self {
        case .compact: return "Compact"
        case .standard: return "Standard"
        case .large: return "Large"
        }
    }

    var width: CGFloat {
        switch self {
        case .compact: return 260
        case .standard: return 300
        case .large: return 380
        }
    }

    /// Floor for the task list area, so the popup has a stable, roomy
    /// size even with zero or few tasks instead of shrink-wrapping tiny.
    var listMinHeight: CGFloat {
        switch self {
        case .compact: return 160
        case .standard: return 220
        case .large: return 300
        }
    }

    /// Ceiling for the task list area — beyond this it scrolls instead of
    /// growing the popup further.
    var listMaxHeight: CGFloat {
        switch self {
        case .compact: return 260
        case .standard: return 380
        case .large: return 520
        }
    }
}
