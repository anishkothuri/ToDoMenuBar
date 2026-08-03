//
//  AppDelegate.swift
//  TodoMenuBar
//
//  NSApp isn't guaranteed to exist yet inside SwiftUI's App.init(), so
//  anything that touches NSApplication.shared (like setting the Dock
//  activation policy) has to wait until applicationDidFinishLaunching.
//

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        let showInDock = UserDefaults.standard.bool(forKey: "TodoMenuBar.showInDock")
        NSApp.setActivationPolicy(showInDock ? .regular : .accessory)
    }
}
