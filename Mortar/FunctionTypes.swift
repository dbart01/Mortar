//
//  FunctionTypes.swift
//  Mortar
//
//  Created by Dima Bart on 2017-05-11.
//  Copyright © 2017 Dima Bart. All rights reserved.
//

import Foundation

public typealias AsyncTransform<X, Y, E: Error>  = (_ input: X, _ output: @escaping (Result<Y, E>) -> Void) -> Void
public typealias Transform<X, Y, E: Error>       = (_ input: X) -> Result<Y, E>
public typealias SimpleTransform<X, Y>           = (_ input: X) -> Y
