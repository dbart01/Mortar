//
//  Compositional.swift
//  Mortar
//
//  Created by Dima Bart on 2017-05-11.
//  Copyright © 2017 Dima Bart. All rights reserved.
//

import Foundation

// ----------------------------------
//  MARK: - Operator -
//
infix operator <<-: AdditionPrecedence

// ----------------------------------
//  MARK: - Overloads -
//
func <<- <X, Y, Z, E>(lhs: @escaping AsyncTransform<X, Y, E>, rhs: @escaping AsyncTransform<Y, Z, E>) -> AsyncTransform<X, Z, E> {
    print("Async -> Async")
    return { x, completion in
        lhs(x) { result in
            switch result {
            case .success(let y):     rhs(y, completion)
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

func <<- <X, Y, Z, E>(lhs: @escaping AsyncTransform<X, Y, E>, rhs: @escaping Transform<Y, Z, E>) -> AsyncTransform<X, Z, E> {
    print("Async -> Transform")
    return { x, completion in
        lhs(x) { result in
            switch result {
            case .success(let y):     completion(rhs(y))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

func <<- <X, Y, Z, E>(lhs: @escaping AsyncTransform<X, Y, E>, rhs: @escaping SimpleTransform<Y, Z>) -> AsyncTransform<X, Z, E> {
    print("Async -> Simple")
    return { x, completion in
        lhs(x) { result in
            switch result {
            case .success(let y):     completion(.success(rhs(y)))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}

func <<- <X, Y, Z, E>(lhs: @escaping Transform<X, Y, E>, rhs: @escaping Transform<Y, Z, E>) -> Transform<X, Z, E> {
    print("Transform -> Transform")
    return { x in
        switch lhs(x) {
        case .success(let y):     return rhs(y)
        case .failure(let error): return .failure(error)
        }
    }
}

func <<- <X, Y, Z, E>(lhs: @escaping Transform<X, Y, E>, rhs: @escaping AsyncTransform<Y, Z, E>) -> AsyncTransform<X, Z, E> {
    print("Transform -> Async")
    return { x, completion in
        switch lhs(x) {
        case .success(let y):     return rhs(y, completion)
        case .failure(let error): return completion(.failure(error))
        }
    }
}

func <<- <X, Y, Z, E>(lhs: @escaping Transform<X, Y, E>, rhs: @escaping SimpleTransform<Y, Z>) -> Transform<X, Z, E> {
    print("Transform -> Simple")
    return { x in
        switch lhs(x) {
        case .success(let y):     return .success(rhs(y))
        case .failure(let error): return .failure(error)
        }
    }
}

func <<- <X, Y, Z>(lhs: @escaping SimpleTransform<X, Y>, rhs: @escaping SimpleTransform<Y, Z>) -> SimpleTransform<X, Z> {
    print("Simple -> Simple")
    return { x in
        return rhs(lhs(x))
    }
}

func <<- <X, Y, Z, E>(lhs: @escaping SimpleTransform<X, Y>, rhs: @escaping Transform<Y, Z, E>) -> Transform<X, Z, E> {
    print("Simple -> Transform")
    return { x in
        return rhs(lhs(x))
    }
}

func <<- <X, Y, Z, E>(lhs: @escaping SimpleTransform<X, Y>, rhs: @escaping AsyncTransform<Y, Z, E>) -> AsyncTransform<X, Z, E> {
    print("Simple -> Async")
    return { x, completion in
        return rhs(lhs(x), completion)
    }
}
