import Foundation

func printToStdErr(_ message: String) {
  fputs("\(message)\n", stderr)
}

CommandLineInterpreter()
  .interpret(
    arguments: CommandLine.arguments
  )
