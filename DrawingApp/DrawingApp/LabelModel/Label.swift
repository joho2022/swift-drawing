//
//  Label.swift
//  DrawingApp
//
//  Created by 조호근 on 3/29/24.
//

import Foundation

class Label: BaseRect, VisualComponent, RectColorful {
    private(set) var text: String
    private(set) var backgroundColor: RGBColor
    
    init(uniqueID: UniqueID, text: String, point: Point, size: Size, backgroundColor: RGBColor, opacity: Opacity) {
        self.text = text
        self.backgroundColor = backgroundColor
        super.init(uniqueID: uniqueID, size: size, point: point, opacity: opacity)
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

extension Label: CustomStringConvertible {
    var description: String {
        return "(\(uniqueID.value)), X:\(point.x),Y:\(point.y), W\(size.width), H:\(size.height), R:\(backgroundColor.red), G:\(backgroundColor.green), B:\(backgroundColor.blue), Alpha: \(opacity.rawValue), text: \(text)"
    }
}
