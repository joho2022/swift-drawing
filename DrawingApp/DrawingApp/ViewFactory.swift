//
//  ViewFactory.swift
//  DrawingApp
//
//  Created by 조호근 on 4/4/24.
//

import UIKit
import os

enum ViewFactory {
    static func createRectangleView(_ data: RectangleModel) {
        let rectModel = data
        let rectView = UIView(frame: CGRect(x: rectModel.point.x, y: rectModel.point.y, width: rectModel.size.width, height: rectModel.size.height))
        rectView.backgroundColor = UIColor(red: CGFloat(rectModel.backgroundColor.red) / 255.0, green: CGFloat(rectModel.backgroundColor.green) / 255.0, blue: CGFloat(rectModel.backgroundColor.blue) / 255.0, alpha: CGFloat(rectModel.opacity.rawValue) / 10.0)
        
        NotificationCenter.default.post(name: .rectangleCreated, object: nil, userInfo: ["rectModel": rectModel, "rectView": rectView])
    }

    static func createImageView(_ data: PhotoModel) {
        let imageView = UIImageView(frame: CGRect(x: data.point.x, y: data.point.y, width: data.size.width, height: data.size.height))
        
        if let image = UIImage(data: data.imageData) {
            imageView.image = image
        }
        imageView.alpha = CGFloat(data.opacity.rawValue) / 10.0
        
        NotificationCenter.default.post(name: .photoSelected, object: nil, userInfo: ["photoModel": data, "photoView": imageView])
    }
    
    static func createLabelView(_ data: Label) {
        let pointX = data.point.x
        let pointY = data.point.y
        let width = data.size.width
        let height = data.size.height
        
        let red = CGFloat(data.backgroundColor.red) / 255.0
        let green = CGFloat(data.backgroundColor.green) / 255.0
        let blue = CGFloat(data.backgroundColor.blue) / 255.0
        let opacity = CGFloat(data.opacity.rawValue) / 10.0
        
        let labelView = UILabel(frame: CGRect(x: pointX, y: pointY, width: width, height: height))
        labelView.text = data.text
        labelView.font = .systemFont(ofSize: 35, weight: .bold)
        labelView.textColor = UIColor(red: red, green: green, blue: blue, alpha: opacity)
        
        NotificationCenter.default.post(name: .labelCreated, object: nil, userInfo: ["labelModel": data, "labelView": labelView])
    }
}
