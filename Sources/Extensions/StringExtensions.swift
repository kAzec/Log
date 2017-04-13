//
// Utilities.swift
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

extension String {
    
    /**
     Returns a string colored with the specified foreground color.
     
     - parameter color: The string representation of the foreground color.
     
     - returns: A string colored with the specified foreground color.
     */
    func withForegroundColor(_ color: String) -> String {
        return "\u{001b}[fg\(color);\(self)\u{001b}[fg;"
    }
    
    /**
     Returns a string colored with the specified background color.
     
     - parameter color: The string representation of the background color.
     
     - returns: A string colored with the specified background color.
     */
    func withBackgroundColor(_ color: String) -> String {
        return "\u{001b}[bg\(color);\(self)\u{001b}[bg;"
    }
    
    func withColor(foreground: String?, background: String?) -> String {
        switch (foreground, background) {
        case (.some(let foreground), .some(let background)):
            return "\u{001b}[fg\(foreground);\u{001b}[bg\(background);\(self)\u{001b}[;"
        case (.some(let foreground), .none):
            return withForegroundColor(foreground)
        case (.none, .some(let background)):
            return withBackgroundColor(background)
        default:
            return self
        }
    }
}
