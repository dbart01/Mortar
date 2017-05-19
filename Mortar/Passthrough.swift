//
//  Passthrough.swift
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
infix operator -<: PassthroughPrecedence

// ----------------------------------
//  MARK: - Overloads -
//
/// Passthrough operator that take an output of an operation and appends a processing operation
/// that returns the same output, unchanged. A passthrough operation doesn't modify the processing pipeline.
///
/// - parameters:
///     - lhs: Async transformation that has an input of `X` and output of `Y`.
///     - rhs: Passthrough transformation that has an input of `Y` and no return value.
///
/// - returns:
/// The same async transformation that was the `lhs` input value.
///
public func -< <X, Y, E>(lhs: @escaping AsyncTransform<X, Y, E>, rhs: @escaping PassTransform<Y>) -> AsyncTransform<X, Y, E> {
    return { x, completion in
        lhs(x) { result in
            switch result {
            case .success(let y):
                rhs(y)
                completion(.success(y))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

/// Passthrough operator that take an output of an operation and appends a processing operation
/// that returns the same output, unchanged. A passthrough operation doesn't modify the processing pipeline.
///
/// - parameters:
///     - lhs: Sync transformation that has an input of `X` and output of `Y`.
///     - rhs: Passthrough transformation that has an input of `Y` and no return value.
///
/// - returns:
/// The same sync transformation that was the `lhs` input value.
///
public func -< <X, Y, E>(lhs: @escaping Transform<X, Y, E>, rhs: @escaping PassTransform<Y>) -> Transform<X, Y, E> {
    return { x in
        let result = lhs(x)
        switch result {
        case .success(let y):
            rhs(y)
        default:
            break
        }
        return result
    }
}

/// Passthrough operator that take an output of an operation and appends a processing operation
/// that returns the same output, unchanged. A passthrough operation doesn't modify the processing pipeline.
///
/// - parameters:
///     - lhs: Simple transformation that has an input of `X` and output of `Y`.
///     - rhs: Passthrough transformation that has an input of `Y` and no return value.
///
/// - returns:
/// The same simple transformation that was the `lhs` input value.
///
public func -< <X, Y>(lhs: @escaping SimpleTransform<X, Y>, rhs: @escaping PassTransform<Y>) -> SimpleTransform<X, Y> {
    return { x in
        let y = lhs(x)
        rhs(y)
        return y
    }
}
