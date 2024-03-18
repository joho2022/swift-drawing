//
//  RectangleModelFactory.swift
//  DrawingApp
//
//  Created by 조호근 on 3/18/24.
//

import Foundation

protocol RectangleModelFactoryProtocol {
    func createRectangleModel(size: Size, point: Point, backgroundColor: RGBColor, opacity: Int) -> RectangleModel
}

class RectangleFactory: RectangleModelFactoryProtocol {
    func createRectangleModel(size: Size, point: Point, backgroundColor: RGBColor, opacity: Int) -> RectangleModel {
        let uniqueID = generateRandomID()
        return RectangleModel(uniqueID: uniqueID, size: size, point: point, backgroundColor: backgroundColor, opacity: opacity)
    }
    
    private func generateRandomID() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyz0123456789"
        var segments = [String]()
        
        for _ in 0..<3 {
            let segment = (0..<3).map { _ in characters.randomElement()! }
            segments.append(String(segment))
        }

        return segments.joined(separator: "-")
    }
}
