//
//  Types.swift
//  Mortar
//
//  Created by Dima Bart on 2017-05-11.
//  Copyright © 2017 Dima Bart. All rights reserved.
//

import Foundation
import Mortar

typealias T_AsyncIntToInt       = (Int,    (Result<Int,    TestError>) -> Void) -> Void
typealias T_AsyncIntToString    = (Int,    (Result<String, TestError>) -> Void) -> Void
typealias T_AsyncStringToString = (String, (Result<String, TestError>) -> Void) -> Void
typealias T_AsyncStringToInt    = (String, (Result<Int,    TestError>) -> Void) -> Void

typealias T_SyncIntToInt        = (Int) -> Result<Int,    TestError>
typealias T_SyncIntToString     = (Int) -> Result<String, TestError>


typealias T_SimpleIntToInt      = (Int) -> Int
typealias T_SimpleIntToString   = (Int) -> String

// ----------------------------------
//  MARK: - Functions -
//
let addTwo_s: T_AsyncIntToInt = { value, completion in
    return completion(.success(value + 2))
}

let addTwo_f: T_AsyncIntToInt = { value, completion in
    return completion(.failure(.generic))
}

let subtractThree_s: T_AsyncIntToInt = { value, completion in
    return completion(.success(value - 3))
}

let subtractThree_f: T_AsyncIntToInt = { value, completion in
    return completion(.failure(.generic))
}

let stringify_s: T_AsyncIntToString = { value, completion in
    return completion(.success("String: \(value)"))
}

let stringify_f: T_AsyncIntToString = { value, completion in
    return completion(.failure(.generic))
}

let double_s: T_SyncIntToInt = { value in
    return .success(value * 2)
}

let double_f: T_SyncIntToInt = { value in
    return .failure(.generic)
}

let pow_s: T_SyncIntToInt = { value in
    return .success(value * value)
}

let pow_f: T_SyncIntToInt = { value in
    return .failure(.generic)
}

let triple_s: T_SimpleIntToInt = { value in
    return value * 3
}
