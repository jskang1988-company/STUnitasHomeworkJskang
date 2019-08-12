//
//  STUnitasImageSearcherTests.swift
//  STUnitasImageSearcherTests
//
//  Created by 강진석 on 12/08/2019.
//  Copyright © 2019 jskang. All rights reserved.
//

import XCTest
import STUnitasImageSearcher

class STUnitasImageSearcherTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testMainViewController() {
        let obj = MainViewController()
        XCTAssert(obj.calculatePageStartIndex(currentPageIndex: 1, maxNumOfItemsPerPage: 20) == 20)
        XCTAssert(obj.calculatePageStartIndex(currentPageIndex: 2, maxNumOfItemsPerPage: 20) == 40)
        XCTAssert(obj.calculatePageStartIndex(currentPageIndex: 3, maxNumOfItemsPerPage: 20) == 60)
        
        XCTAssert(obj.calculatePageEndIndex(startIndex: 20, maxNumOfItemsPerPage: 20, documentCount: 40) == 39)
        XCTAssert(obj.calculatePageEndIndex(startIndex: 20, maxNumOfItemsPerPage: 20, documentCount: 39) == 38)
        XCTAssert(obj.calculatePageEndIndex(startIndex: 20, maxNumOfItemsPerPage: 20, documentCount: 21) == 20)
        
        XCTAssert(obj.calculatePageEndIndex(startIndex: 40, maxNumOfItemsPerPage: 20, documentCount: 60) == 59)
        XCTAssert(obj.calculatePageEndIndex(startIndex: 40, maxNumOfItemsPerPage: 20, documentCount: 59) == 58)
        XCTAssert(obj.calculatePageEndIndex(startIndex: 40, maxNumOfItemsPerPage: 20, documentCount: 41) == 40)
    }
    
    

}
