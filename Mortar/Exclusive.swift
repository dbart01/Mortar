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
/// Exclusive operator that merges the `rhs` async map into the `lhs` async map
/// to create a new async map that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` fails. If `lhs` succeeds, the execution will continue along the pipeline with
/// the result of `lhs` and `rhs` map will be skipped.
///
/// - parameters:
///     - lhs: Async map that has an input of `X` and output of `Y`.
///     - rhs: Async map that has an input of `X` and output of `Y`.
///
/// - returns:
/// Async map that has an input of `X` and output of `Y`. Merging an async map
/// into an async map will yield a async map.
///
public func <-> <X, Y, E>(lhs: @escaping AsyncResultMap<X, Y, E>, rhs: @escaping AsyncResultMap<X, Y, E>) -> AsyncResultMap<X, Y, E> {
    return { x, completion in
        lhs(x) { result in
            switch result {
            case .success(let y): completion(.success(y))
            case .failure:        rhs(x, completion)
            }
        }
    }
}

/// Exclusive operator that merges the `rhs` result map into the `lhs` async map
/// to create a new async map that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` fails. If `lhs` succeeds, the execution will continue along the pipeline with
/// the result of `lhs` and `rhs` map will be skipped.
///
/// - parameters:
///     - lhs: Async map that has an input of `X` and output of `Y`.
///     - rhs: Result map that has an input of `X` and output of `Y`.
///
/// - returns:
/// Async map that has an input of `X` and output of `Y`. Merging a result map
/// into an async map will yield a async map.
///
public func <-> <X, Y, E>(lhs: @escaping AsyncResultMap<X, Y, E>, rhs: @escaping ResultMap<X, Y, E>) -> AsyncResultMap<X, Y, E> {
    return { x, completion in
        lhs(x) { result in
            switch result {
            case .success(let y): completion(.success(y))
            case .failure:        completion(rhs(x))
            }
        }
    }
}

/// Exclusive operator that merges the `rhs` map into the `lhs` async map
/// to create a new async map that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` fails. If `lhs` succeeds, the execution will continue along the pipeline with
/// the result of `lhs` and `rhs` map will be skipped.
///
/// - parameters:
///     - lhs: Async map that has an input of `X` and output of `Y`.
///     - rhs: A map that has an input of `X` and output of `Y`.
///
/// - returns:
/// Async map that has an input of `X` and output of `Y`. Merging a map
/// into an async map will yield a async map.
///
public func <-> <X, Y, E>(lhs: @escaping AsyncResultMap<X, Y, E>, rhs: @escaping Map<X, Y>) -> AsyncResultMap<X, Y, E> {
    return { x, completion in
        lhs(x) { result in
            switch result {
            case .success(let y): completion(.success(y))
            case .failure:        completion(.success(rhs(x)))
            }
        }
    }
}

/// Exclusive operator that merges the `rhs` result map into the `lhs` result map
/// to create a new result map that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` fails. If `lhs` succeeds, the execution will continue along the pipeline with
/// the result of `lhs` and `rhs` map will be skipped.
///
/// - parameters:
///     - lhs: Result map that has an input of `X` and output of `Y`.
///     - rhs: Result map that has an input of `X` and output of `Y`.
///
/// - returns:
/// Result map that has an input of `X` and output of `Y`. Merging a result map
/// into an result map will yield a result map.
///
public func <-> <X, Y, E>(lhs: @escaping ResultMap<X, Y, E>, rhs: @escaping ResultMap<X, Y, E>) -> ResultMap<X, Y, E> {
    return { x in
        switch lhs(x) {
        case .success(let y): return .success(y)
        case .failure:        return rhs(x)
        }
    }
}

/// Exclusive operator that merges the `rhs` async map into the `lhs` result map
/// to create a new async map that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` fails. If `lhs` succeeds, the execution will continue along the pipeline with
/// the result of `lhs` and `rhs` map will be skipped.
///
/// - parameters:
///     - lhs: Result map that has an input of `X` and output of `Y`.
///     - rhs: Async map that has an input of `X` and output of `Y`.
///
/// - returns:
/// Async map that has an input of `X` and output of `Y`. Merging an async map
/// into an result map will yield an async map.
///
public func <-> <X, Y, E>(lhs: @escaping ResultMap<X, Y, E>, rhs: @escaping AsyncResultMap<X, Y, E>) -> AsyncResultMap<X, Y, E> {
    return { x, completion in
        switch lhs(x) {
        case .success(let y): return completion(.success(y))
        case .failure:        return rhs(x, completion)
        }
    }
}

/// Exclusive operator that merges the `rhs` map into the `lhs` result map
/// to create a new result map that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` fails. If `lhs` succeeds, the execution will continue along the pipeline with
/// the result of `lhs` and `rhs` map will be skipped.
///
/// - parameters:
///     - lhs: Result map that has an input of `X` and output of `Y`.
///     - rhs: A map that has an input of `X` and output of `Y`.
///
/// - returns:
/// Result map that has an input of `X` and output of `Y`. Merging a map
/// into an result map will yield a result map.
///
public func <-> <X, Y, E>(lhs: @escaping ResultMap<X, Y, E>, rhs: @escaping Map<X, Y>) -> ResultMap<X, Y, E> {
    return { x in
        switch lhs(x) {
        case .success(let y): return .success(y)
        case .failure:        return .success(rhs(x))
        }
    }
}
