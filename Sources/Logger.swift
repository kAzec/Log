//
// Logger.swift
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

import Foundation

public class Logger {
    /// The logger state.
    public var enabled = true
    
    /// The minimum level of severity.
    public var level: Level
    
    /// The logger formatter.
    public var formatter: Formatter
    
    /// The logger theme.
    public var theme: Theme?
    
    /// The logger format.
    public var format: String {
        return formatter.description
    }
    
    /// The queue used for logging.
    private lazy var queue = dispatch_queue_create("delba.log", DISPATCH_QUEUE_SERIAL)
    
    /**
     Creates and returns a new logger.
     
     - parameter level:     The minimum level of severity.
     - parameter formatter: The formatter.
     - parameter theme:     The theme.
     
     - returns: A newly created logger.
     */
    public init(level: Level = .trace, formatter: Formatter = .basic, theme: Theme? = .solarized) {
        self.formatter = formatter
        self.theme = theme
        self.level = level
    }
    
    typealias LogEntry = (items: [String], separator: String, terminator: String, file: String, line: Int, function: String) -> Void
    private func log(level: Level) -> LogEntry? {
        guard enabled && level >= self.level else {
            return nil
        }
        
        return { items, separator, terminator, file, line, function in
            let date = NSDate()
            
            let result = self.formatter.format(
                level: level,
                items: items,
                separator: separator,
                file: file,
                line: line,
                function: function,
                date: date,
                theme: self.theme
            )
            
            dispatch_async(self.queue) {
                print(result, separator: "", terminator: terminator)
            }
        }
    }
}

// MAKR: - Log functions
public extension Logger {
    /**
     Logs a message with a trace severity level.
     
     - parameter message:    The message to log.
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     */
    public func trace(@autoclosure message: Void -> String, terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function) {
        log(.trace)?(items: [message()], separator: "", terminator: terminator, file: file, line: line, function: function)
    }
    
    /**
     Logs items with a trace severity level.
     
     - parameter items:      The items to log.
     - parameter separator:  The separator between the items.
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     */
    public func trace(@autoclosure items: Void -> [Any], separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function) {
        log(.trace)?(items: items().map{ String($0) }, separator: "", terminator: terminator, file: file, line: line, function: function)
    }
    
    /**
     Logs closure result with a trace severity level. The closure will be evaluated only when the logger's level is `.trace`. Return `nil` to prevent the result from being logged.
     
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     - parameter closure:    The closure to evaluate thereafter the result(if any) will be logged.
     */
    public func trace(terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function, @noescape closure: Void -> String?) {
        if let entry = log(.trace), let result = closure() {
            entry(items: [result], separator: "", terminator: "\n", file: file, line: line, function: function)
        }
    }
    
    /**
     Logs a message with a debug severity level.
     
     - parameter message:    The message to log.
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     */
    public func debug(@autoclosure message: Void -> String, terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function) {
        log(.debug)?(items: [message()], separator: "", terminator: terminator, file: file, line: line, function: function)
    }
    
    /**
     Logs items with a debug severity level.
     
     - parameter items:      The items to log.
     - parameter separator:  The separator between the items.
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     */
    public func debug(@autoclosure items: Void -> [Any], separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function) {
        log(.debug)?(items: items().map{ String($0) }, separator: "", terminator: terminator, file: file, line: line, function: function)
    }
    
    /**
     Logs closure result with a debug severity level. The closure will be evaluated only when the logger's level is `.debug` or lower. Return `nil` to prevent the result from being logged.
     
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     - parameter closure:    The closure to evaluate thereafter the result(if any) will be logged.
     */
    public func debug(terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function, @noescape closure: Void -> String?) {
        if let entry = log(.debug), let result = closure() {
            entry(items: [result], separator: "", terminator: "\n", file: file, line: line, function: function)
        }
    }
    
    /**
     Logs a message with a info severity level.
     
     - parameter message:    The message to log.
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     */
    public func info(@autoclosure message: Void -> String, terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function) {
        log(.info)?(items: [message()], separator: "", terminator: terminator, file: file, line: line, function: function)
    }
    
    /**
     Logs items with a info severity level.
     
     - parameter items:      The items to log.
     - parameter separator:  The separator between the items.
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     */
    public func info(@autoclosure items: Void -> [Any], separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function) {
        log(.info)?(items: items().map{ String($0) }, separator: "", terminator: terminator, file: file, line: line, function: function)
    }
    
