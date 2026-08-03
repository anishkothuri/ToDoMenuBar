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
    @State private var launchAtLogin: Bool = LoginItemManager.shared.isEnabled

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
                Toggle("Launch at Login", isOn: $launchAtLogin)
                    .accessibilityHint("Starts TodoMenuBar automatically when you sign in to your Mac")
                    .onChange(of: launchAtLogin) { newValue in
                        LoginItemManager.shared.setEnabled(newValue)
                    }
                Toggle("Show in Dock", isOn: $showInDock)
                    .accessibilityHint("Adds a Dock icon in addition to the menu bar icon")
                    .onChange(of: showInDock) { newValue in
                        NSApp.setActivationPolicy(newValue ? .regular : .accessory)
                    }
            } header: {
                Text("Startup")
            } footer: {
                Text("Both are off by default until you turn them on — TodoMenuBar starts out living only in the menu bar. You can also manage login items from System Settings > General > Login Items & Extensions.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Section {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(versionString)
                        .foregroundColor(.secondary)
                }
                Link("View on GitHub", destination: URL(string: "https://github.com/anishkothuri/ToDoMenuBar")!)
            } header: {
                Text("About")
            }
        }
        .formStyle(.grouped)
        .frame(width: 380, height: 400)
        .preferredColorScheme(appearanceMode.colorScheme)
        .navigationTitle("TodoMenuBar Settings")
        .onAppear { launchAtLogin = LoginItemManager.shared.isEnabled }
    }

    private var versionString: String {
        let info = Bundle.main.infoDictionary
        let shortVersion = info?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = info?["CFBundleVersion"] as? String ?? "1"
        return "\(shortVersion) (\(build))"
    }
}
