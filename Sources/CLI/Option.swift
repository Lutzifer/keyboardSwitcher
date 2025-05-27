enum CommandLineOption {
    case list
    case enabled
    case version
    case help
    case get
    case select(layout: String?)
    case json
    case enable(layout: String?)
    case disable(layout: String?)

    var command: String {
        switch self {
        case .select:
            "select"
        case .enable:
            "enable"
        case .disable:
            "disable"
        default:
            String(describing: self).lowercased()
        }
        
    }

    var helptext: String {
        return switch self {
        case .list:
            "List the available layouts"
        case .enabled:
            "List enabled layouts"
        case .version:
            "Print the version of KeyboardSwitcher"
        case .help:
            "Print this help"
        case .get:
            "Get the current layout"
        case .select:
            "Set the layout. Arguments: <layout name>"
        case .enable:
            "Enable a layout. Arguments: <layout name>"
        case .disable:
            "Disable a layout. Arguments: <layout name>"
        case .json:
            "List enabled layouts as Alfred-compatible JSON"
        }
    }

    func run() {
        let commandCenter = CommandCenter()

        switch self {
        case .list:
            commandCenter.listLayouts()
        case .enabled:
            commandCenter.listEnabled()
        case .version:
            fputs("Current Version: \(keyboardSwitcherVersion)\n", stderr)
        case .help:
            fputs("A tool to set the KeyboardLayout\n", stderr)
            fputs("Available Commands:\n", stderr)
            CommandLineOption.all.forEach { option in
                fputs("\t\(option.command): \(option.helptext)\n", stderr)
            }
        case .json:
            commandCenter.printJSON()
        case .select(let layout):
            if let layout = layout {
                commandCenter.selectLayout(layout: layout)
            }
        case .enable(let layout):
            if let layout = layout {
                commandCenter.enableLayout(layout: layout)
            }
        case .disable(let layout):
            if let layout = layout {
                commandCenter.disableLayout(layout: layout)
            }
        case .get:
            commandCenter.printLayout()
        }
    }

    static var all: [CommandLineOption] {
        [.list, .enabled, .version, .help, .select(layout: nil), .json, .enable(layout: nil), .disable(layout: nil)]
    }
}
