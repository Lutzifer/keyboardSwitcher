import Foundation
import InputMethodKit

class CommandCenter {
    func printLayout() {
        // Only the layout name goes to stdout
        print(KeyboardManager.shared.currentKeyboardLayout.localizedName)
    }

    func listLayouts() {
        fputs("Available Layouts:\n", stderr)
        printLayouts(layouts: KeyboardManager.shared.keyboardLayouts)
    }

    func listEnabled() {
        fputs("Enabled Layouts:\n", stderr)
        printLayouts(layouts: KeyboardManager.shared.enabledLayouts)
    }

    internal func printLayouts(layouts: [KeyboardSource]) {
        // Only the list of layouts goes to stdout
        print(
            layouts
                .map { "\t\($0.localizedName)" }
                .sorted()
                .joined(separator: "\n")
        )
    }

    func selectLayout(layout: String) {
        fputs("Selecting \"\(layout)\"...\n", stderr)
        if let keyboardSource = KeyboardManager.shared.findKeyboardSource(enabledOnly: true, layoutIdentifier:layout) {
            KeyboardManager.shared.selectLayout(withSource: keyboardSource)
        } else {
            fputs("Unable to reconcile \"\(layout)\" with a KeyboardSource. May need to enable first.\n", stderr)
            exit(1)
        }
    }
    
    func enableLayout(layout: String) {
        fputs("Enabling \"\(layout)\"...\n", stderr)
        if let keyboardSource = KeyboardManager.shared.findKeyboardSource(enabledOnly: false, layoutIdentifier:layout) {
            if keyboardSource.enabled {
                fputs("\"\(layout)\" is already enabled.\n", stderr)
                return
            }
            KeyboardManager.shared.enableLayout(withSource: keyboardSource)
        } else {
            fputs("Unable to reconcile \"\(layout)\" with a KeyboardSource.\n", stderr)
            exit(1)
        }
    }
    
    func disableLayout(layout: String) {
        fputs("Disabling \"\(layout)\"...\n", stderr)
        if let keyboardSource = KeyboardManager.shared.findKeyboardSource(enabledOnly: false, layoutIdentifier:layout) {
            if !keyboardSource.enabled {
                fputs("\"\(layout)\" is already disabled.\n", stderr)
                return
            }
            KeyboardManager.shared.disableLayout(withSource: keyboardSource)
        } else {
            fputs("Unable to reconcile \"\(layout)\" with a KeyboardSource.\n", stderr)
            exit(1)
        }
    }

    func printJSON() {
        do {
            guard let jsonString = String(
                data: try JSONEncoder().encode(KeyboardManager.shared.enabledLayouts),
                encoding: .utf8
            ) else {
                fputs("Error converting JSON data to string\n", stderr)
                return
            }
            print(jsonString)
        } catch {
            fputs("Error encoding JSON: \(error)\n", stderr)
        }
    }
}
