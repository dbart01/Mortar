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
func <-> <X, Y, E>(lhs: @escaping AsyncTransform<X, Y, E>, rhs: @escaping AsyncTransform<X, Y, E>) -> AsyncTransform<X, Y, E> {
    return { x, completion in
        lhs(x) { result in
            switch result {
            case .success(let y): completion(.success(y))
            case .failure:        rhs(x, completion)
            }
        }
    }
}
