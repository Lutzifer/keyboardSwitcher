import Foundation
import InputMethodKit

class KeyboardSource {
    let source: TISInputSource

    init(source: TISInputSource) {
        self.source = source
    }

    var localizedName: String {
        getString(forProperty: kTISPropertyLocalizedName)
    }

    var inputSourceID: String {
        getString(forProperty: kTISPropertyInputSourceID)
    }

    var enabled: Bool {
        getBool(forProperty: kTISPropertyInputSourceIsEnabled)
    }

    private func getString(forProperty property: CFString) -> String {
        Unmanaged<CFString>.fromOpaque(TISGetInputSourceProperty(source, property)).takeUnretainedValue() as String
    }

    private func getBool(forProperty property: CFString) -> Bool {
        let enabled = Unmanaged<NSNumber>.fromOpaque(TISGetInputSourceProperty(source, property)).takeUnretainedValue() as NSNumber
        
        return enabled.boolValue
    }
}
