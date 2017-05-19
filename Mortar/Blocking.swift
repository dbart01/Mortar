//
//  Blocking.swift
//  Mortar
//
//  The MIT License (MIT)
//
//  Copyright (c) 2017 Dima Bart
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

// ----------------------------------
//  MARK: - Operator -
//
postfix operator ~

// ----------------------------------
//  MARK: - Overloads -
//
/// Blocking operation converts an asynchronous operation in a synchronous one. It uses
/// a semaphore to wait for the async operation to finish on the same queue that it's
/// invoked on. It is **critical** that the underlying operation doesn't execute on the
/// the same queue as the invokation of this operation, **otherwise a deadlock will occur**.
///
/// - parameters:
///     - lhs: Async transformation that has an input of `X` and output of `Y`.
///
/// - returns:
/// A sync transformation that has the same input and output values as the `lhs` async operation.
///
public postfix func ~ <X, Y, E>(lhs: @escaping AsyncTransform<X, Y, E>) -> Transform<X, Y, E> {
    return { x in
        let semaphore = DispatchSemaphore(value: 0)
        var r: Result<Y, E>!
        lhs(x) { result in
            r = result
            semaphore.signal()
        }
        semaphore.wait()
        return r
    }
}
