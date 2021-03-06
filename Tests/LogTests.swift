//
// LogTests.swift
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

import XCTest
@testable import Log

class LogTests: XCTestCase {
    
    var logger: Logger!
    
    override func setUp() {
        logger = Logger()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testREADMEExample() {
        let (one, two, three) = ("ONE", "TWO", "THREE")
        let error = URLError.cancelled
        let Log = Logger(formatter: .verbose, theme: nil)
        
        Log.trace("Called!!!")
        Log.debug(["Who is self: ", self])
        Log.info([one, two, three])
        Log.warn([one, two, three], separator: " - ")
        Log.error([error], terminator: "😱😱😱\n")
//        Log.fatal("Fail fast!") // @noreturn
        Thread.sleep(forTimeInterval: 0.01)
    }
    
    func testLevel() {
        XCTAssert(Level.trace < Level.debug, "Level order is wrong. Expecting \(Level.trace) < \(Level.debug) ")
        XCTAssert(Level.debug < Level.info , "Level order is wrong. Expecting \(Level.debug) < \(Level.info ) ")
        XCTAssert(Level.info  < Level.warn , "Level order is wrong. Expecting \(Level.info ) < \(Level.warn ) ")
        XCTAssert(Level.warn  < Level.error, "Level order is wrong. Expecting \(Level.warn ) < \(Level.error) ")
        XCTAssert(Level.error < Level.fatal, "Level order is wrong. Expecting \(Level.error) < \(Level.fatal) ")
    }
    
    func testLog() {
        logger.theme = nil
        logger.formatter = .minimal
        logger.trace("Theme: \(String(describing: logger.theme)). Formatter: \(logger.formatter)")
        logger.debug("A debug log")
        logger.info("A info log")
        logger.warn("A warn log")
        logger.error("A error log")
//        logger.fatal("A fatal log")
        
//        logger.theme = .classic(.level)
        logger.formatter = .concise
        logger.trace("Theme: \(String(describing: logger.theme)). Formatter: \(logger.formatter)")
        logger.debug("A debug log")
        logger.info("A info log")
        logger.warn("A warn log")
        logger.error("A error log")
//        logger.fatal("A fatal log")
        
//        logger.theme = .solarized([.level, .message])
        logger.formatter = .basic
        logger.trace("Theme: \(String(describing: logger.theme)). Formatter: \(logger.formatter)")
        logger.debug("A debug log")
        logger.info("A info log")
        logger.warn("A warn log")
        logger.error("A error log")
//        logger.fatal("A fatal log")
        
//        logger.theme = .flat(.all)
        logger.formatter = .verbose
        logger.trace("Theme: \(String(describing: logger.theme)). Formatter: \(logger.formatter)")
        logger.debug("A debug log")
        logger.info("A info log")
        logger.warn("A warn log")
        logger.error("A error log")
//        logger.fatal("A fatal log")
        
        Thread.sleep(forTimeInterval: 0.01)
    }
}
