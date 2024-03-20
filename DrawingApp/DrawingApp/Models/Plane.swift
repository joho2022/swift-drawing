//
//  Plane.swift
//  DrawingApp
//
//  Created by 조호근 on 3/19/24.
//

import Foundation

struct Plane {
    private(set) var rectangles = [RectangleModel]()
    
    mutating func addRectangle(_ rectangle: RectangleModel) {
        rectangles.append(rectangle)
    }
    
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
}
