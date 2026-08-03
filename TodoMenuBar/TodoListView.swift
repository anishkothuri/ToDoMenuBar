//
//  TodoListView.swift
//  TodoMenuBar
//
//  The contents of the popup that appears when you click the checkmark
//  icon in the menu bar.
//

import SwiftUI
import AppKit

struct TodoListView: View {
    @EnvironmentObject var store: TodoStore
    @State private var newItemTitle: String = ""
    @FocusState private var isInputFocused: Bool
    @Environment(\.openWindow) private var openWindow

    @AppStorage("TodoMenuBar.appearanceMode") private var appearanceModeRaw: String = AppearanceMode.system.rawValue
    @AppStorage("TodoMenuBar.popupSize") private var popupSizeRaw: String = PopupSize.standard.rawValue

    private var appearanceMode: AppearanceMode {
        AppearanceMode(rawValue: appearanceModeRaw) ?? .system
    }
    private var popupSize: PopupSize {
        PopupSize(rawValue: popupSizeRaw) ?? .standard
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("To-Do List")
                    .font(.headline)
                Spacer()
                Button {
                    openWindow(id: "settings")
                } label: {
                    Image(systemName: "gearshape")
                }
                .buttonStyle(.plain)
                .help("Settings")
                .accessibilityLabel("Settings")
            }
            .padding([.top, .horizontal])
            .padding(.bottom, 4)

            HStack {
                TextField("Add a task...", text: $newItemTitle)
                    .textFieldStyle(.roundedBorder)
                    .focused($isInputFocused)
                    .onSubmit(addItem)
                Button("Add", action: addItem)
                    .disabled(newItemTitle.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)

            Divider()

            if store.items.isEmpty {
                Text("No tasks yet — add one above.")
                    .foregroundColor(.secondary)
                    .font(.callout)
                    .padding()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(sortedItems) { item in
                            TodoRow(item: item)
                                .transition(.opacity.combined(with: .scale(scale: 0.97)))
                        }
                    }
                    .padding(.vertical, 4)
                }
                .frame(maxHeight: popupSize.listMaxHeight)
                .animation(.easeInOut(duration: 0.15), value: sortedItems)
            }

            Divider()

            HStack(spacing: 10) {
                if hasCompletedItems {
                    Button("Clear Completed") {
                        withAnimation { store.clearCompleted() }
                    }
                    .font(.caption)
                    .buttonStyle(.plain)
                    .foregroundColor(.secondary)
                }
                Spacer()
                Text("\(remainingCount) remaining")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .font(.caption)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .frame(width: popupSize.width)
        .onAppear { isInputFocused = true }
        // MenuBarExtra's .window style draws a translucent, appearance-
        // following material behind the content. That's fine for System
        // and Dark, but it makes "Light" look like a darkened light mode
        // when the Mac itself is set to Dark. Force a flat white
        // background + black text here so Light is unambiguously light.
        .background(appearanceMode == .light ? Color.white : Color.clear)
        .foregroundColor(appearanceMode == .light ? Color.black : nil)
    }

    private var sortedItems: [TodoItem] {
        // Unfinished items first (stable within each group by creation order).
        store.items
            .enumerated()
            .sorted { lhs, rhs in
                if lhs.element.isDone != rhs.element.isDone {
                    return !lhs.element.isDone
                }
                return lhs.offset < rhs.offset
            }
            .map { $0.element }
    }

    private var remainingCount: Int {
        store.items.filter { !$0.isDone }.count
    }

    private var hasCompletedItems: Bool {
        store.items.contains { $0.isDone }
    }

    private func addItem() {
        withAnimation { store.add(newItemTitle) }
        newItemTitle = ""
    }
}

struct TodoRow: View {
    @EnvironmentObject var store: TodoStore
    let item: TodoItem

    @State private var isEditing = false
    @State private var editedTitle = ""
    @State private var isHovering = false
    @FocusState private var isFieldFocused: Bool

    var body: some View {
        HStack {
            Button(action: { withAnimation { store.toggle(item) } }) {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isDone ? .green : .secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(item.isDone ? "Mark as not done" : "Mark as done")

            if isEditing {
                TextField("Task", text: $editedTitle)
                    .textFieldStyle(.plain)
                    .focused($isFieldFocused)
                    .onSubmit(commitEdit)
                    .onChange(of: isFieldFocused) { focused in
                        // Also commit if the field loses focus (e.g. the
                        // user clicks elsewhere) instead of pressing Return.
                        if !focused { commitEdit() }
                    }
            } else {
                Text(item.title)
                    .strikethrough(item.isDone)
                    .foregroundColor(item.isDone ? .secondary : .primary)
                    .lineLimit(2)
                    .onTapGesture(count: 2) { beginEdit() }
                    .help("Double-click to rename")
            }

            Spacer()

            Button(action: { withAnimation { store.delete(item) } }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary.opacity(isHovering ? 0.8 : 0.35))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Delete task")
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(isHovering ? Color.primary.opacity(0.06) : Color.clear)
        )
        .padding(.horizontal, 4)
        .onHover { hovering in isHovering = hovering }
    }

    private func beginEdit() {
        editedTitle = item.title
        isEditing = true
        isFieldFocused = true
    }

    private func commitEdit() {
        store.rename(item, to: editedTitle)
        isEditing = false
    }
}
