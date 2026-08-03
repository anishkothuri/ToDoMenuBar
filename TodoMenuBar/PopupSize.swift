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

    var listMaxHeight: CGFloat {
        switch self {
        case .compact: return 220
        case .standard: return 320
        case .large: return 460
        }
    }
}
