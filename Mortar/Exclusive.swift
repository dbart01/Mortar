//
//  Exclusive.swift
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
infix operator <->: ExclusivePrecedence

// ----------------------------------
//  MARK: - Overloads -
//
/// Exclusive operator that merges the `rhs` async operation into the `lhs` async operation
/// to create a new async operation that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` fails. If `lhs` succeeds, the execution will continue along the pipeline with
/// the result of `lhs` and `rhs` operation will be skipped.
///
/// - parameters:
///     - lhs: Async transformation that has an input of `X` and output of `Y`.
///     - rhs: Async transformation that has an input of `X` and output of `Y`.
///
/// - returns:
/// Async transformation that has an input of `X` and output of `Y`. Merging an async transformation
/// into an async operation will yield a async transformation.
///
public func <-> <X, Y, E>(lhs: @escaping AsyncTransform<X, Y, E>, rhs: @escaping AsyncTransform<X, Y, E>) -> AsyncTransform<X, Y, E> {
    return { x, completion in
        lhs(x) { result in
            switch result {
            case .success(let y): completion(.success(y))
            case .failure:        rhs(x, completion)
            }
        }
    }
}

/// Exclusive operator that merges the `rhs` sync operation into the `lhs` async operation
/// to create a new async operation that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` fails. If `lhs` succeeds, the execution will continue along the pipeline with
/// the result of `lhs` and `rhs` operation will be skipped.
///
/// - parameters:
///     - lhs: Async transformation that has an input of `X` and output of `Y`.
///     - rhs: Sync transformation that has an input of `X` and output of `Y`.
///
/// - returns:
/// Async transformation that has an input of `X` and output of `Y`. Merging a sync transformation
/// into an async operation will yield a async transformation.
///
public func <-> <X, Y, E>(lhs: @escaping AsyncTransform<X, Y, E>, rhs: @escaping Transform<X, Y, E>) -> AsyncTransform<X, Y, E> {
    return { x, completion in
        lhs(x) { result in
            switch result {
            case .success(let y): completion(.success(y))
            case .failure:        completion(rhs(x))
            }
        }
    }
}

/// Exclusive operator that merges the `rhs` simple operation into the `lhs` async operation
/// to create a new async operation that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` fails. If `lhs` succeeds, the execution will continue along the pipeline with
/// the result of `lhs` and `rhs` operation will be skipped.
///
/// - parameters:
///     - lhs: Async transformation that has an input of `X` and output of `Y`.
///     - rhs: Simple transformation that has an input of `X` and output of `Y`.
///
/// - returns:
/// Async transformation that has an input of `X` and output of `Y`. Merging a simple transformation
/// into an async operation will yield a async transformation.
///
public func <-> <X, Y, E>(lhs: @escaping AsyncTransform<X, Y, E>, rhs: @escaping SimpleTransform<X, Y>) -> AsyncTransform<X, Y, E> {
    return { x, completion in
        lhs(x) { result in
            switch result {
            case .success(let y): completion(.success(y))
            case .failure:        completion(.success(rhs(x)))
            }
        }
    }
}

/// Exclusive operator that merges the `rhs` sync operation into the `lhs` sync operation
/// to create a new sync operation that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` fails. If `lhs` succeeds, the execution will continue along the pipeline with
/// the result of `lhs` and `rhs` operation will be skipped.
///
/// - parameters:
///     - lhs: Sync transformation that has an input of `X` and output of `Y`.
///     - rhs: Sync transformation that has an input of `X` and output of `Y`.
///
/// - returns:
/// Sync transformation that has an input of `X` and output of `Y`. Merging a sync transformation
/// into an sync operation will yield a sync transformation.
///
public func <-> <X, Y, E>(lhs: @escaping Transform<X, Y, E>, rhs: @escaping Transform<X, Y, E>) -> Transform<X, Y, E> {
    return { x in
        switch lhs(x) {
        case .success(let y): return .success(y)
        case .failure:        return rhs(x)
        }
    }
}

/// Exclusive operator that merges the `rhs` async operation into the `lhs` sync operation
/// to create a new async operation that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` fails. If `lhs` succeeds, the execution will continue along the pipeline with
/// the result of `lhs` and `rhs` operation will be skipped.
///
/// - parameters:
///     - lhs: Sync transformation that has an input of `X` and output of `Y`.
///     - rhs: Async transformation that has an input of `X` and output of `Y`.
///
/// - returns:
/// Async transformation that has an input of `X` and output of `Y`. Merging an async transformation
/// into an sync operation will yield an async transformation.
///
public func <-> <X, Y, E>(lhs: @escaping Transform<X, Y, E>, rhs: @escaping AsyncTransform<X, Y, E>) -> AsyncTransform<X, Y, E> {
    return { x, completion in
        switch lhs(x) {
        case .success(let y): return completion(.success(y))
        case .failure:        return rhs(x, completion)
        }
    }
}

/// Exclusive operator that merges the `rhs` simple operation into the `lhs` sync operation
/// to create a new sync operation that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` fails. If `lhs` succeeds, the execution will continue along the pipeline with
/// the result of `lhs` and `rhs` operation will be skipped.
///
/// - parameters:
///     - lhs: Sync transformation that has an input of `X` and output of `Y`.
///     - rhs: Simple transformation that has an input of `X` and output of `Y`.
///
/// - returns:
/// Sync transformation that has an input of `X` and output of `Y`. Merging a simple transformation
/// into an sync operation will yield a sync transformation.
///
public func <-> <X, Y, E>(lhs: @escaping Transform<X, Y, E>, rhs: @escaping SimpleTransform<X, Y>) -> Transform<X, Y, E> {
    return { x in
        switch lhs(x) {
        case .success(let y): return .success(y)
        case .failure:        return .success(rhs(x))
        }
    }
}
