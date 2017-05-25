//
//  ConsumerTests.swift
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

class ConsumerTests: XCTestCase {

    // ----------------------------------
    //  MARK: - Map -
    //
    func testAsyncConsumerSuccess() {
        
        var didLog = false
        
        let log: T_ConsumerInt = { value in
            didLog = true
            XCTAssertEqual(value, 5)
        }
        
        let pipeline = addTwo_s -< log <<- stringify_s
        pipeline(3) { _ in }
        
        XCTAssertTrue(didLog)
    }
    
    func testAsyncConsumerFailure() {
        
        var didLog = false
        
        let log: T_ConsumerInt = { value in
            didLog = true
        }
        
        let pipeline = addTwo_f -< log <<- stringify_s
        pipeline(3) { _ in }
        
        XCTAssertFalse(didLog)
    }
    
    func testSyncConsumerSuccess() {
        
        var didLog = false
        
        let log: T_ConsumerInt = { value in
            didLog = true
            XCTAssertEqual(value, 6)
        }
        
        let pipeline = double_s -< log <<- stringify_s
        pipeline(3) { _ in }
        
        XCTAssertTrue(didLog)
    }
    
    func testSyncConsumerFailure() {
        
        var didLog = false
        
        let log: T_ConsumerInt = { value in
            didLog = true
        }
        
        let pipeline = double_f -< log <<- stringify_s
        pipeline(3) { _ in }
        
        XCTAssertFalse(didLog)
    }
    
    func testSimpleConsumerSuccess() {
        
        var didLog = false
        
        let log: T_ConsumerInt = { value in
            didLog = true
            XCTAssertEqual(value, 9)
        }
        
        let pipeline = triple_s -< log <<- stringify_s
        pipeline(3) { _ in }
        
        XCTAssertTrue(didLog)
    }
    
    // ----------------------------------
    //  MARK: - Emitter -
    //
    func testAsyncResultEmitterSuccess() {
        
        var didLog = false
        
        let log: T_ConsumerInt = { value in
            didLog = true
            XCTAssertEqual(value, 7)
        }
        
        let pipeline = createSeven_s -< log <<- stringify_s
        pipeline() { _ in }
        
        XCTAssertTrue(didLog)
    }
    
    func testAsyncResultEmitterFailure() {
        
        var didLog = false
        
        let log: T_ConsumerInt = { value in
            didLog = true
        }
        
        let pipeline = createSeven_f -< log <<- stringify_s
        pipeline() { _ in }
        
        XCTAssertFalse(didLog)
    }
    
    func testResultEmitterSuccess() {
        
        var didLog = false
        
        let log: T_ConsumerInt = { value in
            didLog = true
            XCTAssertEqual(value, 4)
        }
        
        let pipeline = createFour_s -< log <<- stringify_s
        pipeline() { _ in }
        
        XCTAssertTrue(didLog)
    }
    
    func testResultEmitterFailure() {
        
        var didLog = false
        
        let log: T_ConsumerInt = { value in
            didLog = true
        }
        
        let pipeline = createFour_f -< log <<- stringify_s
        pipeline() { _ in }
        
        XCTAssertFalse(didLog)
    }
    
    func testEmitterSuccess() {
        
        var didLog = false
        
        let log: T_ConsumerInt = { value in
            didLog = true
            XCTAssertEqual(value, 6)
        }
        
        let pipeline = createSix_s -< log <<- stringify_s
        pipeline() { _ in }
        
        XCTAssertTrue(didLog)
    }
    
    // ----------------------------------
    //  MARK: - Precedence -
    //
    func testPrecedenceOverExclusive() {
        var didLog = false
        
        let log: T_ConsumerInt = { value in
            didLog = true
            XCTFail()
        }
        
        let pipeline = addTwo_f -< log <-> subtractThree_s
        pipeline(3) { _ in }
        
        XCTAssertFalse(didLog)
    }
}
