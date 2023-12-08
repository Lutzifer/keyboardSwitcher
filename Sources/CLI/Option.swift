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
        case .select:
            "select"
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
            print("Current Version: \(keyboardSwitcherVersion)")
        case .help:
            print("A tool to set the KeyboardLayout")
            print("Available Commands:")
            CommandLineOption.all.forEach { option in
                print("\t\(option.command): \(option.helptext)")
            }
        case .json:
            commandCenter.printJSON()
        case .select(let layout):
            if let layout = layout {
                commandCenter.selectLayout(layout: layout)
            }
        case .get:
            commandCenter.printLayout()
        }
    }

    static var all: [CommandLineOption] {
        [.list, .enabled, .version, .help, .select(layout: nil), .json]
    }
}
