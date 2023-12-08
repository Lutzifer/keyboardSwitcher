import Foundation
import InputMethodKit

class KeyboardManager {
    static let shared = KeyboardManager()

    var keyboardLayouts: [KeyboardSource] {
        sourceList
    }

    var enabledLayouts: [KeyboardSource] {
        sourceList.filter { $0.enabled }
    }

    var currentKeyboardLayout: KeyboardSource {
        KeyboardSource(source: TISCopyCurrentKeyboardInputSource().takeRetainedValue())
    }

    func selectLayout(withID layoutID: String) {
        var sources = keyboardSources(forDictionary: [kTISPropertyInputSourceID as String: layoutID])

        if sources.isEmpty {
            let shortLayoutID = layoutID.components(separatedBy: ".").last!
            sources = keyboardSources(forDictionary: [kTISPropertyLocalizedName as String: shortLayoutID])
        }

        if TISSelectInputSource(sources[0].source) != noErr {
            print("Failed to set the layout \"\(layoutID)\".")
        }
    }

    private var sourceList: [KeyboardSource] {
        keyboardLayoutInputSources + inputModeInputSources
    }
    
    private var keyboardLayoutInputSources: [KeyboardSource] {
        keyboardSources(forDictionary: [kTISPropertyInputSourceType as String: kTISTypeKeyboardLayout as String])
    }
    
    private var inputModeInputSources: [KeyboardSource] {
        keyboardSources(forDictionary: [kTISPropertyInputSourceType as String: kTISTypeKeyboardInputMode as String])
    }

    private func keyboardSources(forDictionary dictionary: [String: Any]) -> [KeyboardSource] {
        guard let sources = TISCreateInputSourceList(dictionary as CFDictionary, false)?.takeRetainedValue() as? [TISInputSource] else {
            return []
        }
        
        return sources.map(KeyboardSource.init)
    }
}
