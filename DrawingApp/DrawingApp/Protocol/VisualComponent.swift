//
//  VisualComponent.swift
//  DrawingApp
//
//  Created by 조호근 on 3/25/24.
//

import Foundation

protocol VisualComponent {
    var point: Point { get }
    var size: Size { get }
    var backgroundColor: RGBColor? { get }
    var uniqueID: UniqueID { get }
    func contains(_ point: Point) -> Bool
    func setOpacity(_ newOpacity: Opacity)
    func setPoint(_ newPoint: Point)
    func setSize(_ newSize: Size)
}
