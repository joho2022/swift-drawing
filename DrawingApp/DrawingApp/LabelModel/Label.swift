//
//  Label.swift
//  DrawingApp
//
//  Created by 조호근 on 3/29/24.
//

import Foundation

class Label: BaseRect, VisualComponent, RectColorful, ObjectDescription {
    private(set) var text: String
    private(set) var backgroundColor: RGBColor
    
    init(uniqueID: UniqueID, text: String, point: Point, size: Size, backgroundColor: RGBColor, opacity: Opacity, sequence: Int = 1) {
        self.text = text
        self.backgroundColor = backgroundColor
        super.init(uniqueID: uniqueID, size: size, point: point, opacity: opacity, sequence: sequence)
    }
    
    var titleText: String {
        return "Text \(sequence)"
    }
    
    var imageName: String {
        return "textformat"
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
        return "(\(self.hashValue)), X:\(point.x),Y:\(point.y), W\(size.width), H:\(size.height), R:\(backgroundColor.red), G:\(backgroundColor.green), B:\(backgroundColor.blue), Alpha: \(opacity.rawValue), text: \(text), sequence: \(sequence)"
    }
}
