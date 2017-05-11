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
