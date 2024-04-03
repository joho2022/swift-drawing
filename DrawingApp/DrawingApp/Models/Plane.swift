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
    static let labelCreated = Notification.Name("Plane.labelCreated")
    static let rectangleCreated = Notification.Name("Plane.rectangleCreated")
    static let rectangleColorChanged = Notification.Name("Plane.rectangleColorChanged")
    static let opacityChanged = Notification.Name("Plane.opacityChanged")
    static let pointUpdated = Notification.Name("Plane.pointUpdated")
    static let sizeUpdated = Notification.Name("Plane.sizeUpdate")
    static let photoSelected = Notification.Name("Plane.photoSelected")
    static let photoOpacityChanged = Notification.Name("Plane.photoOpacityChanged")
}

struct Plane: Updatable {
    private let logger = os.Logger(subsystem: "pro.DrawingApp.model", category: "Plane")
    private(set) var rectangles = [RectangleModel]()
    private(set) var photos = [PhotoModel]()
    private(set) var labels = [Label]()
    
    var totalRectangles: Int {
        return rectangles.count
    }
    
    subscript(index: Int) -> RectangleModel? {
        guard index >= 0 && index < rectangles.count else { return nil }
        return rectangles[index]
    }
    
    func createRectangleView(_ data: RectangleModel) {
        let rectModel = data
        let rectView = UIView(frame: CGRect(x: rectModel.point.x, y: rectModel.point.y, width: rectModel.size.width, height: rectModel.size.height))
        rectView.backgroundColor = UIColor(red: CGFloat(rectModel.backgroundColor!.red) / 255.0, green: CGFloat(rectModel.backgroundColor!.green) / 255.0, blue: CGFloat(rectModel.backgroundColor!.blue) / 255.0, alpha: CGFloat(rectModel.opacity.rawValue) / 10.0)
        
        logger.info("사각형 생성 명령하달!!")
        NotificationCenter.default.post(name: .rectangleCreated, object: nil, userInfo: ["rectModel": rectModel, "rectView": rectView])
    }
    
    mutating func addRectangle(_ rectangle: RectangleModel) {
        rectangles.append(rectangle)
    }
    
    func createLabelView(_ data: Label) {
        let pointX = data.point.x
        let pointY = data.point.y
        let width = data.size.width
        let height = data.size.height
        
        let red = CGFloat(data.backgroundColor!.red) / 255.0
        let green = CGFloat(data.backgroundColor!.green) / 255.0
        let blue = CGFloat(data.backgroundColor!.blue) / 255.0
        let opacity = CGFloat(data.opacity.rawValue) / 10.0
        
        let labelView = UILabel(frame: CGRect(x: pointX, y: pointY, width: width, height: height))
        labelView.text = data.text
        labelView.font = .systemFont(ofSize: 35, weight: .bold)
        labelView.textColor = UIColor(red: red, green: green, blue: blue, alpha: opacity)
        logger.info("텍스트 생성 명령하달!!")
        NotificationCenter.default.post(name: .labelCreated, object: nil, userInfo: ["labelModel": data, "labelView": labelView])
    }
    
    mutating func addLabel(_ label: Label) {
        labels.append(label)
        print("텍스트 생성!!!! \(labels)")
    }
    
    mutating func updateRectangleColor(uniqueID: UniqueID) {
        let randomColor = getRandomColor()
        
        if let index = rectangles.firstIndex(where: { $0.uniqueID == uniqueID }) {
            rectangles[index].setBackgroundColor(randomColor)
            
            self.logger.info("사각형 배경색 변경 명령하달!")
            NotificationCenter.default.post(name: .rectangleColorChanged, object: nil, userInfo: ["selectedModel": rectangles[index], "randomColor": randomColor])
        } else if let index = labels.firstIndex(where: { $0.uniqueID == uniqueID }) {
            self.logger.info("라벨 배경색 변경 명령하달!")
            labels[index].setBackgroundColor(randomColor)
            NotificationCenter.default.post(name: .rectangleColorChanged, object: nil, userInfo: ["selectedModel": labels[index], "randomColor": randomColor])
        }
    }
    
    mutating func updatePoint(uniqueID: UniqueID, point: Point) {
        if let index = rectangles.firstIndex(where: { $0.uniqueID == uniqueID }) {
            rectangles[index].setPoint(point)
            NotificationCenter.default.post(name: .pointUpdated, object: nil, userInfo: ["selectedModel": rectangles[index], "point": point])
        } else if let index = photos.firstIndex(where: { $0.uniqueID == uniqueID }) {
            photos[index].setPoint(point)
            NotificationCenter.default.post(name: .pointUpdated, object: nil, userInfo: ["selectedModel": photos[index], "point": point])
        } else if let index = labels.firstIndex(where: { $0.uniqueID == uniqueID }) {
            labels[index].setPoint(point)
            NotificationCenter.default.post(name: .pointUpdated, object: nil, userInfo: ["selectedModel": labels[index], "point": point])
        }
    }
    
    mutating func updateSize(uniqueID: UniqueID, size: Size) {
        if let index = rectangles.firstIndex(where: { $0.uniqueID == uniqueID }) {
            rectangles[index].setSize(size)
            NotificationCenter.default.post(name: .sizeUpdated, object: nil, userInfo: ["selectedModel": rectangles[index], "size": size])
        } else if let index = photos.firstIndex(where: { $0.uniqueID == uniqueID }) {
            photos[index].setSize(size)
            NotificationCenter.default.post(name: .sizeUpdated, object: nil, userInfo: ["selectedModel": photos[index], "size": size])
        } else if let index = labels.firstIndex(where: { $0.uniqueID == uniqueID }) {
            labels[index].setSize(size)
            NotificationCenter.default.post(name: .sizeUpdated, object: nil, userInfo: ["selectedModel": labels[index], "size": size])
        }
    }
    
    mutating func updateOpacity(uniqueID: UniqueID, opacity: Opacity) {
        if let index = rectangles.firstIndex(where: { $0.uniqueID == uniqueID }) {
            rectangles[index].setOpacity(opacity)
            self.logger.info("사각형의 투명도 변경 명령하달!")
            NotificationCenter.default.post(name: .opacityChanged, object: nil, userInfo: ["selectedModel": rectangles[index], "opacity": opacity])
        } else if let index = photos.firstIndex(where: { $0.uniqueID == uniqueID }) {
            photos[index].setOpacity(opacity)
            self.logger.info("사진의 투명도 변경 명령하달!")
            NotificationCenter.default.post(name: .opacityChanged, object: nil, userInfo: ["selectedModel": photos[index], "opacity": opacity])
        } else if let index = labels.firstIndex(where: { $0.uniqueID == uniqueID }) {
            labels[index].setOpacity(opacity)
            self.logger.info("텍스트 투명도 변경 명령하달!")
            NotificationCenter.default.post(name: .opacityChanged, object: nil, userInfo: ["selectedModel": labels[index], "opacity": opacity])
        }
    }
    
    private func getRandomColor() -> RGBColor {
        let randomColor = RGBColor(red: Int.random(in: 0...255), green: Int.random(in: 0...255), blue: Int.random(in: 0...255))!
        return randomColor
    }
}

extension Plane {
    func hasComponent(at point: Point) -> VisualComponent? {
        if let rect = rectangles.first(where: { $0.contains(point) }) {
            return rect
        } else if let photo = photos.first(where: { $0.contains(point) }) {
            return photo
        } else if let label = labels.first(where: { $0.contains(point) }) {
            return label
        } else {
            return nil
        }
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
