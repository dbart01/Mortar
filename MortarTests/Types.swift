//
//  Types.swift
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
