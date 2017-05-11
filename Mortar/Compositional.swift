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
public infix operator <<-: AdditionPrecedence

// ----------------------------------
//  MARK: - Overloads -
//
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

public func <<- <X, Y, Z, E>(lhs: @escaping Transform<X, Y, E>, rhs: @escaping Transform<Y, Z, E>) -> Transform<X, Z, E> {
    return { x in
        switch lhs(x) {
        case .success(let y):     return rhs(y)
        case .failure(let error): return .failure(error)
        }
    }
}

public func <<- <X, Y, Z, E>(lhs: @escaping Transform<X, Y, E>, rhs: @escaping AsyncTransform<Y, Z, E>) -> AsyncTransform<X, Z, E> {
    return { x, completion in
        switch lhs(x) {
        case .success(let y):     return rhs(y, completion)
        case .failure(let error): return completion(.failure(error))
        }
    }
}

public func <<- <X, Y, Z, E>(lhs: @escaping Transform<X, Y, E>, rhs: @escaping SimpleTransform<Y, Z>) -> Transform<X, Z, E> {
    return { x in
        switch lhs(x) {
        case .success(let y):     return .success(rhs(y))
        case .failure(let error): return .failure(error)
        }
    }
}

public func <<- <X, Y, Z>(lhs: @escaping SimpleTransform<X, Y>, rhs: @escaping SimpleTransform<Y, Z>) -> SimpleTransform<X, Z> {
    return { x in
        return rhs(lhs(x))
    }
}

public func <<- <X, Y, Z, E>(lhs: @escaping SimpleTransform<X, Y>, rhs: @escaping Transform<Y, Z, E>) -> Transform<X, Z, E> {
    return { x in
        return rhs(lhs(x))
    }
}

public func <<- <X, Y, Z, E>(lhs: @escaping SimpleTransform<X, Y>, rhs: @escaping AsyncTransform<Y, Z, E>) -> AsyncTransform<X, Z, E> {
    return { x, completion in
        return rhs(lhs(x), completion)
    }
}
