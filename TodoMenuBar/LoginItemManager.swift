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

    func registerAtLogin() {
        if #available(macOS 13.0, *) {
            do {
                if SMAppService.mainApp.status != .enabled {
                    try SMAppService.mainApp.register()
                }
            } catch {
                print("TodoMenuBar: failed to register as login item — \(error)")
            }
        }
    }
}
