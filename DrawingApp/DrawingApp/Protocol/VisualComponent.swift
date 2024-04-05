//
//  VisualComponent.swift
//  DrawingApp
//
//  Created by 조호근 on 3/25/24.
//

import Foundation

protocol VisualComponent {
    func contains(_ point: Point) -> Bool
}

protocol RectColorful {
    var backgroundColor: RGBColor { get }
    func setBackgroundColor(_ newColor: RGBColor)
}

protocol ObjectDescription {
    var uniqueID : UniqueID { get }
    var titleText : String { get }
    var imageName : String { get }
}

class BaseRect: Hashable {
    private(set) var uniqueID: UniqueID
    private(set) var size: Size
    private(set) var point: Point
    private(set) var opacity: Opacity
    private(set) var sequence: Int
    
    init(uniqueID: UniqueID, size: Size, point: Point, opacity: Opacity, sequence: Int = 1) {
        self.uniqueID = uniqueID
        self.size = size
        self.point = point
        self.opacity = opacity
        self.sequence = sequence
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
    
    static func == (lhs: BaseRect, rhs: BaseRect) -> Bool {
        return lhs.uniqueID == rhs.uniqueID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uniqueID)
    }
}
