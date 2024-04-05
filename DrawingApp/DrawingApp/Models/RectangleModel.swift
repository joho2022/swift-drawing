//
//  RectangleModel.swift
//  DrawingApp
//
//  Created by 조호근 on 3/18/24.
//

import Foundation

class RectangleModel: BaseRect, VisualComponent, RectColorful, ObjectDescription {
    
    private(set) var backgroundColor: RGBColor
    
    init(uniqueID: UniqueID, size: Size, point: Point, backgroundColor: RGBColor, opacity: Opacity, sequence: Int = 1) {
        self.backgroundColor = backgroundColor
        super.init(uniqueID: uniqueID, size: size, point: point, opacity: opacity, sequence: sequence)
    }
    
    
    var titleText: String {
        return "Rect \(self.sequence)"
    }
    
    var imageName: String {
        return "rectangle"
    }
    
    func getUniqueID() -> UniqueID {
        return uniqueID
    }
    
    func contains(_ point: Point) -> Bool {
        let horizontalRange = self.point.x..<(self.point.x + self.size.width)
        let verticalRange = self.point.y..<(self.point.y + self.size.height)
        
        return horizontalRange.contains(point.x) && verticalRange.contains(point.y)
    }
    
    func setBackgroundColor(_ newColor: RGBColor) {
        return self.backgroundColor = newColor
    }
}

extension RectangleModel: CustomStringConvertible {
    var description: String {
        return "(\(uniqueID.value)), X:\(point.x),Y:\(point.y), W\(size.width), H:\(size.height), R:\(backgroundColor.red), G:\(backgroundColor.green), B:\(backgroundColor.blue), Alpha: \(opacity.rawValue), sequence: \(sequence)"
    }
}
