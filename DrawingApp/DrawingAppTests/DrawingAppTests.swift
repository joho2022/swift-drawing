//
//  DrawingAppTests.swift
//  DrawingAppTests
//
//  Created by 조호근 on 3/18/24.
//

import XCTest
import os
@testable import DrawingApp

final class DrawingAppTests: XCTestCase {
    private let logger = Logger(subsystem: "pro.DrawingApp.Tests", category: "RectangleFactoryTests")
    private var factory: RectangleFactory!
    
    override func setUp() {
        super.setUp()
        
        self.factory = RectangleFactory()
    }
    
    func test_RectangleFactory() {
        
        let size = Size(width: 150, height: 120)
        let point1 = Point(x: 10, y: 200)
        let rgb1 = RGBColor(red: 245, green: 0, blue: 245)
        let opacity1 = Opacity(value: 7)
        
        let rect = factory.createRectangleModel(size: size, point: point1, backgroundColor: rgb1!, opacity: opacity1!)
        
        XCTAssertEqual(rect.size, size, "Size가 일치하지 않습니다")
        
        logger.info("\(rect.description)")
    }
}