    /**
     Logs closure result with a info severity level. The closure will be evaluated only when the logger's level is `.info` or lower. Return `nil` to prevent the result from being logged.
     
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     - parameter closure:    The closure to evaluate thereafter the result(if any) will be logged.
     */
    public func info(terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function, @noescape closure: Void -> String?) {
        if let entry = log(.info), let result = closure() {
            entry(items: [result], separator: "", terminator: "\n", file: file, line: line, function: function)
        }
    }
    
    /**
     Logs a message with a warn severity level.
     
     - parameter message:    The message to log.
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     */
    public func warn(@autoclosure message: Void -> String, terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function) {
        log(.warn)?(items: [message()], separator: "", terminator: terminator, file: file, line: line, function: function)
    }
    
    /**
     Logs items with a warn severity level.
     
     - parameter items:      The items to log.
     - parameter separator:  The separator between the items.
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     */
    public func warn(@autoclosure items: Void -> [Any], separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function) {
        log(.warn)?(items: items().map{ String($0) }, separator: "", terminator: terminator, file: file, line: line, function: function)
    }
    
    /**
     Logs closure result with a warn severity level. The closure will be evaluated only when the logger's level is `.warn` or lower. Return `nil` to prevent the result from being logged.
     
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     - parameter closure:    The closure to evaluate thereafter the result(if any) will be logged.
     */
    public func warn(terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function, @noescape closure: Void -> String?) {
        if let entry = log(.warn), let result = closure() {
            entry(items: [result], separator: "", terminator: "\n", file: file, line: line, function: function)
        }
    }
    
    /**
     Logs a message with a error severity level.
     
     - parameter message:    The message to log.
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     */
    public func error(@autoclosure message: Void -> String, terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function) {
        log(.error)?(items: [message()], separator: "", terminator: terminator, file: file, line: line, function: function)
    }
    
    /**
     Logs items with a error severity level.
     
     - parameter items:      The items to log.
     - parameter separator:  The separator between the items.
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     */
    public func error(@autoclosure items: Void -> [Any], separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function) {
        log(.error)?(items: items().map{ String($0) }, separator: "", terminator: terminator, file: file, line: line, function: function)
    }
    
    /**
     Logs closure result with a error severity level. The closure will be evaluated only when the logger's level is `.error` or lower. Return `nil` to prevent the result from being logged.
     
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     - parameter closure:    The closure to evaluate thereafter the result(if any) will be logged.
     */
    public func error(terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function, @noescape closure: Void -> String?) {
        if let entry = log(.error), let result = closure() {
            entry(items: [result], separator: "", terminator: "\n", file: file, line: line, function: function)
        }
    }
    
    /**
     Logs a message with a fatal severity level then terminate the app.
     
     - parameter message:    The message to log.
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     */
    @noreturn
    public func fatal(@autoclosure message: Void -> String, terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function) {
        log(.fatal)?(items: [message()], separator: "", terminator: terminator, file: file, line: line, function: function)
        exit(EXIT_FAILURE)
    }
    
    /**
     Logs items with a fatal severity level then terminate the app.
     
     - parameter items:      The items to log.
     - parameter separator:  The separator between the items.
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     */
    @noreturn
    public func fatal(@autoclosure items: Void -> [Any], separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function) {
        log(.fatal)?(items: items().map{ String($0) }, separator: "", terminator: terminator, file: file, line: line, function: function)
        exit(EXIT_FAILURE)
    }
    
    /**
     Logs closure result with a fatal severity level. Return `nil` to prevent the result from being logged.
     
     - parameter terminator: The terminator of the log message.
     - parameter file:       The file in which the log happens.
     - parameter line:       The line at which the log happens.
     - parameter function:   The function in which the log happens.
     - parameter closure:    The closure to evaluate thereafter the result(if any) will be logged.
     */
    @noreturn
    public func fatal(terminator: String = "\n", file: String = #file, line: Int = #line, function: String = #function, @noescape closure: Void -> String?) {
        if let result = closure() {
            log(.fatal)!(items: [result], separator: "", terminator: "\n", file: file, line: line, function: function)
        }
        exit(EXIT_FAILURE)
    }
}