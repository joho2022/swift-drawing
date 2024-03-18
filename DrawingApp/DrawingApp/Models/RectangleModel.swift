//
//  RectangleModel.swift
//  DrawingApp
//
//  Created by 조호근 on 3/18/24.
//

import Foundation

class RectangleModel {
    private let uniqueID: String
    private var size: Size
    private var point: Point
    private var backgroundColor: RGBColor
    private var opacity: Int

    init(uniqueID: String, size: Size, point: Point, backgroundColor: RGBColor, opacity: Int) {
        self.uniqueID = uniqueID
        self.size = size
        self.point = point
        self.backgroundColor = backgroundColor
        self.opacity = max(1, min(10, opacity))
    }
}

extension RectangleModel: CustomStringConvertible {
    var description: String {
        return "(\(uniqueID)), X:\(point.x),Y:\(point.y), W\(size.width), H:\(size.height), R:\(backgroundColor.red), G:\(backgroundColor.green), B:\(backgroundColor.blue), Alpha: \(opacity)"
    }
}
