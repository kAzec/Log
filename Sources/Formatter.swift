//
// Formatter.swift
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

public final class Formatter: CustomStringConvertible {
    public enum LevelFormatterOption {
        case none
        case equalWidthByPrependingSpace
        case equalWidthByAppendingSpace
        case equalWidthByTruncatingTail(width: Int)
    }
    
    public enum Component {
        case date(format: String)
        case level(LevelFormatterOption)
        case file(fullPath: Bool, withExtension: Bool)
        case line
        case function
        case location
        case message
        case custom(content: () -> String)
    }
    
    /// The formatter format.
    private var format: String
    
    /// The formatter components.
    private var components: [Component]
    
    /// The date formatter.
    private let dateFormatter = DateFormatter()
    
    /// The formatter textual representation.
    public var description: String {
        return String(format: format, arguments: components.map { (component: Component) -> CVarArg in
            return "#" + String(describing: component)
        })
    }
    
    /**
     Creates and returns a new formatter with the specified format and components.
     
     - parameter format:     The formatter format.
     - parameter components: The formatter components.
     
     - returns: A newly created formatter.
     */
    public init(_ format: String, _ components: [Component]) {
        self.format = format
        self.components = components
    }
    
    /**
     Formats a string with the formatter format and components.
     
     - parameter level:      The severity level.
     - parameter items:      The items to format.
     - parameter separator:  The separator between the items.
     - parameter file:       The log file path.
     - parameter line:       The log line number.
     - parameter function:   The log function.
     - parameter date:       The log date.
     
     - returns: The formatted string.
     */
    func format(level: Level, items: [String], separator: String, file: String, line: Int, function: String, date: Date, theme: Theme? = nil) -> String {
        
        func colorize(as option: Theme.ComponentOptions, _ text: String) -> String {
            return theme?.colorizeText(text, level: level, option: option) ?? text
        }

        let arguments = components.map { component -> CVarArg in
            switch component {
            case .date(let format):
                return colorize(as: .date, formatDate(date, format: format))
            case .level(let option):
                return colorize(as: .level, formatLevel(level, option: option))
            case .file(let fullPath, let withExtension):
                return colorize(as: .file, formatFile(file, fullPath: fullPath, withExtension: withExtension))
            case .function:
                return colorize(as: .function, formatFunction(function))
            case .line:
                return colorize(as: .line, String(line))
            case .location:
                return colorize(as: .location, formatLocation(file: file, line: line))
            case .message:
                return colorize(as: .message, formatMessage(items, separator: separator))
            case .custom(content: let content):
                return colorize(as: .custom, content())
            }
        }
        
        return String(format: format, arguments: arguments)
    }

    /**
     Formats a date component with the specified date format.
     
     - parameter date:       The date.
     - parameter dateFormat: The date format.
     
     - returns: The formatted date component.
     */
    func formatDate(_ date: Date, format: String) -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    /**
     Formats a level component with specified format option.
     
     - parameter level:  The level component.
     - parameter option: The format option.
     
     - returns: The formatted level component.
     */
    func formatLevel(_ level: Level, option: LevelFormatterOption) -> String {
        let text = level.description
        let space = " "
        
        switch option {
        case .equalWidthByAppendingSpace:
            return text.characters.count == 4 ? text + space : text
        case .equalWidthByPrependingSpace:
            return text.characters.count == 4 ? space + text : text
        case .equalWidthByTruncatingTail(width: let width):
            return text.characters.count > width ? text.substring(to: text.characters.index(text.startIndex, offsetBy: width)) : text
        case .none:
            return text
        }
    }
    
    /**
     Formats a file component with the specified parameters.
     
     - parameter file:          The file path.
     - parameter fullPath:      Whether the full path should be included.
     - parameter withExtension: Whether the file extension should be included.
     
     - returns: The formatted file component.
     */
    func formatFile(_ file: String, fullPath: Bool, withExtension: Bool) -> String {
        var file = file
        
        if !fullPath      { file = (file as NSString).lastPathComponent }
        if !withExtension { file = (file as NSString).deletingPathExtension }
        
        return file
    }
    
    /**
     Formats a function componnet
     
     - parameter function: The function.
     
     - returns: The formatted function component.
     */
    func formatFunction(_ function: String) -> String {
        if !function.hasSuffix(")") {
            // Add missing parameters indicators to distinguish function with others.
            return function + "(...)"
        } else {
            return function
        }
    }
    
    /**
     Formats a location component with a specified file path and line number.
     
     - parameter file: The file path.
     - parameter line: The line number.
     
     - returns: The formatted location component.
     */
    func formatLocation(file: String, line: Int) -> String {
        return [
            formatFile(file, fullPath: false, withExtension: true),
            String(line)
        ].joined(separator: ":")
    }
    
    /**
     Formats a message component with specified items and seperator.
     
     - parameter items:     The items in the message.
     - parameter seperator: The seperator to join the items.
     
     - returns: The formatted message component.
     */
    func formatMessage(_ items: [String], separator: String) -> String {
        return items.joined(separator: separator)
    }
}
