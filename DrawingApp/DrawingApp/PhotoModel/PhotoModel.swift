//
//  PhotoModel.swift
//  DrawingApp
//
//  Created by 조호근 on 3/25/24.
//

import Foundation

class PhotoModel: VisualComponent {
    private(set) var backgroundColor: RGBColor? = nil
    private(set) var uniqueID: UniqueID
    private(set) var imageData: Data
    private(set) var size : Size
    private(set) var point: Point
    private(set) var opacity: Opacity
    
    init(uniqueID: UniqueID, imageData: Data, size: Size, point: Point, opacity: Opacity) {
        self.uniqueID = uniqueID
        self.imageData = imageData
        self.size = size
        self.point = point
        self.opacity = opacity
    }
    
    func contains(_ point: Point) -> Bool {
        let horizontalRange = self.point.x..<(self.point.x + self.size.width)
        let verticalRange = self.point.y..<(self.point.y + self.size.height)
        
        return horizontalRange.contains(point.x) && verticalRange.contains(point.y)
    }
    
    func setOpacity(_ newOpacity: Opacity) {
        return self.opacity = newOpacity
    }
    
    
    func setPoint(_ newPoint: Point) {
        return self.point = newPoint
    }
}
