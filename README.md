# keyboardSwitcher

`keyboardSwitcher` is a command-line tool designed for macOS that allows you to list, show, and switch between different keyboard layouts effortlessly.

## Available Commands

- **list:** List all available keyboard layouts.
- **enabled:** List enabled layouts (those configured in System Preferences).
- **select "\<layout\>:** Set the current keyboard layout.
- **get:** Retrieve the currently active keyboard layout.
- **version:** Print the version of `keyboardSwitcher`.

## Limitations

To successfully execute the "select" command, the desired keyboard layout must be added in the macOS Settings app under Keyboard > Sources.

## Possible Usages

Many users find `keyboardSwitcher` beneficial in conjunction with third-party tools such as KeyboardMaestro or via Alfred workflows. For example, you can dynamically switch the keyboard layout based on the connection status of a Bluetooth keyboard or use an Alfred workflow for quick layout changes.

## Installation

### Using [Homebrew](http://brew.sh/):

```bash
brew install lutzifer/homebrew-tap/keyboardSwitcher
```

### Using [Mint](https://github.com/yonaskolb/mint):

```bash
mint install lutzifer/keyboardSwitcher
```

## Use with Alfred

Download the Alfred workflow from the [releases page](https://github.com/Lutzifer/keyboardSwitcher/releases/tag/0.0.4) and use commands like "eng" and "ger" to swiftly change the keyboard layout.

## Examples

### List Available Layouts

```bash
keyboardSwitcher list
```

Output:

```plaintext
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

### List Enabled Layouts

```bash
keyboardSwitcher enabled
```

Output:

```plaintext
Enabled Layouts:
        Colemak
        Turkish - QWERTY PC
        U.S.
```

### Set and Get Current Layout

```bash
keyboardSwitcher select "German"
keyboardSwitcher get
```

Output:

```plaintext
German
```

```bash
keyboardSwitcher select "U.S."
keyboardSwitcher get
```

Output:

```plaintext
U.S.
```

Feel free to explore the various commands to manage your keyboard layouts efficiently.