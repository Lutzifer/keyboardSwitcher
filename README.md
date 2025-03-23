# keyboardSwitcher

`keyboardSwitcher` is a command-line tool designed for macOS that allows you to list, show, and switch between different keyboard layouts effortlessly.

## Available Commands

- **list:** List all available keyboard layouts.
- **enabled:** List enabled layouts (those configured in System Preferences).
- **select "\<layout\>:** Set the current keyboard layout.
- **get:** Retrieve the currently active keyboard layout.
- **version:** Print the version of `keyboardSwitcher`.
- **enable "\<layout\>:** Enable a layout so it can then be selected.
- **disable "\<layout\>:** Disable a layout so it can no longer be selected.

## Limitations

To successfully execute the `select` command, the desired keyboard layout must first be enabled.
This can be achieved by:
- adding the layout in the macOS Settings app under Keyboard > Sources.

OR

- using the `enable` command

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

### Enable and set a Layout

```bash
enable British-PC

```

Output:
```plaintext
Enabling "British-PC"...
FOUND by shortened input source id
Successfully enabled the layout "British – PC".
```
<br>

```bash
select British-PC

```

Output:
```plaintext
Selecting "British-PC"...
FOUND by shortened input source id
Successfully set the layout "British – PC".
```

> **_NOTE:_**
> Layouts can be referenced in three different ways. This can be convenient as some keyboard layout localised names contain non-ASCII characters such as the en dash (–).
> - Fully qualified input source id e.g. `com.apple.keylayout.British-PC`
> - Shortened input source id e.g. `British-PC`
> - Localised name `"British – PC"`



### Disable a Layout

```bash
disable com.apple.keylayout.British-PC

```
Output:
```plaintext
Disabling "com.apple.keylayout.British-PC"...
FOUND by fully qualified input source id
Successfully disabled the layout "British – PC".
```


Feel free to explore the various commands to manage your keyboard layouts efficiently.

