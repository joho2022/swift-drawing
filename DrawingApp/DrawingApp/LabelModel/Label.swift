//
//  Label.swift
//  DrawingApp
//
//  Created by 조호근 on 3/29/24.
//

import Foundation

class Label: VisualComponent {
    private(set) var uniqueID: UniqueID
    private(set) var text: String
    private(set) var point: Point
    private(set) var size: Size
    private(set) var opacity: Opacity
    private(set) var backgroundColor: RGBColor?
    
    init(uniqueID: UniqueID, text: String, point: Point, size: Size, backgroundColor: RGBColor?, opacity: Opacity) {
        self.uniqueID = uniqueID
        self.text = text
        self.point = point
        self.size = size
        self.backgroundColor = backgroundColor
        self.opacity = opacity
    }
    
    func contains(_ point: Point) -> Bool {
        let horizontalRange = self.point.x..<(self.point.x + self.size.width)
        let verticalRange = self.point.y..<(self.point.y + self.size.height)
        
        return horizontalRange.contains(point.x) && verticalRange.contains(point.y)
    }
    
    func getSize() -> Size {
        return size
    }
    
    func getPoint() -> Point {
        return point
    }
    
    func getColor() -> RGBColor? {
        return backgroundColor
    }
    
    func getUniqueID() -> UniqueID {
        return uniqueID
    }
    
    func setBackgroundColor(_ newColor: RGBColor) {
        return self.backgroundColor = newColor
    }
    
    func setOpacity(_ newOpacity: Opacity) {
        return self.opacity = newOpacity
    }
    
    func setPoint(_ newPoint: Point) {
        return self.point = newPoint
    }
    
    func setSize(_ newSize: Size) {
        return self.size = newSize
    }
}

extension Label: CustomStringConvertible {
    var description: String {
        return "(\(uniqueID.value)), X:\(point.x),Y:\(point.y), W\(size.width), H:\(size.height), R:\(backgroundColor!.red), G:\(backgroundColor!.green), B:\(backgroundColor!.blue), Alpha: \(opacity.rawValue), text: \(text)"
    }
}
