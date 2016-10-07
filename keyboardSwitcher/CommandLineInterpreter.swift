//
//  CommandLineInterpreter.swift
//  keyboardSwitcher
//
//  Created by Wolfgang Lutz on 25.09.16.
//  Copyright © 2016 Wolfgang Lutz. All rights reserved.
//

class CommandLineInterpreter {
    func interpret(arguments: Array<String>) {
        switch arguments.count {
        case 2:
            let command = arguments[1]
            switch command {
            case CommandLineOption.list.command:
                CommandLineOption.list.run()
            case CommandLineOption.enabled.command:
                CommandLineOption.enabled.run()
            case CommandLineOption.version.command:
                CommandLineOption.version.run()
            case CommandLineOption.get.command:
                CommandLineOption.get.run()
            case CommandLineOption.help.command:
                CommandLineOption.help.run()
            case CommandLineOption.select(layout: nil).command:
                print("Missing arguments for command: \(command)")
                CommandLineOption.help.run()
            default:
                print("Unknown Command: \(command)")
                CommandLineOption.help.run()
            }
        case 3:
            let command = arguments[1]
            let value = arguments[2]
            if command == CommandLineOption.select(layout: nil).command {
                CommandLineOption.select(layout: value).run()
            } else {
                self.interpret(arguments: [arguments[0], arguments[1]])
            }
        default:
            CommandLineOption.help.run()
        }
    }
}
