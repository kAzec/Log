<p align="center">
  <img src="https://raw.githubusercontent.com/delba/Log/assets/Logo@2x.png" />
</p>

<p align="center">
    <a href="https://img.shields.io/cocoapods/v/Log.svg"><img alt="Platforms" src="https://img.shields.io/badge/platforms-ios%20%7C%20osx%20%7C%20watchos%20%7C%20tvos-lightgrey.svg"/></a>
    <a href="https://github.com/Carthage/Carthage"><img alt="Carthage compatible" src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"/></a>
    <a href="https://img.shields.io/badge/swift-2.2-orange.svg"><img alt="Swift" src="https://img.shields.io/badge/swift-2.2-orange.svg"/></a>
</p>

`Log` is a powerful logging framework that provides built-in themes and formatters, and a nice API to define your owns.

> Get the most out of `Log` by installing [`XcodeColors`](https://github.com/robbiehanson/XcodeColors) and [`KZLinkedConsole`](https://github.com/krzysztofzablocki/KZLinkedConsole)

<p align="center">
    <a href="#usage">Usage</a> • <a href="#installation">Installation</a> • <a href="#license">License</a>
</p>

### Usage

#### The basics

- Use `Log` just as you would use `print`.

```swift
let Log = Logger()
   
Log.trace("Called!!!")
Log.debug(["Who is self: ", self])
Log.info([one, two, three])
Log.warn([one, two, three], separator: " - ")
Log.error([error], terminator: "😱😱😱\n")
Log.fatal("Fail fast!") // @noreturn
```

![](http://i.imgur.com/n1Ucorb.png)

- Disable `Log` by setting `enabled` to `false`:

```swift
Log.enabled = false
```

- Define a minimum level of severity to only print the messages with a greater or equal severity:

```swift
Log.level = .warning
```

> The severity levels are `trace`, `debug`, `info`, `warning`, `error` and `fatal`.

#### Customization

- Create your own `Logger` by changing its `Theme` and/or `Formatter`.

A suggested way of doing it is by extending `Formatters` and `Themes`:

```swift
extension Formatter {
    static func named(name: String) -> Formatter {
        return Formatter("[%@] %@ | %@ [\(name)] - %@", [
            .date(format: "yyyy-MM-dd HH:mm:ss.SSS"),
            .level(equalWidth: true, align: .right),
            .location,
            .message
        ])
    }
}

extension Theme {
    static let tomorrowNight = Theme.new(
        trace:   0xC5C8C6,
        debug:   0x81A2BE,
        info:    0xB5BD68,
        warn:    0xF0C674,
        error:   0xCC6666,
        fatal:   0xFFFFFF
    ).background(
        fatal:   0xCC6666
    ).build()
}
```

Then create a new logger.

```swift
let Log = Logger(formatter: .named("Named"), theme: .tomorrowNight)
```

> See the built-in [formatters](https://github.com/kAzec/Log/blob/master/Sources/Extensions/Formatter+DefaultFormatters.swift) and [themes](https://github.com/kAzec/Log/blob/master/Sources/Extensions/Theme+DefaultThemes.swift) for more examples.

**Tip:** `Logger.format` and `Logger.colors` can be useful to visually debug your logger.

Nothing prevents you from creating as many loggers as you want!

```swift
let basic = Logger(formatter: .concise, theme: nil)
let minimal = Logger(level: .info, formatter: .minimal, theme: .flat)
```

- Turn off the colors by setting the theme to `nil`:

```swift
Log.theme = nil
```

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Log into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "kAzec/Log"
```

## License

Copyright (c) 2015-2016 Damien (http://delba.io) and kAzec

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


