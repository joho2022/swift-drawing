//
//  RectangleModel.swift
//  DrawingApp
//
//  Created by 조호근 on 3/18/24.
//

import Foundation

class RectangleModel {
    private let uniqueID: UniqueID
    private(set) var size: Size
    private(set) var point: Point
    private(set) var backgroundColor: RGBColor
    private(set) var opacity: Opacity
    
    init(uniqueID: UniqueID, size: Size, point: Point, backgroundColor: RGBColor, opacity: Opacity) {
        self.uniqueID = uniqueID
        self.size = size
        self.point = point
        self.backgroundColor = backgroundColor
        self.opacity = opacity
    }
}

extension RectangleModel: CustomStringConvertible {
    var description: String {
        return "(\(uniqueID.value)), X:\(point.x),Y:\(point.y), W\(size.width), H:\(size.height), R:\(backgroundColor.red), G:\(backgroundColor.green), B:\(backgroundColor.blue), Alpha: \(opacity.rawValue)"
    }
}
