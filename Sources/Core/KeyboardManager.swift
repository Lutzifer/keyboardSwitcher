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
            fputs("FOUND by fully qualified input source id\n", stderr)
            return foundLayout
        }

        if let foundLayout = eligibleSources.first(where: { $0.inputSourceID.components(separatedBy: ".").last == layoutIdentifier }) {
            fputs("FOUND by shortened input source id\n", stderr)
            return foundLayout
        }

        if let foundLayout = eligibleSources.first(where: { $0.localizedName == layoutIdentifier }) {
            fputs("FOUND by localized name\n", stderr)
            return foundLayout
        }

        fputs("No keyboard source found for \"\(layoutIdentifier)\".\n", stderr)
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
            fputs("Failed to set the layout \"\(layoutID)\".\n", stderr)
        }
    }
    
    func selectLayout(withSource keyboardSource: KeyboardSource) {
        if TISSelectInputSource(keyboardSource.source) != noErr {
            fputs("Failed to set the layout \"\(keyboardSource.localizedName)\".\n", stderr)
        } else {
            fputs("Successfully set the layout \"\(keyboardSource.localizedName)\".\n", stderr)
        }
    }
    
    func enableLayout(withSource keyboardSource: KeyboardSource) {
        if TISEnableInputSource(keyboardSource.source) != noErr {
            fputs("Failed to enable the layout \"\(keyboardSource.localizedName)\".\n", stderr)
        } else {
            fputs("Successfully enabled the layout \"\(keyboardSource.localizedName)\".\n", stderr)
        }
    }
    
    func disableLayout(withSource keyboardSource: KeyboardSource) {
        if TISDisableInputSource(keyboardSource.source) != noErr {
            fputs("Failed to disable the layout \"\(keyboardSource.localizedName)\".\n", stderr)
        } else {
            fputs("Successfully disabled the layout \"\(keyboardSource.localizedName)\".\n", stderr)
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
