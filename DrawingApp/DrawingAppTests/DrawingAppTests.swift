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
        let opacity1 = Opacity(value: 9)
        
        let rectangleModel = factory.createRectangleModel(size: size, point: point1, backgroundColor: rgb1!, opacity: opacity1!)
        
        XCTAssertNotNil(rectangleModel, "모델 객체 생성 실패")
        XCTAssertEqual(rectangleModel.testable_size, size, "Size 속성 값 불일치")
        XCTAssertEqual(rectangleModel.testable_point, point1, "Point 속성 값 불일치")
        XCTAssertEqual(rectangleModel.testable_backgroundColor, rgb1, "rgb 속성 값 불일치")
        XCTAssertEqual(rectangleModel.testable_opacity, opacity1, "Size 속성 값 불일치")
        
        logger.info("\(rectangleModel.description)")
    }

}
