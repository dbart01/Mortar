//
//  CompositionalTests.swift
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

class CompositionalTests: XCTestCase {
    
    // ----------------------------------
    //  MARK: - Async Map -
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
    
    func testAsyncToMapSuccess() {
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
    
    func testAsyncToMapFailure() {
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
    //  MARK: - Result Map -
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
    
    func testSyncToMapSuccess() {
        let pipeline = double_s <<- triple_s
        
        switch pipeline(2) {
        case .success(let value):
            XCTAssertEqual(value, 12)
        case .failure:
            XCTFail()
        }
    }
    
    func testSyncToMapFailure() {
        let pipeline = double_f <<- triple_s
        
        switch pipeline(2) {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, .generic)
        }
    }
    
    // ----------------------------------
    //  MARK: - Map -
    //
    func testMapToMap() {
        let pipeline = triple_s <<- triple_s
        
        XCTAssertEqual(pipeline(2), 18)
    }
    
    func testMapToSync() {
        let pipeline = triple_s <<- double_s
        
        switch pipeline(2) {
        case .success(let value):
            XCTAssertEqual(value, 12)
        case .failure:
            XCTFail()
        }
    }
    
    func testMapToAsync() {
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
    //  MARK: - Emitter -
    //
    func testEmitterToAsync() {
        let pipeline = createSix_s <<- addTwo_s
        
        pipeline() { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 8)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testEmitterToSyncSuccess() {
        let pipeline = createSix_s <<- double_s
        
        switch pipeline() {
        case .success(let value):
            XCTAssertEqual(value, 12)
        case .failure:
            XCTFail()
        }
    }
    
    func testEmitterToMapSuccess() {
        let pipeline = createSix_s <<- triple_s
        
        let value = pipeline()
        XCTAssertEqual(value, 18)
    }
    
    // ----------------------------------
    //  MARK: - Result Emitter -
    //
    func testResultEmitterToAsyncSuccess() {
        let pipeline = createFive_s <<- addTwo_s
        
        pipeline() { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 7)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testResultEmitterToAsyncFailure() {
        let pipeline = createFive_f <<- addTwo_s
        
        pipeline() { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .generic)
            }
        }
    }
    
    func testResultEmitterToSyncSuccess() {
        let pipeline = createFive_s <<- double_s
        
        switch pipeline() {
        case .success(let value):
            XCTAssertEqual(value, 10)
        case .failure:
            XCTFail()
        }
    }
    
    func testResultEmitterToSyncFailure() {
        let pipeline = createFive_f <<- double_f
        
        switch pipeline() {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, .generic)
        }
    }
    
    func testResultEmitterToMapSuccess() {
        let pipeline = createFive_s <<- triple_s
        
        switch pipeline() {
        case .success(let value):
            XCTAssertEqual(value, 15)
        case .failure:
            XCTFail()
        }
    }
    
    func testResultEmitterToMapFailure() {
        let pipeline = createFive_f <<- triple_s
        
        switch pipeline() {
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error, .generic)
        }
    }
    
    // ----------------------------------
    //  MARK: - Async Result Emitter -
    //
    func testAsyncResultEmitterToAsyncSuccess() {
        let pipeline = createSeven_s <<- addTwo_s
        
        pipeline() { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 9)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testAsyncResultEmitterToAsyncFailure() {
        let pipeline = createSeven_f <<- addTwo_s
        
        pipeline() { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .generic)
            }
        }
    }
    
    func testAsyncResultEmitterToSyncSuccess() {
        let pipeline = createSeven_s <<- double_s
        
        pipeline() { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 14)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testAsyncResultEmitterToSyncFailure() {
        let pipeline = createSeven_f <<- double_s
        
        pipeline() { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .generic)
            }
        }
    }
    
    func testAsyncResultEmitterToMapSuccess() {
        let pipeline = createSeven_s <<- triple_s
        
        pipeline() { result in
            switch result {
            case .success(let value):
                XCTAssertEqual(value, 21)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testAsyncResultEmitterToMapFailure() {
        let pipeline = createSeven_f <<- triple_s
        
        pipeline() { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .generic)
            }
        }
    }
}
