//
//  Option.swift
//  keyboardSwitcher
//
//  Created by Wolfgang Lutz on 07.10.16.
//  Copyright © 2016 number42. All rights reserved.
//

enum CommandLineOption {
	case list
	case enabled
	case version
	case help
	case get
	case select(layout: String?)
	case json

	var command: String {
		switch self {
		case .list:
			return "list"
		case .enabled:
			return "enabled"
		case .version:
			return "version"
		case .help:
			return "help"
		case .get:
			return "get"
		case .select:
			return "select"
		case .json:
			return "json"
		}
	}

	var helptext: String {
		switch self {
		case .list:
			return "list the available layouts"
		case .enabled:
			return "list enabled layouts"
		case .version:
			return "print the version of KeyboardSwitcher"
		case .help:
			return "prints this help"
		case .get:
			return "get the current layout"
		case .select:
			return "sets the layout. Arguments: <layout name>"
		case .json:
			return "list enabled layouts as alfred compatible json"
		}
	}

	func run() {
		switch self {
		case .list:
			CommandCenter().listLayouts()
		case .enabled:
			CommandCenter().listEnabled()
		case .version:
			print("Current Version: \(keyboardSwitcherVersion)")
		case .help:
			print("A Tool to set the KeyboardLayout")
			print("Available Commands:")
			CommandLineOption.allCommandLineOptions().forEach { option in
				print("\t\(option.command): \(option.helptext)")
			}
		case .json:
			CommandCenter().printJSON()
		case .select(let layout):
			if let layout = layout {
				CommandCenter().selectLayout(layout: layout)
			}
		case .get:
			CommandCenter().printLayout()
		}
	}

	static func allCommandLineOptions() -> [CommandLineOption] {
		return [CommandLineOption.list,
			CommandLineOption.enabled,
			CommandLineOption.version,
			CommandLineOption.help,
			CommandLineOption.select(layout: nil),
			CommandLineOption.json]
	}
}
