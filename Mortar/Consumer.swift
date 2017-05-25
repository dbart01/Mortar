//
//  Consumer.swift
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
infix operator -<: ConsumerPrecedence

// ----------------------------------
//  MARK: - Overloads -
//
/// Consumer operator that takes the output of an async map and appends a passthrough function
/// that returns the same output, unchanged. A passthrough function doesn't modify the processing pipeline.
///
/// - parameters:
///     - lhs: Async map that has an input of `X` and output of `Y`.
///     - rhs: Consumer function that has an input of `Y` and no return value.
///
/// - returns:
/// The same async map that was the `lhs` input value.
///
public func -< <X, Y, E>(lhs: @escaping AsyncResultMap<X, Y, E>, rhs: @escaping Consumer<Y>) -> AsyncResultMap<X, Y, E> {
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

/// Consumer operator that takes the output of an async map and appends a passthrough function
/// that returns the same output, unchanged. A passthrough function doesn't modify the processing pipeline.
///
/// - parameters:
///     - lhs: Result map that has an input of `X` and output of `Y`.
///     - rhs: Consumer function that has an input of `Y` and no return value.
///
/// - returns:
/// The same result map that was the `lhs` input value.
///
public func -< <X, Y, E>(lhs: @escaping ResultMap<X, Y, E>, rhs: @escaping Consumer<Y>) -> ResultMap<X, Y, E> {
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

/// Consumer operator that takes the output of an async map and appends a passthrough function
/// that returns the same output, unchanged. A passthrough function doesn't modify the processing pipeline.
///
/// - parameters:
///     - lhs: A map that has an input of `X` and output of `Y`.
///     - rhs: Consumer function that has an input of `Y` and no return value.
///
/// - returns:
/// The same map that was the `lhs` input value.
///
public func -< <X, Y>(lhs: @escaping Map<X, Y>, rhs: @escaping Consumer<Y>) -> Map<X, Y> {
    return { x in
        let y = lhs(x)
        rhs(y)
        return y
    }
}
