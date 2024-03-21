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
    private var plane: Plane!
    
    override func setUp() {
        super.setUp()
        
        self.factory = RectangleFactory()
        self.plane = Plane()
    }
    
    func createTestRectangleModel() -> RectangleModel {
        let size = Size(width: 150, height: 120)
        let point = Point(x: 10, y: 200)
        let rgb = RGBColor(red: 245, green: 0, blue: 245)
        let opacity = Opacity(value: 7)
        return factory.createRectangleModel(size: size, point: point, backgroundColor: rgb!, opacity: opacity!)
    }
    
    func test_RectangleFactory() {
        let size = Size(width: 150, height: 120)
        let rect = createTestRectangleModel()
        
        XCTAssertEqual(rect.size, size, "Size가 일치하지 않습니다")
        
        logger.info("\(rect.description)")
    }
    
    func test_AddRectangle() {
        let rect = createTestRectangleModel()
        plane.addRectangle(rect)
        
        XCTAssertEqual(plane.totalRectangles, 1)
    }
    
    func test_RectangleSubscript() {
        let rect = createTestRectangleModel()
        let rect1 = createTestRectangleModel()
        plane.addRectangle(rect)
        plane.addRectangle(rect1)
        
        let result = plane[0]
        
        XCTAssertNotNil(result)
        logger.info("\(self.plane.rectangles)")
    }
    
    func test_RectangleAtPoint() {
        let rect = createTestRectangleModel()
        plane.addRectangle(rect)
        
        let result = plane.rectangle(at: Point(x: 20, y: 310))
        
        XCTAssertNotNil(result)
    }
    
    func test_RectangleNotAtPoint() {
        let rect = createTestRectangleModel()
        plane.addRectangle(rect)
        
        let result = plane.rectangle(at: Point(x: 0, y: 0))
        
        XCTAssertNil(result)
    }
}
