import Foundation
import InputMethodKit

class CommandCenter {
  func printLayout() {
    print(KeyboardManager.shared.currentKeyboardLayout.localizedName)
  }

  func listLayouts() {
    printToStdErr("Available Layouts:")
    printLayouts(layouts: KeyboardManager.shared.keyboardLayouts)
  }

  func listEnabled() {
    printToStdErr("Enabled Layouts:")
    printLayouts(layouts: KeyboardManager.shared.enabledLayouts)
  }

  func printLayouts(layouts: [KeyboardSource]) {
    print(
      layouts
        .map { "\t\($0.localizedName)" }
        .sorted()
        .joined(separator: "\n")
    )
  }

  func selectLayout(layout: String) {
    printToStdErr("Selecting \"\(layout)\"...")
    if let keyboardSource = KeyboardManager.shared.findKeyboardSource(
      enabledOnly: true, layoutIdentifier: layout)
    {
      KeyboardManager.shared.selectLayout(withSource: keyboardSource)
    } else {
      printToStdErr(
        "Unable to reconcile \"\(layout)\" with a KeyboardSource. May need to enable first.")
      exit(1)
    }
  }

  func enableLayout(layout: String) {
    printToStdErr("Enabling \"\(layout)\"...")

    guard
      let keyboardSource = KeyboardManager.shared.findKeyboardSource(
        enabledOnly: false, layoutIdentifier: layout)
    else {
      printToStdErr("Unable to reconcile \"\(layout)\" with a KeyboardSource.")
      exit(1)
    }

    if keyboardSource.enabled {
      printToStdErr("\"\(layout)\" is already enabled.")
      return
    }

    KeyboardManager.shared.enableLayout(withSource: keyboardSource)
  }

  func disableLayout(layout: String) {
    printToStdErr("Disabling \"\(layout)\"...")

    guard
      let keyboardSource = KeyboardManager.shared.findKeyboardSource(
        enabledOnly: false, layoutIdentifier: layout)
    else {
      printToStdErr("Unable to reconcile \"\(layout)\" with a KeyboardSource.")
      exit(1)
    }

    if !keyboardSource.enabled {
      printToStdErr("\"\(layout)\" is already disabled.")
      return
    }

    KeyboardManager.shared.disableLayout(withSource: keyboardSource)
  }

  func printJSON() {
    do {
      guard
        let jsonString = try String(
          data: JSONEncoder().encode(KeyboardManager.shared.enabledLayouts),
          encoding: .utf8
        )
      else {
        printToStdErr("Error converting JSON data to string")
        exit(1)
      }

      print(jsonString)
    } catch {
      printToStdErr("Error encoding JSON: \(error)")
      exit(1)
    }
  }
}
