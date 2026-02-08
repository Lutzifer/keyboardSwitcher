import Foundation
import InputMethodKit

struct KeyboardSource: Encodable {
  enum CodingKeys: String, CodingKey {
    case title
    case arg
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(localizedName, forKey: .title)
    try container.encode(localizedName, forKey: .arg)
  }

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

  var displayName: String {
    "\(localizedName) (\(inputSourceID))"
  }

  private func getString(forProperty property: CFString) -> String {
    Unmanaged<CFString>.fromOpaque(TISGetInputSourceProperty(source, property))
      .takeUnretainedValue() as String
  }

  private func getBool(forProperty property: CFString) -> Bool {
    let enabled =
      Unmanaged<NSNumber>.fromOpaque(TISGetInputSourceProperty(source, property))
      .takeUnretainedValue() as NSNumber

    return enabled.boolValue
  }
}
