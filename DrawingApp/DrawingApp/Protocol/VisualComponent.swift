//
//  VisualComponent.swift
//  DrawingApp
//
//  Created by 조호근 on 3/25/24.
//

import Foundation

protocol VisualComponent {
    func getSize() -> Size
    func getPoint() -> Point
    func getColor() -> RGBColor?
    func getUniqueID() -> UniqueID
    func contains(_ point: Point) -> Bool
    func setOpacity(_ newOpacity: Opacity)
    func setPoint(_ newPoint: Point)
    func setSize(_ newSize: Size)
}

extension VisualComponent where Self: Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.getUniqueID() == rhs.getUniqueID()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(getUniqueID())
    }
}
