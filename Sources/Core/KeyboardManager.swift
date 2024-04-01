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
            print("Failed to set the layout \"\(layoutID)\".")
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
