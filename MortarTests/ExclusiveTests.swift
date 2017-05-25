//
//  ExclusiveTests.swift
//  MortarTests
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

import XCTest
import Mortar

class ExclusiveTests: XCTestCase {

    // ----------------------------------
    //  MARK: - Async Result Map -
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
    //  MARK: - Result Map -
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
    
    // ----------------------------------
    //  MARK: - Async Result Emitter -
    //
    func testAsyncEmitterToAsyncEmitterSuccess() {
        let pipeline = createSeven_s <-> createEight_s
        
        pipeline() { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 7)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testAsyncEmitterToAsyncEmitterFailure() {
        let pipeline = createSeven_f <-> createEight_s
        
        pipeline() { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 8)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testAsyncEmitterToSyncEmitterSuccess() {
        let pipeline = createSeven_s <-> createFive_s
        
        pipeline() { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 7)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testAsyncEmitterToSyncEmitterFailure() {
        let pipeline = createSeven_f <-> createFive_s
        
        pipeline() { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 5)
            case .failure:
                XCTFail()
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - Result Emitter -
    //
    func testSyncEmitterToSyncEmitterSuccess() {
        let pipeline = createFive_s <-> createFour_s
        
        switch pipeline() {
        case .success(let value):
            XCTAssertEqual(value, 5)
        case .failure:
            XCTFail()
        }
    }
    
    func testSyncEmitterToSyncEmitterFailure() {
        let pipeline = createFive_f <-> createFour_s
        
        switch pipeline() {
        case .success(let value):
            XCTAssertEqual(value, 4)
        case .failure:
            XCTFail()
        }
    }
    
    
    func testSyncEmitterToAsyncEmitterSuccess() {
        let pipeline = createFive_s <-> createSeven_s
        
        pipeline() { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 5)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testSyncEmitterToAsyncEmitterFailure() {
        let pipeline = createFive_f <-> createSeven_s
        
        pipeline() { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 7)
            case .failure:
                XCTFail()
            }
        }
    }
}
