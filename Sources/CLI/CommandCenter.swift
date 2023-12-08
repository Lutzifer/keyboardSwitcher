import Foundation

class CommandCenter {
	func printLayout() {
        print(KeyboardManager.shared.currentKeyboardLayout().localizedName)
	}

	func listLayouts() {
		print("Available Layouts:")
        self.printLayouts(layouts: KeyboardManager.shared.keyboardLayouts())
	}

	func listEnabled() {
		print("Enabled Layouts:")
        self.printLayouts(layouts: KeyboardManager.shared.enabledLayouts())
	}

	internal func printLayouts(layouts: [KeyboardSource]) {
		layouts.compactMap { $0.localizedName }
            .sorted { $0 < $1 }
            .forEach { name in
                print("\t\(name)"
            )
		}
	}

	func selectLayout(layout: String) {
		print("Selecting \(layout)")

        let enabledLayouts = KeyboardManager.shared.enabledLayouts()

		var found = false
		
        enabledLayouts.forEach { (keyboardSource: KeyboardSource) in
			if keyboardSource.localizedName == layout {
				print("found")
                KeyboardManager.shared.selectLayout(withID: keyboardSource.inputSourceID)
				found = true
			}
		}

		if !found {
			print("not found")
		}
	}

	func printJSON() {
        let enabledLayouts = KeyboardManager.shared.enabledLayouts()
        let array = enabledLayouts.map {
            return ["title": $0.localizedName, "arg": $0.localizedName]
		}

        let jsonData = try? JSONSerialization.data(withJSONObject: array,
                                                         options: .prettyPrinted)

        if let data = jsonData,
            let jsonString = String(data: data, encoding: String.Encoding.utf8) {
            print(jsonString)
        }
	}
}
