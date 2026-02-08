import Foundation
import InputMethodKit

final class KeyboardManager: Sendable {
  static let shared = KeyboardManager()

  var keyboardLayouts: [KeyboardSource] {
    sourceList(includeAllInstalled: true)
  }

  var enabledLayouts: [KeyboardSource] {
    sourceList(includeAllInstalled: false).filter { $0.enabled }
  }

  func findKeyboardSource(enabledOnly: Bool, layoutIdentifier: String) -> KeyboardSource? {
    let eligibleSources: [KeyboardSource] = enabledOnly ? enabledLayouts : keyboardLayouts

    if let foundLayout = eligibleSources.first(where: { $0.inputSourceID == layoutIdentifier }) {
      printToStdErr("FOUND by fully qualified input source id")
      return foundLayout
    }

    if let foundLayout = eligibleSources.first(where: {
      $0.inputSourceID.components(separatedBy: ".").last == layoutIdentifier
    }) {
      printToStdErr("FOUND by shortened input source id")

      return foundLayout
    }

    if let foundLayout = eligibleSources.first(where: { $0.localizedName == layoutIdentifier }) {
      printToStdErr("FOUND by localized name")

      return foundLayout
    }

    if let foundLayout = eligibleSources.first(where: { $0.displayName.hasPrefix(layoutIdentifier) }
    ) {
      printToStdErr("FOUND by prefix of displayed name")

      return foundLayout
    }

    printToStdErr("No keyboard source found for \"\(layoutIdentifier)\".")
    return nil
  }

  var currentKeyboardLayout: KeyboardSource {
    KeyboardSource(source: TISCopyCurrentKeyboardInputSource().takeRetainedValue())
  }

  func selectLayout(withID layoutID: String) {
    var sources = keyboardSources(
      forDictionary: [kTISPropertyInputSourceID as String: layoutID], includeAllInstalled: false)

    if sources.isEmpty {
      let shortLayoutID = layoutID.components(separatedBy: ".").last!
      sources = keyboardSources(
        forDictionary: [kTISPropertyLocalizedName as String: shortLayoutID],
        includeAllInstalled: false)
    }

    if TISSelectInputSource(sources[0].source) != noErr {
      printToStdErr("Failed to set the layout \"\(layoutID)\".")
    }
  }

  func selectLayout(withSource keyboardSource: KeyboardSource) {
    if TISSelectInputSource(keyboardSource.source) != noErr {
      printToStdErr("Failed to set the layout \"\(keyboardSource.displayName)\".")
    } else {
      printToStdErr("Successfully set the layout \"\(keyboardSource.displayName)\".")
    }
  }

  func enableLayout(withSource keyboardSource: KeyboardSource) {
    if TISEnableInputSource(keyboardSource.source) != noErr {
      printToStdErr("Failed to enable the layout \"\(keyboardSource.displayName)\".")
    } else {
      printToStdErr("Successfully enabled the layout \"\(keyboardSource.displayName)\".")
    }
  }

  func disableLayout(withSource keyboardSource: KeyboardSource) {
    if TISDisableInputSource(keyboardSource.source) != noErr {
      printToStdErr("Failed to disable the layout \"\(keyboardSource.displayName)\".")
    } else {
      printToStdErr("Successfully disabled the layout \"\(keyboardSource.displayName)\".")
    }
  }

  private func sourceList(includeAllInstalled: Bool) -> [KeyboardSource] {
    keyboardLayoutInputSources(includeAllInstalled: includeAllInstalled)
      + inputModeInputSources(includeAllInstalled: includeAllInstalled)
  }

  private func keyboardLayoutInputSources(includeAllInstalled: Bool) -> [KeyboardSource] {
    keyboardSources(
      forDictionary: [kTISPropertyInputSourceType as String: kTISTypeKeyboardLayout as String],
      includeAllInstalled: includeAllInstalled
    )
  }

  private func inputModeInputSources(includeAllInstalled: Bool) -> [KeyboardSource] {
    keyboardSources(
      forDictionary: [kTISPropertyInputSourceType as String: kTISTypeKeyboardInputMode as String],
      includeAllInstalled: includeAllInstalled
    )
  }

  private func keyboardSources(forDictionary dictionary: [String: Any], includeAllInstalled: Bool)
    -> [KeyboardSource]
  {
    guard
      let sources = TISCreateInputSourceList(
        dictionary as CFDictionary,
        includeAllInstalled
      )?.takeRetainedValue() as? [TISInputSource]
    else {
      return []
    }

    return sources.map(KeyboardSource.init)
  }
}
