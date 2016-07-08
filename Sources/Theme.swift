//
// Theme.swift
//
// Copyright (c) 2015-2016 Damien (http://delba.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

public final class Theme: CustomStringConvertible {
    typealias ColorDict = [Level: (foreground: String?, background: String?)]

    public struct ComponentOptions: OptionSetType{
        public let rawValue : Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        static let date     = ComponentOptions(rawValue: 1 << 0)
        static let level    = ComponentOptions(rawValue: 1 << 1)
        static let file     = ComponentOptions(rawValue: 1 << 2)
        static let line     = ComponentOptions(rawValue: 1 << 3)
        static let function = ComponentOptions(rawValue: 1 << 4)
        static let location = ComponentOptions(rawValue: 1 << 5)
        static let message  = ComponentOptions(rawValue: 1 << 6)
        
        static let all      = ComponentOptions([date, level, file, line, function, location, message])
    }
    
    public final class Builder {
        /// The colors of the theme.
        private(set) var colors: ColorDict
        
        /// The colorize options of the theme.
        private(set) var options: ComponentOptions
        
        init(colors: ColorDict, options: ComponentOptions) {
            self.colors = colors
            self.options = options
        }
        
        public func build() -> Theme {
            return Theme(builder: self)
        }
    }
    
    /// The theme colors.
    private let colors: ColorDict
    
    /// The theme colorize options.
    private let options: ComponentOptions
    
    /// The theme textual representation.
    public var description: String {
        return colors.keys.map{
            let foreground = self.colors[$0]!.foreground
            let background = self.colors[$0]!.background
            return $0.description.withColor(foreground: foreground, background: background)
        }.joinWithSeparator(" ")
    }
    
    public init(builder: Theme.Builder) {
        self.colors = builder.colors
        self.options = builder.options
    }
    
    func colorizeText(text: String, level: Level, option: ComponentOptions) -> String {
        if options.contains(option) {
            return text.withColor(foreground: colors[level]!.foreground, background: colors[level]!.background)
        } else {
            return text
        }
    }
}

// MARK: - Theme creation
public extension Theme {
    /**
     Create and returns an empty theme builder. Call foreground(:), background(:), components(:) to specify colors and options.
     
     - returns: An empty theme.
     */
    class func new() -> Builder {
        let none: (String?, String?) = (nil, nil)
        return Builder(
            colors: [ .trace: none, .debug: none, .info:  none, .warn:  none, .error: none, .fatal: none ],
            options: .level
        )
    }
    
    /**
     Creates and returns a theme builder with the specified foreground colors. Call background(:) or componenets(:) to specify other parameters or build the theme by calling `build()`.
     
     - parameter trace:   The color for the trace level.
     - parameter debug:   The color for the debug level.
     - parameter info:    The color for the info level.
     - parameter warn:    The color for the warn level.
     - parameter error:   The color for the error level.
     - parameter fatal:   The color for the fatal level.
     
     - returns: A theme builder with the specified foreground colors.
     */
    class func new(trace trace: UInt32, debug: UInt32, info: UInt32, warn: UInt32, error: UInt32, fatal: UInt32) -> Builder {
        return Builder(
            colors: [
                .trace: (colorStringFromHex(trace), nil),
                .debug: (colorStringFromHex(debug), nil),
                .info:  (colorStringFromHex(info ), nil),
                .warn:  (colorStringFromHex(warn ), nil),
                .error: (colorStringFromHex(error), nil),
                .fatal: (colorStringFromHex(fatal), nil)
            ],
            options: .level
        )
    }
}

public extension Theme.Builder {
    /**
     Specify the foreground colors.
     
     - parameter trace: The foreground color for the trace level.
     - parameter debug: The foreground color for the debug level.
     - parameter info:  The foreground color for the info level.
     - parameter warn:  The foreground color for the warn level.
     - parameter error: The foreground color for the error level.
     - parameter fatal: The foreground color for the fatal level.
     
     - returns: A theme builder  with the specified foreground colors.
     */
    func foreground(trace trace: UInt32? = nil, debug: UInt32? = nil, info: UInt32? = nil, warn: UInt32? = nil, error: UInt32? = nil, fatal: UInt32? = nil) -> Theme.Builder {
        if let trace = trace { self.colors[.trace]!.foreground = colorStringFromHex(trace) }
        if let debug = debug { self.colors[.debug]!.foreground = colorStringFromHex(debug) }
        if let info  = info  { self.colors[.info ]!.foreground = colorStringFromHex(info ) }
        if let warn  = warn  { self.colors[.warn ]!.foreground = colorStringFromHex(warn ) }
        if let error = error { self.colors[.error]!.foreground = colorStringFromHex(error) }
        if let fatal = fatal { self.colors[.fatal]!.foreground = colorStringFromHex(fatal) }
        
        return self
    }
    
    /**
     Specify the background colors.
     
     - parameter trace: The background color for the trace level.
     - parameter debug: The background color for the debug level.
     - parameter info:  The background color for the info level.
     - parameter warn:  The background color for the warn level.
     - parameter error: The background color for the error level.
     - parameter fatal: The background color for the fatal level.
     
     - returns: A theme builder  with the specified background colors.
     */
    func background(trace trace: UInt32? = nil, debug: UInt32? = nil, info: UInt32? = nil, warn: UInt32? = nil, error: UInt32? = nil, fatal: UInt32? = nil) -> Theme.Builder {
        if let trace = trace { self.colors[.trace]!.background = colorStringFromHex(trace) }
        if let debug = debug { self.colors[.debug]!.background = colorStringFromHex(debug) }
        if let info  = info  { self.colors[.info ]!.background = colorStringFromHex(info ) }
        if let warn  = warn  { self.colors[.warn ]!.background = colorStringFromHex(warn ) }
        if let error = error { self.colors[.error]!.background = colorStringFromHex(error) }
        if let fatal = fatal { self.colors[.fatal]!.background = colorStringFromHex(fatal) }
        
        return self
    }
    
    /**
     Specify which components should be colorized. The default option is `.level`.
     
     - parameter options: The component options which should be colorized.
     
     - returns: A theme builder with the specified components options.
     */
    func components(options: Theme.ComponentOptions) -> Theme.Builder {
        self.options = options
        
        return self
    }
}

// MARK: - Helper functions

/**
 Returns a string representation of the hex color.
 
 - parameter hex: The hex color.
 
 - returns: A string representation of the hex color.
 */
private func colorStringFromHex(hex: UInt32) -> String {
    let r = (hex & 0xFF0000) >> 16
    let g = (hex & 0x00FF00) >> 8
    let b = (hex & 0x0000FF)
    
    return [r, g, b].map({ String($0) }).joinWithSeparator(",")
}