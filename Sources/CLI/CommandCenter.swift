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
        print("Selecting \(layout)")

        guard let selectedLayout = KeyboardManager.shared.enabledLayouts.first(where: { $0.localizedName == layout }) else {
            print("not found")
            return
        }
         
        print("found")
        KeyboardManager.shared.selectLayout(withID: selectedLayout.inputSourceID)
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
