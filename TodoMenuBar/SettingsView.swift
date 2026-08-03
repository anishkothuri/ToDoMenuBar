//
//  SettingsView.swift
//  TodoMenuBar
//
//  Opened as its own window from the gear button in the popup. Holds every
//  customization option so the popup itself stays uncluttered.
//

import SwiftUI
import AppKit

struct SettingsView: View {
    @AppStorage("TodoMenuBar.appearanceMode") private var appearanceModeRaw: String = AppearanceMode.system.rawValue
    @AppStorage("TodoMenuBar.popupSize") private var popupSizeRaw: String = PopupSize.standard.rawValue
    @AppStorage("TodoMenuBar.showInDock") private var showInDock: Bool = false

    private var appearanceMode: AppearanceMode {
        AppearanceMode(rawValue: appearanceModeRaw) ?? .system
    }

    var body: some View {
        Form {
            Section {
                Picker("Appearance", selection: $appearanceModeRaw) {
                    ForEach(AppearanceMode.allCases) { mode in
                        Label(mode.label, systemImage: mode.icon).tag(mode.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Appearance")
            } footer: {
                Text("Light forces a white background with black text. Dark uses the standard macOS dark appearance. System follows your Mac's setting.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Section {
                Picker("Popup Size", selection: $popupSizeRaw) {
                    ForEach(PopupSize.allCases) { size in
                        Text(size.label).tag(size.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Popup Size")
            }

            Section {
                Toggle("Show in Dock", isOn: $showInDock)
                    .onChange(of: showInDock) { newValue in
                        NSApp.setActivationPolicy(newValue ? .regular : .accessory)
                    }
            } header: {
                Text("Dock")
            } footer: {
                Text("Off by default so TodoMenuBar only lives in the menu bar. Turn this on if you'd like a Dock icon too.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .formStyle(.grouped)
        .frame(width: 380, height: 320)
        .preferredColorScheme(appearanceMode.colorScheme)
        .navigationTitle("TodoMenuBar Settings")
    }
}
