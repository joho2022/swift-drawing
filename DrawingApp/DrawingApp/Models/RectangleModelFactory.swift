//
//  RectangleModelFactory.swift
//  DrawingApp
//
//  Created by 조호근 on 3/18/24.
//

import Foundation

protocol RectangleModelFactoryProtocol {
    func createRectangleModel(size: Size, point: Point, backgroundColor: RGBColor, opacity: Opacity) -> RectangleModel
}

class RectangleFactory: RectangleModelFactoryProtocol {
    private let idGenerator = IDGenerator()
    var sequence = 0
    func createRectangleModel(size: Size, point: Point, backgroundColor: RGBColor, opacity: Opacity) -> RectangleModel {
        let uniqueID = idGenerator.generateUniqueRandomID()
        sequence += 1
        return RectangleModel(uniqueID: uniqueID, size: size, point: point, backgroundColor: backgroundColor, opacity: opacity, sequence: sequence)
    }
}
