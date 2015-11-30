# keyboardSwitcher
List, show and switch OSX Keyboard Layouts from the command line.

A tool to set the current KeyboardLayout

## Available Commands:
- list: list the available layouts
- select "\<layout\>": sets the layout
- get: get the current layout
- version: print the version of KeyboardSwitcher
	 
## Limitations
For the "select" command to successfully run, the keyboard layout needs to be added in the OSX Settings app under Keyboard > Sources.

## Possible usages
I intend to use this in combination with control plane (http://www.controlplaneapp.com) to select the keyboard layout depending on whether my Bluetooth Keyboard is connected (-> US Layout) or not (-> German Layout).

## Installation
```
brew tap lutzifer/homebrew-tap
brew install keyboardSwitcher
```

## Use with Alfred

Simply download the workflow available at https://github.com/Lutzifer/keyboardSwitcher/releases/tag/0.0.4

Use the "eng" and "ger" commands to quickly change the layout or define your own.

## Examples:

keyboardSwitcher list

```
Available Layouts:
  	2-Set Korean
  	3-Set Korean
  	390 Sebulshik
  	Afghan Dari
  	Afghan Pashto
  	Afghan Uzbek
  	Anjal
    (…)
```

keyboardSwitcher select "German"

keyboardSwitcher get

```
German
```

keyboardSwitcher select "U.S."

keyboardSwitcher get

```
U.S.
```
