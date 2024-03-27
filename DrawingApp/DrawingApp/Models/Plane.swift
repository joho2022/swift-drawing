//
//  Plane.swift
//  DrawingApp
//
//  Created by 조호근 on 3/19/24.
//

import Foundation
import UIKit
import os

extension Notification.Name {
    static let rectangleCreated = Notification.Name("Plane.rectangleCreated")
    static let rectangleColorChanged = Notification.Name("Plane.rectangleColorChanged")
    static let opacityChanged = Notification.Name("Plane.opacityChanged")
    static let pointUpdated = Notification.Name("Plane.pointUpdated")
    static let photoSelected = Notification.Name("Plane.photoSelected")
    static let photoOpacityChanged = Notification.Name("Plane.photoOpacityChanged")
}

struct Plane: Updatable {
    private let logger = os.Logger(subsystem: "pro.DrawingApp.model", category: "Plane")
    private(set) var rectangles = [RectangleModel]()
    private(set) var photos = [PhotoModel]()
    
    var totalRectangles: Int {
        return rectangles.count
    }
    
    subscript(index: Int) -> RectangleModel? {
        guard index >= 0 && index < rectangles.count else { return nil }
        return rectangles[index]
    }
    
    func hasRectangle(at point: Point) -> RectangleModel? {
        for rectangle in rectangles {
            if rectangle.contains(point) {
                return rectangle
            }
        }
        return nil
    }
    
    func createRectangleView(_ data: RectangleModel) {
        let rectModel = data
        let rectView = UIView(frame: CGRect(x: rectModel.point.x, y: rectModel.point.y, width: rectModel.size.width, height: rectModel.size.height))
        rectView.backgroundColor = UIColor(red: CGFloat(rectModel.backgroundColor.red) / 255.0, green: CGFloat(rectModel.backgroundColor.green) / 255.0, blue: CGFloat(rectModel.backgroundColor.blue) / 255.0, alpha: CGFloat(rectModel.opacity.rawValue) / 10.0)
        
        logger.info("사각형 생성 명령하달!!")
        NotificationCenter.default.post(name: .rectangleCreated, object: nil, userInfo: ["rectModel": rectModel, "rectView": rectView])
        
    }
    
    mutating func addRectangle(_ rectangle: RectangleModel) {
        rectangles.append(rectangle)
    }
    
    mutating func updateRectangleColor(uniqueID: UniqueID) {
        let randomColor = getRandomColor()
        
        if let index = rectangles.firstIndex(where: { $0.uniqueID == uniqueID }) {
            rectangles[index].setBackgroundColor(randomColor)
            
            self.logger.info("배경색 변경 명령하달!")
            NotificationCenter.default.post(name: .rectangleColorChanged, object: nil, userInfo: ["uniqueID": uniqueID, "randomColor": randomColor])
        }
    }
    
    mutating func updatePoint(uniqueID: UniqueID, point: Point) {
        if let index = rectangles.firstIndex(where: { $0.uniqueID == uniqueID }) {
            rectangles[index].setPoint(point)
            NotificationCenter.default.post(name: .pointUpdated, object: nil, userInfo: ["uniqueID": uniqueID, "point": point])
        } else if let index = photos.firstIndex(where: { $0.uniqueID == uniqueID }) {
            photos[index].setPoint(point)
            NotificationCenter.default.post(name: .pointUpdated, object: nil, userInfo: ["uniqueID": uniqueID, "point": point])
        }
        
    }
    
    mutating func updateOpacity(uniqueID: UniqueID, opacity: Opacity) {
        if let index = rectangles.firstIndex(where: { $0.uniqueID == uniqueID }) {
            rectangles[index].setOpacity(opacity)
            self.logger.info("사각형의 투명도 변경 명령하달!")
            NotificationCenter.default.post(name: .opacityChanged, object: nil, userInfo: ["uniqueID": uniqueID, "opacity": opacity])
        } else if let index = photos.firstIndex(where: { $0.uniqueID == uniqueID }) {
            photos[index].setOpacity(opacity)
            self.logger.info("사진의 투명도 변경 명령하달!")
            NotificationCenter.default.post(name: .opacityChanged, object: nil, userInfo: ["uniqueID": uniqueID, "opacity": opacity])
        }
    }
    
    func findRectangle(uniqueID: String) -> RectangleModel? {
        guard let index = rectangles.firstIndex(where: { $0.uniqueID.value == uniqueID }) else {
            return nil
        }
        return rectangles[index]
    }
    
    private func getRandomColor() -> RGBColor {
        let randomColor = RGBColor(red: Int.random(in: 0...255), green: Int.random(in: 0...255), blue: Int.random(in: 0...255))!
        return randomColor
    }
}

extension Plane {
    func photo(at point: Point) -> PhotoModel? {
        for photo in photos {
            if photo.contains(point) {
                return photo
            }
        }
        return nil
    }
    
    mutating func addPhoto(_ photo: PhotoModel) {
        return photos.append(photo)
    }
    
    func createImageView(_ data: PhotoModel) {
        let imageView = UIImageView(frame: CGRect(x: data.point.x, y: data.point.y, width: data.size.width, height: data.size.height))
        
        if let image = UIImage(data: data.imageData) {
            imageView.image = image
        }
        imageView.alpha = CGFloat(data.opacity.rawValue) / 10.0
        
        NotificationCenter.default.post(name: .photoSelected, object: nil, userInfo: ["photoModel": data, "photoView": imageView])
    }
}
