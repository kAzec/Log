//
// Theme+Themes.swift
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

public extension Theme {
    
    static func classic(_ components: ComponentOptions = .level) -> Theme {
        return Theme.new(
        ).foreground(
            trace:   0x808080,
            debug:   0x00FF00,
            info:    0x0000FF,
            warn:    0xFFFF00,
            error:   0xFF0000,
            fatal:   0xFFFFFF
        ).background(
            fatal:   0xFF0000
        ).components(
            components
        ).build()
    }
    
    static func solarized(_ components: ComponentOptions = .level) -> Theme {
        return Theme.new(
        ).foreground(
            trace:   0x93A1A2,
            debug:   0x2AA198,
            info:    0x268BD2,
            warn:    0xB58900,
            error:   0xDC322F,
            fatal:   0xFDF6E3
        ).background(
            fatal:   0xDC322F
        ).components(
            components
        ).build()
    }
    
    static func flat(_ components: ComponentOptions = .level) -> Theme {
        return Theme.new(
        ).foreground(
            trace:   0xE0E0E0,
            debug:   0x1ABC9C,
            info:    0x3498DB,
            warn:    0xF1C40F,
            error:   0xE74C3C,
            fatal:   0xF5F5F5
        ).background(
            fatal:   0xE74C3C
        ).components(
            components
        ).build()
    }
}
