//
//  Exclusive.swift
//  Mortar
//
//  Created by Dima Bart on 2017-05-11.
//  Copyright © 2017 Dima Bart. All rights reserved.
//

import Foundation

// ----------------------------------
//  MARK: - Operator -
//
infix operator <->: AdditionPrecedence

// ----------------------------------
//  MARK: - Overloads -
//
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

public func <-> <X, Y, E>(lhs: @escaping Transform<X, Y, E>, rhs: @escaping Transform<X, Y, E>) -> Transform<X, Y, E> {
    return { x in
        switch lhs(x) {
        case .success(let y): return .success(y)
        case .failure:        return rhs(x)
        }
    }
}

public func <-> <X, Y, E>(lhs: @escaping Transform<X, Y, E>, rhs: @escaping AsyncTransform<X, Y, E>) -> AsyncTransform<X, Y, E> {
    return { x, completion in
        switch lhs(x) {
        case .success(let y): return completion(.success(y))
        case .failure:        return rhs(x, completion)
        }
    }
}

public func <-> <X, Y, E>(lhs: @escaping Transform<X, Y, E>, rhs: @escaping SimpleTransform<X, Y>) -> Transform<X, Y, E> {
    return { x in
        switch lhs(x) {
        case .success(let y): return .success(y)
        case .failure:        return .success(rhs(x))
        }
    }
}
