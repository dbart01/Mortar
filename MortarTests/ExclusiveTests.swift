//
//  ExclusiveTests.swift
//  Mortar
//
//  Created by Dima Bart on 2017-05-13.
//  Copyright © 2017 Dima Bart. All rights reserved.
//

import XCTest
import Mortar

class ExclusiveTests: XCTestCase {

    // ----------------------------------
    //  MARK: - Async to X -
    //
    func testAsyncToAsyncSuccess() {
        let pipeline = addTwo_s <-> subtractThree_s
        
        pipeline(3) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 5)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testAsyncToAsyncFailure() {
        let pipeline = addTwo_f <-> subtractThree_s
        
        pipeline(5) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 2)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testAsyncToSyncSuccess() {
        let pipeline = addTwo_s <-> double_s
        
        pipeline(3) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 5)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testAsyncToSyncFailure() {
        let pipeline = addTwo_f <-> double_s
        
        pipeline(3) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 6)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testAsyncToSimpleSuccess() {
        let pipeline = addTwo_s <-> triple_s
        
        pipeline(3) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 5)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testAsyncToSimpleFailure() {
        let pipeline = addTwo_f <-> triple_s
        
        pipeline(3) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 9)
            case .failure:
                XCTFail()
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - Sync to X -
    //
    func testSyncToSyncSuccess() {
        let pipeline = double_s <-> pow_s
        
        switch pipeline(3) {
        case .success(let value):
            XCTAssertEqual(value, 6)
        case .failure:
            XCTFail()
        }
    }
    
    func testSyncToSyncFailure() {
        let pipeline = double_f <-> pow_s
        
        switch pipeline(3) {
        case .success(let value):
            XCTAssertEqual(value, 9)
        case .failure:
            XCTFail()
        }
    }
    
    func testSyncToAsyncSuccess() {
        let pipeline = double_s <-> addTwo_s
        
        pipeline(3) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 6)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testSyncToAsyncFailure() {
        let pipeline = double_f <-> addTwo_s
        
        pipeline(3) { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 5)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testSyncToSimpleSuccess() {
        let pipeline = pow_s <-> triple_s
        
        switch pipeline(4) {
        case .success(let value):
            XCTAssertEqual(value, 16)
        case .failure:
            XCTFail()
        }
    }
    
    func testSyncToSimpleFailure() {
        let pipeline = pow_f <-> triple_s
        
        switch pipeline(4) {
        case .success(let value):
            XCTAssertEqual(value, 12)
        case .failure:
            XCTFail()
        }
    }
}
