//
//  FunctionTypes.swift
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

/// Asynchronous transformation that takes `X` and calls a 
/// completion with a `Result` of type `Y` if the operation
/// was successful, or `E` if operation failed.
///
/// - parameters:
///     - input:  Input value of type `X`.
///     - output: Output handler to be called on completion with `Result` of type `Y`.
///
public typealias AsyncTransform<X, Y, E: Error> = (_ input: X, _ output: @escaping (Result<Y, E>) -> Void) -> Void

/// Synchronous transformation that takes `X` and returns
/// a `Result` of type `Y` if the operation was successful, 
/// or `E` if operation failed.
///
/// - parameters:
///     - input: Input value of type `X`.
///
public typealias Transform<X, Y, E: Error> = (_ input: X) -> Result<Y, E>

/// Synchronous transformation that takes `X` and returns `Y`.
/// Since the return type is a raw value and not a `Result`, it
/// is assumed that the operation always succeeds and cannot fail.
///
/// - parameters:
///     - input: Input value of type `X`.
///
public typealias SimpleTransform<X, Y> = (_ input: X) -> Y

/// Synchronous transformation that takes `X` and returns no value.
///
/// - parameters:
///     - input: Input value of type `X`.
///
public typealias PassTransform<X> = (_ input: X) -> Void
