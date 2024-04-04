//
//  PhotoModel.swift
//  DrawingApp
//
//  Created by 조호근 on 3/25/24.
//

import Foundation

class PhotoModel: BaseRect, VisualComponent  {
    private(set) var imageData: Data
    
    init(uniqueID: UniqueID, imageData: Data, size: Size, point: Point, opacity: Opacity) {
        self.imageData = imageData
        super.init(uniqueID: uniqueID, size: size, point: point, opacity: opacity)
    }
    
    func getUniqueID() -> UniqueID {
        return uniqueID
    }
    
    func contains(_ point: Point) -> Bool {
        let horizontalRange = self.point.x..<(self.point.x + self.size.width)
        let verticalRange = self.point.y..<(self.point.y + self.size.height)
        
        return horizontalRange.contains(point.x) && verticalRange.contains(point.y)
    }
}

extension PhotoModel: CustomStringConvertible {
    var description: String {
        return "(\(uniqueID.value)), imageData:\(imageData) X:\(point.x),Y:\(point.y), W\(size.width), H:\(size.height), Alpha: \(opacity.rawValue)"
    }
}

