//
//  NSPasteboardTests.swift
//  cuImage
//
//  Created by HuLizhen on 20/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import XCTest
@testable import cuImage

class NSPasteboardTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        let urlString = "http://test_url_string.jpeg"
        var strings = [String]()
        for i in 0..<10 {
            let string = urlString + "\(i)"
            strings.append(string)
        }

        NSPasteboard.general().addURLStrings(strings, markdown: true)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
