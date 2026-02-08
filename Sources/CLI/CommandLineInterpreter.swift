import Foundation

class CommandLineInterpreter {
  private let commandMapping: [String: () -> Void] = [
    CommandLineOption.list.command: CommandLineOption.list.run,
    CommandLineOption.enabled.command: CommandLineOption.enabled.run,
    CommandLineOption.version.command: CommandLineOption.version.run,
    CommandLineOption.get.command: CommandLineOption.get.run,
    CommandLineOption.json.command: CommandLineOption.json.run,
    CommandLineOption.help.command: CommandLineOption.help.run,
  ]

  func interpret(arguments: [String]) {
    switch arguments.count {
    case 2:
      interpretTwoArguments(arguments: arguments)
    case 3:
      interpretThreeArguments(arguments: arguments)
    default:
      CommandLineOption.help.run()
    }
  }

  private func interpretTwoArguments(arguments: [String]) {
    let command = arguments[1]

    guard let commandAction = commandMapping[command] else {
      printToStdErr("Unknown Command: \(command)")
      CommandLineOption.help.run()
      exit(1)
    }

    commandAction()
  }

  private func interpretThreeArguments(arguments: [String]) {
    let command = arguments[1]
    let value = arguments[2]

    if command == CommandLineOption.select(layout: nil).command {
      CommandLineOption.select(layout: value).run()
    } else if command == CommandLineOption.enable(layout: nil).command {
      CommandLineOption.enable(layout: value).run()
    } else if command == CommandLineOption.disable(layout: nil).command {
      CommandLineOption.disable(layout: value).run()
    } else {
      interpretTwoArguments(arguments: arguments)
    }
  }
}
