//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftNIO open source project
//
// Copyright (c) 2017-2018 Apple Inc. and the SwiftNIO project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftNIO project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import NIO

fileprivate let defaultWhitespaces = [" ", "\t"].map({$0.utf8.first!})

extension ByteBufferView {
    internal func trim(limitingElements: [UInt8]) -> ByteBufferView {
        guard let lastNonWhitespaceIndex = self.lastIndex(where: { !limitingElements.contains($0) }),
              let firstNonWhitespaceIndex = self.firstIndex(where: { !limitingElements.contains($0) }) else {
                // This buffer is entirely trimmed elements, so trim it to nothing.
                return self[self.startIndex..<self.startIndex]
        }
        return self[firstNonWhitespaceIndex..<index(after: lastNonWhitespaceIndex)]
    }
    
    internal func trimSpaces() -> ByteBufferView {
        return trim(limitingElements: defaultWhitespaces)
    }
}

extension Sequence where Self.Element == UInt8 {
    /// Compares the collection of `UInt8`s to a case insensitive collection.
    ///
    /// This collection could be get from applying the `UTF8View`
    ///   property on the string protocol.
    ///
    /// - Parameter bytes: The string constant in the form of a collection of `UInt8`
    /// - Returns: Whether the collection contains **EXACTLY** this array or no, but by ignoring case.
    internal func compareCaseInsensitiveASCIIBytes<T: Sequence>(to bytes: T) -> Bool
        where T.Element == UInt8 {
            return self.elementsEqual(bytes, by: {return ($0 & 0xdf) == ($1 & 0xdf)})
    }
}
