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

    // Launch at Login starts off. It's never registered automatically —
    // only the toggle in Settings turns it on, via LoginItemManager.

    var body: some Scene {
        MenuBarExtra {
            TodoListView()
                .environmentObject(store)
                .preferredColorScheme((AppearanceMode(rawValue: appearanceModeRaw) ?? .system).colorScheme)
        } label: {
            // Plain checkmark, no circle, no count badge — click it to see
            // what's left.
            Image(systemName: "checkmark")
                .accessibilityLabel(remainingCount > 0 ? "TodoMenuBar, \(remainingCount) tasks remaining" : "TodoMenuBar, all tasks complete")
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
