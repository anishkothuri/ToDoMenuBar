//
//  LoginItemManager.swift
//  TodoMenuBar
//
//  Registers this app to launch automatically at login using the modern
//  ServiceManagement API (macOS 13 Ventura and later). Once registered,
//  macOS remembers this on its own — it also shows up under System
//  Settings > General > Login Items & Extensions, where the user can
//  turn it off manually if they ever want to.
//

import Foundation
import ServiceManagement

final class LoginItemManager {
    static let shared = LoginItemManager()

    var isEnabled: Bool {
        guard #available(macOS 13.0, *) else { return false }
        return SMAppService.mainApp.status == .enabled
    }

    /// Registers at login the very first time the app is ever opened, so a
    /// freshly downloaded copy behaves like a normal installed app without
    /// the user having to find a setting first. After this one-time nudge,
    /// only the explicit "Launch at Login" toggle in Settings changes it —
    /// we never silently re-enable something the user turned off.
    func registerAtLoginIfFirstLaunch() {
        guard #available(macOS 13.0, *) else { return }
        let defaults = UserDefaults.standard
        let key = "TodoMenuBar.didRequestInitialLoginItem"
        guard !defaults.bool(forKey: key) else { return }
        defaults.set(true, forKey: key)
        setEnabled(true)
    }

    func setEnabled(_ enabled: Bool) {
        guard #available(macOS 13.0, *) else { return }
        do {
            if enabled {
                if SMAppService.mainApp.status != .enabled {
                    try SMAppService.mainApp.register()
                }
            } else if SMAppService.mainApp.status == .enabled {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print("TodoMenuBar: failed to update login item — \(error)")
        }
    }
}
