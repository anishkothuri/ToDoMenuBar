//
//  TodoMenuBarApp.swift
//  TodoMenuBar
//
//  App entry point. Puts a checkmark icon in the menu bar and shows the
//  to-do list in a popup window when clicked. There is no Dock icon and
//  no regular window, so the app has nothing to "close" — it simply keeps
//  living in the menu bar until you choose Quit from inside the popup.
//

import SwiftUI
import AppKit

@main
struct TodoMenuBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var store = TodoStore()

    // Persisted appearance choice (System / Light / Dark), shared with the
    // menu inside TodoListView via the same UserDefaults key.
    @AppStorage("TodoMenuBar.appearanceMode") private var appearanceModeRaw: String = AppearanceMode.system.rawValue

    init() {
        // Ask macOS to launch this app automatically at login.
        // Safe to call every launch — it's a no-op if already registered.
        LoginItemManager.shared.registerAtLogin()
    }

    var body: some Scene {
        MenuBarExtra {
            TodoListView()
                .environmentObject(store)
                .preferredColorScheme((AppearanceMode(rawValue: appearanceModeRaw) ?? .system).colorScheme)
        } label: {
            // Plain checkmark, no circle — count of what's left sits right
            // next to it so a glance at the menu bar is enough.
            HStack(spacing: 3) {
                Image(systemName: "checkmark")
                if remainingCount > 0 {
                    Text("\(remainingCount)")
                }
            }
        }
        .menuBarExtraStyle(.window)

        Window("TodoMenuBar Settings", id: "settings") {
            SettingsView()
        }
        .windowResizability(.contentSize)
    }

    private var remainingCount: Int {
        store.items.filter { !$0.isDone }.count
    }
}
