import Foundation
import InputMethodKit

class CommandCenter {
    func printLayout() {
        print(KeyboardManager.shared.currentKeyboardLayout.localizedName)
    }

    func listLayouts() {
        print("Available Layouts:")
        printLayouts(layouts: KeyboardManager.shared.keyboardLayouts)
    }

    func listEnabled() {
        print("Enabled Layouts:")
        printLayouts(layouts: KeyboardManager.shared.enabledLayouts)
    }

    internal func printLayouts(layouts: [KeyboardSource]) {
        print(
        layouts
            .map { "\t\($0.localizedName)" }
            .sorted()
            .joined(separator: "\n")
        )
    }

    func selectLayout(layout: String) {
        print("Selecting \"\(layout)\"...")
        if let keyboardSource = KeyboardManager.shared.findKeyboardSource(enabledOnly: true, layoutIdentifier:layout) {
            KeyboardManager.shared.selectLayout(withSource: keyboardSource)
        } else {
            print("Unable to reconcile \"\(layout)\" with a KeyboardSource. May need to enable first.")
        }
    }
    
    func enableLayout(layout: String) {
        print("Enabling \"\(layout)\"...")
        if let keyboardSource = KeyboardManager.shared.findKeyboardSource(enabledOnly: false, layoutIdentifier:layout) {
            if keyboardSource.enabled {
                print("\"\(layout)\" is already enabled.")
                return
            }
            KeyboardManager.shared.enableLayout(withSource: keyboardSource)
        } else {
            print("Unable to reconcile \"\(layout)\" with a KeyboardSource.")
        }
    }
    
    func disableLayout(layout: String) {
        print("Disabling \"\(layout)\"...")
        if let keyboardSource = KeyboardManager.shared.findKeyboardSource(enabledOnly: false, layoutIdentifier:layout) {
            if !keyboardSource.enabled {
                print("\"\(layout)\" is already disabled.")
                return
            }
            KeyboardManager.shared.disableLayout(withSource: keyboardSource)
        } else {
            print("Unable to reconcile \"\(layout)\" with a KeyboardSource.")
        }
    }

    func printJSON() {
        do {
            guard let jsonString = String(
                data: try JSONEncoder().encode(KeyboardManager.shared.enabledLayouts),
                encoding: .utf8
            ) else {
                print("Error converting JSON data to string")
                return
            }
            print(jsonString)
        } catch {
            print("Error encoding JSON: \(error)")
        }
    }
}
