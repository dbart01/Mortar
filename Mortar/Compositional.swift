//
//  Compositional.swift
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
infix operator <<-: CompositionPrecedence

// ----------------------------------
//  MARK: - Overloads -
//
/// Compositional operator that merges the `rhs` async map into the `lhs` async map
/// to create a new async map that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: Async map that has an input of `X` and output of `Y`.
///     - rhs: Async map that has an input of `Y` and output of `Z`.
///
/// - returns:
/// Async map that has an input of `X` and output of `Z`. Merging an async map
/// into an async map will yield a async map.
///
public func <<- <X, Y, Z, E>(lhs: @escaping AsyncResultMap<X, Y, E>, rhs: @escaping AsyncResultMap<Y, Z, E>) -> AsyncResultMap<X, Z, E> {
    return { x, completion in
        lhs(x) { result in
            switch result {
            case .success(let y):     rhs(y, completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

/// Compositional operator that merges the `rhs` result map into the `lhs` async map
/// to create a new async map that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: Async map that has an input of `X` and output of `Y`.
///     - rhs: Result map that has an input of `Y` and output of `Z`.
///
/// - returns:
/// Async map that has an input of `X` and output of `Z`. Merging a result map
/// into an async map will yield an async map.
///
public func <<- <X, Y, Z, E>(lhs: @escaping AsyncResultMap<X, Y, E>, rhs: @escaping ResultMap<Y, Z, E>) -> AsyncResultMap<X, Z, E> {
    return { x, completion in
        lhs(x) { result in
            switch result {
            case .success(let y):     completion(rhs(y))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

/// Compositional operator that merges the `rhs` map into the `lhs` async map
/// to create a new async map that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: Async map that has an input of `X` and output of `Y`.
///     - rhs: A map that has an input of `Y` and output of `Z`.
///
/// - returns:
/// Async map that has an input of `X` and output of `Z`. Merging a map
/// into an async map will yield an async map.
///
public func <<- <X, Y, Z, E>(lhs: @escaping AsyncResultMap<X, Y, E>, rhs: @escaping Map<Y, Z>) -> AsyncResultMap<X, Z, E> {
    return { x, completion in
        lhs(x) { result in
            switch result {
            case .success(let y):     completion(.success(rhs(y)))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

/// Compositional operator that merges the `rhs` result map into the `lhs` result map
/// to create a new result map that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: Result map that has an input of `X` and output of `Y`.
///     - rhs: Result map that has an input of `Y` and output of `Z`.
///
/// - returns:
/// Result map that has an input of `X` and output of `Z`. Merging a result map
/// into a result map will yield a result map.
///
public func <<- <X, Y, Z, E>(lhs: @escaping ResultMap<X, Y, E>, rhs: @escaping ResultMap<Y, Z, E>) -> ResultMap<X, Z, E> {
    return { x in
        switch lhs(x) {
        case .success(let y):     return rhs(y)
        case .failure(let error): return .failure(error)
        }
    }
}

/// Compositional operator that merges the `rhs` async map into the `lhs` result map
/// to create a new async map that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: Result map that has an input of `X` and output of `Y`.
///     - rhs: Async map that has an input of `Y` and output of `Z`.
///
/// - returns:
/// Async map that has an input of `X` and output of `Z`. Merging an async map
/// into a result map will yield an async map.
///
public func <<- <X, Y, Z, E>(lhs: @escaping ResultMap<X, Y, E>, rhs: @escaping AsyncResultMap<Y, Z, E>) -> AsyncResultMap<X, Z, E> {
    return { x, completion in
        switch lhs(x) {
        case .success(let y):     return rhs(y, completion)
        case .failure(let error): return completion(.failure(error))
        }
    }
}

/// Compositional operator that merges the `rhs` map into the `lhs` result map
/// to create a new result map that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: Result map that has an input of `X` and output of `Y`.
///     - rhs: A map that has an input of `Y` and output of `Z`.
///
/// - returns:
/// Result map that has an input of `X` and output of `Z`. Merging a map
/// into a result map will yield a result map.
///
public func <<- <X, Y, Z, E>(lhs: @escaping ResultMap<X, Y, E>, rhs: @escaping Map<Y, Z>) -> ResultMap<X, Z, E> {
    return { x in
        switch lhs(x) {
        case .success(let y):     return .success(rhs(y))
        case .failure(let error): return .failure(error)
        }
    }
}

/// Compositional operator that merges the `rhs` map into the `lhs` map
/// to create a new map that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: A map that has an input of `X` and output of `Y`.
///     - rhs: A map that has an input of `Y` and output of `Z`.
///
/// - returns:
/// A map that has an input of `X` and output of `Z`. Merging a map
/// into a map will yield a map.
///
public func <<- <X, Y, Z>(lhs: @escaping Map<X, Y>, rhs: @escaping Map<Y, Z>) -> Map<X, Z> {
    return { x in
        return rhs(lhs(x))
    }
}

/// Compositional operator that merges the `rhs` result map into the `lhs` map
/// to create a new result map that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: A map that has an input of `X` and output of `Y`.
///     - rhs: Result map that has an input of `Y` and output of `Z`.
///
/// - returns:
/// Result map that has an input of `X` and output of `Z`. Merging a result map
/// into a map will yield a result map.
///
public func <<- <X, Y, Z, E>(lhs: @escaping Map<X, Y>, rhs: @escaping ResultMap<Y, Z, E>) -> ResultMap<X, Z, E> {
    return { x in
        return rhs(lhs(x))
    }
}

/// Compositional operator that merges the `rhs` async map into the `lhs` map
/// to create a new async map that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: A map that has an input of `X` and output of `Y`.
///     - rhs: Async map that has an input of `Y` and output of `Z`.
///
/// - returns:
/// Async map that has an input of `X` and output of `Z`. Merging an async map
/// into a map will yield an async map.
///
public func <<- <X, Y, Z, E>(lhs: @escaping Map<X, Y>, rhs: @escaping AsyncResultMap<Y, Z, E>) -> AsyncResultMap<X, Z, E> {
    return { x, completion in
        return rhs(lhs(x), completion)
    }
}
