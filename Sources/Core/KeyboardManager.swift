import Foundation
import InputMethodKit

class KeyboardManager {
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

        if let foundLayout = eligibleSources.first(where: { $0.inputSourceID.components(separatedBy: ".").last == layoutIdentifier }) {
            printToStdErr("FOUND by shortened input source id")
            return foundLayout
        }

        if let foundLayout = eligibleSources.first(where: { $0.localizedName == layoutIdentifier }) {
            printToStdErr("FOUND by localized name")
            return foundLayout
        }

        printToStdErr("No keyboard source found for \"\(layoutIdentifier)\".")
        return nil
    }

    var currentKeyboardLayout: KeyboardSource {
        KeyboardSource(source: TISCopyCurrentKeyboardInputSource().takeRetainedValue())
    }

    func selectLayout(withID layoutID: String) {
        var sources = keyboardSources(forDictionary: [kTISPropertyInputSourceID as String: layoutID], includeAllInstalled: false)

        if sources.isEmpty {
            let shortLayoutID = layoutID.components(separatedBy: ".").last!
            sources = keyboardSources(forDictionary: [kTISPropertyLocalizedName as String: shortLayoutID], includeAllInstalled: false)
        }

        if TISSelectInputSource(sources[0].source) != noErr {
            printToStdErr("Failed to set the layout \"\(layoutID)\".")
        }
    }

    func selectLayout(withSource keyboardSource: KeyboardSource) {
        if TISSelectInputSource(keyboardSource.source) != noErr {
            printToStdErr("Failed to set the layout \"\(keyboardSource.localizedName)\".")
        } else {
            printToStdErr("Successfully set the layout \"\(keyboardSource.localizedName)\".")
        }
    }

    func enableLayout(withSource keyboardSource: KeyboardSource) {
        if TISEnableInputSource(keyboardSource.source) != noErr {
            printToStdErr("Failed to enable the layout \"\(keyboardSource.localizedName)\".")
        } else {
            printToStdErr("Successfully enabled the layout \"\(keyboardSource.localizedName)\".")
        }
    }

    func disableLayout(withSource keyboardSource: KeyboardSource) {
        if TISDisableInputSource(keyboardSource.source) != noErr {
            printToStdErr("Failed to disable the layout \"\(keyboardSource.localizedName)\".")
        } else {
            printToStdErr("Successfully disabled the layout \"\(keyboardSource.localizedName)\".")
        }
    }

    private func sourceList(includeAllInstalled: Bool) -> [KeyboardSource] {
        keyboardLayoutInputSources(includeAllInstalled: includeAllInstalled) + inputModeInputSources(includeAllInstalled: includeAllInstalled)
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

    private func keyboardSources(forDictionary dictionary: [String: Any], includeAllInstalled: Bool) -> [KeyboardSource] {
        guard let sources = TISCreateInputSourceList(
            dictionary as CFDictionary,
            includeAllInstalled
        )?.takeRetainedValue() as? [TISInputSource] else {
            return []
        }

        return sources.map(KeyboardSource.init)
    }
}
