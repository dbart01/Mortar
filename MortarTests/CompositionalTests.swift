//
//  CompositionalTests.swift
//  MortarTests
//
//  Created by Dima Bart on 2017-05-11.
//  Copyright © 2017 Dima Bart. All rights reserved.
//

import XCTest
import Mortar

class CompositionalTests: XCTestCase {
    
    // ----------------------------------
    //  MARK: - Async to X -
    //
    func testAsyncToAsyncSuccess() {
        let pipeline = addTwo_s <<- stringify_s
        
        pipeline(2) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, "String: 4")
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testAsyncToAsyncFailure() {
        let pipeline = addTwo_f <<- stringify_s
        
        pipeline(2) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .generic)
            }
        }
    }
    
    func testAsyncToSyncSuccess() {
        let pipeline = addTwo_s <<- double_s
        
        pipeline(2) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 8)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testAsyncToSyncFailure() {
        let pipeline = addTwo_f <<- double_s
        
        pipeline(2) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .generic)
            }
        }
    }
    
    func testAsyncToSimpleSuccess() {
        let pipeline = addTwo_s <<- triple_s
        
        pipeline(2) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 12)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testAsyncToSimpleFailure() {
        let pipeline = addTwo_f <<- triple_s
        
        pipeline(2) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .generic)
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - Sync to X -
    //
    func testSyncToSyncSuccess() {
        let pipeline = double_s <<- double_s
        
        switch pipeline(2) {
        case .success(let value):
            XCTAssertEqual(value, 8)
        case .failure:
            XCTFail()
        }
    }
    
    func testSyncToSyncFailure() {
        let pipeline = double_f <<- double_s
        
        switch pipeline(2) {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, .generic)
        }
    }
    
    func testSyncToAsyncSuccess() {
        let pipeline = double_s <<- addTwo_s
        
        pipeline(2) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 6)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testSyncToAsyncFailure() {
        let pipeline = double_f <<- addTwo_s
        
        pipeline(2) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .generic)
            }
        }
    }
    
    func testSyncToSimpleSuccess() {
        let pipeline = double_s <<- triple_s
        
        switch pipeline(2) {
        case .success(let value):
            XCTAssertEqual(value, 12)
        case .failure:
            XCTFail()
        }
    }
    
    func testSyncToSimpleFailure() {
        let pipeline = double_f <<- triple_s
        
        switch pipeline(2) {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, .generic)
        }
    }
    
    // ----------------------------------
    //  MARK: - Simple to X -
    //
    func testSimpleToSimple() {
        let pipeline = triple_s <<- triple_s
        
        XCTAssertEqual(pipeline(2), 18)
    }
    
    func testSimpleToSync() {
        let pipeline = triple_s <<- double_s
        
        switch pipeline(2) {
        case .success(let value):
            XCTAssertEqual(value, 12)
        case .failure:
            XCTFail()
        }
    }
    
    func testSimpleToAsync() {
        let pipeline = triple_s <<- addTwo_s
        
        pipeline(2) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 8)
            case .failure:
                XCTFail()
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - Functions -
    //
    private let addTwo_s: T_AsyncIntToInt = { value, completion in
        return completion(.success(value + 2))
    }
    
    private let addTwo_f: T_AsyncIntToInt = { value, completion in
        return completion(.failure(.generic))
    }
    
    private let stringify_s: T_AsyncIntToString = { value, completion in
        return completion(.success("String: \(value)"))
    }
    
    private let stringify_f: T_AsyncIntToString = { value, completion in
        return completion(.failure(.generic))
    }
    
    private let double_s: T_SyncIntToInt = { value in
        return .success(value * 2)
    }
    
    private let double_f: T_SyncIntToInt = { value in
        return .failure(.generic)
    }
    
    private let triple_s: T_SimpleIntToInt = { value in
        return value * 3
    }
}
