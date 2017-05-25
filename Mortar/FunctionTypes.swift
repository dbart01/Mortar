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

/// Asynchronous result map that takes `X` and calls a
/// completion with a `Result` of type `Y` if the map
/// was successful, or `E` if map failed.
///
/// - parameters:
///     - input:  Input value of type `X`.
///     - output: Output handler to be called on completion with `Result` of type `Y`.
///
public typealias AsyncResultMap<X, Y, E: Error> = (_ input: X, _ output: @escaping (Result<Y, E>) -> Void) -> Void

/// Synchronous result map that takes `X` and returns
/// a `Result` of type `Y` if the map was successful,
/// or `E` if map failed.
///
/// - parameters:
///     - input: Input value of type `X`.
///
public typealias ResultMap<X, Y, E: Error> = (_ input: X) -> Result<Y, E>

/// A map that takes `X` and returns `Y`.
/// Since the return type is a raw value and not a `Result`, it
/// is assumed that the map always succeeds and cannot fail.
///
/// - parameters:
///     - input: Input value of type `X`.
///
public typealias Map<X, Y> = (_ input: X) -> Y

/// A passthrough function that takes `X` and returns no value.
///
/// - parameters:
///     - input: Input value of type `X`.
///
public typealias Consumer<X> = (_ input: X) -> Void

/// A generator function that takes no input and returns `X`.
///
/// - returns:
/// Output value of type `X`.
///
public typealias Emitter<X> = () -> X

/// A generator function that takes no input and returns a 
/// `Result` of type `X`.
///
/// - returns:
/// Output with `Result` of type `X`.
///
public typealias ResultEmitter<X, E: Error> = () -> Result<X, E>

/// An async generator function that takes no input and calls a 
/// completion with `Result` of type `X`.
///
/// - parameters:
///     - output: Output handler to be called on completion with `Result` of type `X`.
///
public typealias AsyncResultEmitter<X, E: Error> = (_ output: @escaping (Result<X, E>) -> Void) -> Void
