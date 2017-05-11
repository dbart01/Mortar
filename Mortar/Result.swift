//
//  Result.swift
//  Mortar
//
//  Created by Dima Bart on 2017-05-11.
//  Copyright © 2017 Dima Bart. All rights reserved.
//

import Foundation

public enum Result<Type, ErrorType: Error> {
    case success(Type)
    case failure(ErrorType)
}
