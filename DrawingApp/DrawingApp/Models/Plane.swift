//
//  Plane.swift
//  DrawingApp
//
//  Created by 조호근 on 3/19/24.
//

import Foundation
import UIKit
import os

struct Plane {
    private let logger = os.Logger(subsystem: "pro.DrawingApp.model", category: "Plane")
    private(set) var rectangles = [RectangleModel]()
    
    var totalRectangles: Int {
        return rectangles.count
    }
    
    subscript(index: Int) -> RectangleModel? {
        guard index >= 0 && index < rectangles.count else { return nil }
        return rectangles[index]
    }
    
    func rectangle(at point: Point) -> RectangleModel? {
        for rectangle in rectangles {
            if rectangle.contains(point) {
                return rectangle
            }
        }
        return nil
    }
    
    mutating func createRectangleData() -> RectangleModel {
        let mainViewController = MainViewController()
        let factory = RectangleFactory()
        
        let size = Size(width: 150.0, height: 120.0)
        let subViewWidth = 200.0
        let randomPoint = Point(x: Double.random(in: 0...(mainViewController.view.bounds.width - size.width - subViewWidth)), y: Double.random(in: 0...(mainViewController.view.bounds.height - size.height)))
        let randomColor = RGBColor(red: Int.random(in: 0...255), green: Int.random(in: 0...255), blue: Int.random(in: 0...255))!
        let opacity = Opacity(value: 10)!
        
        let rect = factory.createRectangleModel(size: size, point: randomPoint, backgroundColor: randomColor, opacity: opacity)
        
        addRectangle(rect)
        
        return rect
    }
    
    func createRectangleView(_ data: RectangleModel) -> UIView {
        let rectView = UIView(frame: CGRect(x: data.point.x, y: data.point.y, width: data.size.width, height: data.size.height))
        rectView.backgroundColor = UIColor(red: CGFloat(data.backgroundColor.red) / 255.0, green: CGFloat(data.backgroundColor.green) / 255.0, blue: CGFloat(data.backgroundColor.blue) / 255.0, alpha: CGFloat(data.opacity.rawValue) / 10.0)
        
        return rectView
    }
    
    private mutating func addRectangle(_ rectangle: RectangleModel) {
        rectangles.append(rectangle)
    }
    
    mutating func updateRectangleColor(uniqueID: String) {
        let randomColor = getRandomColor()
        
        if let index = rectangles.firstIndex(where: { $0.uniqueID.value == uniqueID }) {
            rectangles[index].setBackgroundColor(randomColor)
            
            self.logger.info("배경색 변경 명령하달!")
            NotificationCenter.default.post(name: .rectangleColorChanged, object: nil, userInfo: ["uniqueID": uniqueID, "randomColor": randomColor])
        }
    }
    
    mutating func updateRectangleOpacity(uniqueID: String, opacity: Opacity) {
        if let index = rectangles.firstIndex(where: { $0.uniqueID.value == uniqueID }) {
            rectangles[index].setOpacity(opacity)
            self.logger.info("투명도 변경 명령하달!")
            NotificationCenter.default.post(name: .rectangleOpacityChanged, object: nil, userInfo: ["uniqueID": uniqueID, "opacity": opacity])
        }
    }
    
    func findRectangle(uniqueID: String) -> RectangleModel? {
        guard let index = rectangles.firstIndex(where: { $0.uniqueID.value == uniqueID }) else {
            return nil
        }
        return rectangles[index]
    }
    
    private func getRandomColor() -> RGBColor {
        let randomColor = RGBColor(red: Int.random(in: 0...255), green: Int.random(in: 0...255), blue: Int.random(in: 0...255))!
        return randomColor
    }
}
