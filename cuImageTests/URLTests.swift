//
//  URLTests.swift
//  cuImage
//
//  Created by Lizhen Hu on 15/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import XCTest
@testable import cuImage

class URLTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Copy one or more image files onto the general pasteboard.
    func testImageFileExtension() {
        let pasteboard = NSPasteboard.general()
        let classes: [AnyClass] = [NSImage.self, NSURL.self]
        let options: [String : Any]? = nil
        guard pasteboard.canReadObject(forClasses: classes, options: options) else { return }
        guard let objects = pasteboard.readObjects(forClasses: classes, options: options) else { return }
        
        for object in objects {
            if let url = object as? URL {
                print("[Path: \(url), Extension: \(url.imageFileExtension() ?? "")]")
            }
        }
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

}
