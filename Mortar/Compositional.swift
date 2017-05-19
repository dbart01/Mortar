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
/// Compositional operator that merges the `rhs` async operation into the `lhs` async operation
/// to create a new async operation that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: Async transformation that has an input of `X` and output of `Y`.
///     - rhs: Async transformation that has an input of `Y` and output of `Z`.
///
/// - returns:
/// Async transformation that has an input of `X` and output of `Z`. Merging an async transformation
/// into an async operation will yield a async transformation.
///
public func <<- <X, Y, Z, E>(lhs: @escaping AsyncTransform<X, Y, E>, rhs: @escaping AsyncTransform<Y, Z, E>) -> AsyncTransform<X, Z, E> {
    return { x, completion in
        lhs(x) { result in
            switch result {
            case .success(let y):     rhs(y, completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

/// Compositional operator that merges the `rhs` sync operation into the `lhs` async operation
/// to create a new async operation that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: Async transformation that has an input of `X` and output of `Y`.
///     - rhs: Sync transformation that has an input of `Y` and output of `Z`.
///
/// - returns:
/// Async transformation that has an input of `X` and output of `Z`. Merging a sync transformation
/// into an async operation will yield an async transformation.
///
public func <<- <X, Y, Z, E>(lhs: @escaping AsyncTransform<X, Y, E>, rhs: @escaping Transform<Y, Z, E>) -> AsyncTransform<X, Z, E> {
    return { x, completion in
        lhs(x) { result in
            switch result {
            case .success(let y):     completion(rhs(y))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

/// Compositional operator that merges the `rhs` simple operation into the `lhs` async operation
/// to create a new async operation that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: Async transformation that has an input of `X` and output of `Y`.
///     - rhs: Simple transformation that has an input of `Y` and output of `Z`.
///
/// - returns:
/// Async transformation that has an input of `X` and output of `Z`. Merging a simple transformation
/// into an async operation will yield an async transformation.
///
public func <<- <X, Y, Z, E>(lhs: @escaping AsyncTransform<X, Y, E>, rhs: @escaping SimpleTransform<Y, Z>) -> AsyncTransform<X, Z, E> {
    return { x, completion in
        lhs(x) { result in
            switch result {
            case .success(let y):     completion(.success(rhs(y)))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

/// Compositional operator that merges the `rhs` sync operation into the `lhs` sync operation
/// to create a new sync operation that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: Sync transformation that has an input of `X` and output of `Y`.
///     - rhs: Sync transformation that has an input of `Y` and output of `Z`.
///
/// - returns:
/// Sync transformation that has an input of `X` and output of `Z`. Merging a sync transformation
/// into a sync operation will yield a sync transformation.
///
public func <<- <X, Y, Z, E>(lhs: @escaping Transform<X, Y, E>, rhs: @escaping Transform<Y, Z, E>) -> Transform<X, Z, E> {
    return { x in
        switch lhs(x) {
        case .success(let y):     return rhs(y)
        case .failure(let error): return .failure(error)
        }
    }
}

/// Compositional operator that merges the `rhs` async operation into the `lhs` sync operation
/// to create a new async operation that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: Sync transformation that has an input of `X` and output of `Y`.
///     - rhs: Async transformation that has an input of `Y` and output of `Z`.
///
/// - returns:
/// Async transformation that has an input of `X` and output of `Z`. Merging an async transformation
/// into a sync operation will yield an async transformation.
///
public func <<- <X, Y, Z, E>(lhs: @escaping Transform<X, Y, E>, rhs: @escaping AsyncTransform<Y, Z, E>) -> AsyncTransform<X, Z, E> {
    return { x, completion in
        switch lhs(x) {
        case .success(let y):     return rhs(y, completion)
        case .failure(let error): return completion(.failure(error))
        }
    }
}

/// Compositional operator that merges the `rhs` simple operation into the `lhs` sync operation
/// to create a new sync operation that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: Sync transformation that has an input of `X` and output of `Y`.
///     - rhs: Simple transformation that has an input of `Y` and output of `Z`.
///
/// - returns:
/// Sync transformation that has an input of `X` and output of `Z`. Merging a simple transformation
/// into a sync operation will yield a sync transformation.
///
public func <<- <X, Y, Z, E>(lhs: @escaping Transform<X, Y, E>, rhs: @escaping SimpleTransform<Y, Z>) -> Transform<X, Z, E> {
    return { x in
        switch lhs(x) {
        case .success(let y):     return .success(rhs(y))
        case .failure(let error): return .failure(error)
        }
    }
}

/// Compositional operator that merges the `rhs` simple operation into the `lhs` simple operation
/// to create a new simple operation that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: Simple transformation that has an input of `X` and output of `Y`.
///     - rhs: Simple transformation that has an input of `Y` and output of `Z`.
///
/// - returns:
/// Simple transformation that has an input of `X` and output of `Z`. Merging a simple transformation
/// into a simple operation will yield a simple transformation.
///
public func <<- <X, Y, Z>(lhs: @escaping SimpleTransform<X, Y>, rhs: @escaping SimpleTransform<Y, Z>) -> SimpleTransform<X, Z> {
    return { x in
        return rhs(lhs(x))
    }
}

/// Compositional operator that merges the `rhs` sync operation into the `lhs` simple operation
/// to create a new sync operation that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: Simple transformation that has an input of `X` and output of `Y`.
///     - rhs: Sync transformation that has an input of `Y` and output of `Z`.
///
/// - returns:
/// Sync transformation that has an input of `X` and output of `Z`. Merging a sync transformation
/// into a simple operation will yield a sync transformation.
///
public func <<- <X, Y, Z, E>(lhs: @escaping SimpleTransform<X, Y>, rhs: @escaping Transform<Y, Z, E>) -> Transform<X, Z, E> {
    return { x in
        return rhs(lhs(x))
    }
}

/// Compositional operator that merges the `rhs` async operation into the `lhs` simple operation
/// to create a new async operation that will execute the `lhs`, followed by the `rhs` **if**, and
/// only if the `lhs` succeeds. If `lhs` fails, the pipeline will exit with the failure result of `lhs`.
///
/// - parameters:
///     - lhs: Simple transformation that has an input of `X` and output of `Y`.
///     - rhs: Async transformation that has an input of `Y` and output of `Z`.
///
/// - returns:
/// Async transformation that has an input of `X` and output of `Z`. Merging an async transformation
/// into a simple operation will yield an async transformation.
///
public func <<- <X, Y, Z, E>(lhs: @escaping SimpleTransform<X, Y>, rhs: @escaping AsyncTransform<Y, Z, E>) -> AsyncTransform<X, Z, E> {
    return { x, completion in
        return rhs(lhs(x), completion)
    }
}
