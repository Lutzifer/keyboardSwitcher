import Foundation
import InputMethodKit

class KeyboardManager {
    static let shared = KeyboardManager()

    func keyboardLayouts() -> [KeyboardSource] {
        return sourceList()
    }

    func enabledLayouts() -> [KeyboardSource] {
        return sourceList().filter { $0.enabled }
    }

    func currentKeyboardLayout() -> KeyboardSource {
        return KeyboardSource(source: TISCopyCurrentKeyboardInputSource().takeRetainedValue())
    }

    func selectLayout(withID layoutID: String) {
        var sources = keyboardSources(forDictionary: [kTISPropertyInputSourceID as String: layoutID])

        if sources.isEmpty {
            let shortLayoutID = layoutID.components(separatedBy: ".").last!
            sources = keyboardSources(forDictionary: [kTISPropertyLocalizedName as String: shortLayoutID])
        }

        let status = TISSelectInputSource(sources[0].source)

        if status != noErr {
            print("Failed to set the layout \"\(layoutID)\".")
        }
    }

    // MARK: Private

    private func sourceList() -> [KeyboardSource] {
        let keyboardLayoutInputSources = keyboardSources(forDictionary: [kTISPropertyInputSourceType as String: kTISTypeKeyboardLayout as String])
        let inputModeInputSources = keyboardSources(forDictionary: [kTISPropertyInputSourceType as String: kTISTypeKeyboardInputMode as String])

        return keyboardLayoutInputSources + inputModeInputSources
    }

    private func keyboardSources(forDictionary dictionary: [String: Any]) -> [KeyboardSource] {
        var sources = [KeyboardSource]()
        if let sourceList = TISCreateInputSourceList(dictionary as CFDictionary, false)?.takeRetainedValue() as? [TISInputSource] {
            for sourceObject in sourceList {
                sources.append(KeyboardSource(source: sourceObject))
            }
        }
        return sources
    }
}
