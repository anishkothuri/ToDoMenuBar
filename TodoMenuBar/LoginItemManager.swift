//
//  LoginItemManager.swift
//  TodoMenuBar
//
//  Registers this app to launch automatically at login using the modern
//  ServiceManagement API (macOS 13 Ventura and later). Off by default —
//  nothing registers until the user explicitly flips the "Launch at
//  Login" toggle in Settings. Once registered, it also shows up under
//  System Settings > General > Login Items & Extensions, where the user
//  can confirm or turn it off directly.
//

import Foundation
import AppKit
import ServiceManagement

final class LoginItemManager {
    static let shared = LoginItemManager()

    var isEnabled: Bool {
        guard #available(macOS 13.0, *) else { return false }
        return SMAppService.mainApp.status == .enabled
    }

    /// Registers or unregisters the login item. When turning it on, also
    /// opens System Settings to the Login Items & Extensions pane so the
    /// user sees macOS's own native confirmation of the change rather than
    /// it silently happening in the background.
    func setEnabled(_ enabled: Bool) {
        guard #available(macOS 13.0, *) else { return }
        do {
            if enabled {
                if SMAppService.mainApp.status != .enabled {
                    try SMAppService.mainApp.register()
                }
                revealInSystemSettings()
            } else if SMAppService.mainApp.status == .enabled {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("TodoMenuBar: failed to update login item — \(error)")
        }
    }

    private func revealInSystemSettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.LoginItems-Settings.extension") else { return }
        NSWorkspace.shared.open(url)
    }
}
