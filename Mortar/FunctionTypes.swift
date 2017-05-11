//
//  FunctionTypes.swift
//  Mortar
//
//  Created by Dima Bart on 2017-05-11.
//  Copyright © 2017 Dima Bart. All rights reserved.
//

import Foundation

typealias AsyncTransform<X, Y, E: Error>  = (_ input: X, _ output: @escaping (Result<Y, E>) -> Void) -> Void
typealias Transform<X, Y, E: Error>       = (_ input: X) -> Result<Y, E>
typealias SimpleTransform<X, Y>           = (_ input: X) -> Y
