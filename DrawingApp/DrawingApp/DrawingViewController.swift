//
//  DrawingViewController.swift
//  DrawingApp
//
//  Created by 조호근 on 3/18/24.
//

import UIKit
import os

class DrawingViewController: UIViewController {

    private let logger = os.Logger(subsystem: "pro.DrawingApp.model", category: "ModelLogging")
    
    private let factory = RectangleFactory()
    private let size = Size(width: 150, height: 120)
    
    private let point1 = Point(x: 10, y: 200)
    private let point2 = Point(x: 110, y: 180)
    private let point3 = Point(x: 590, y: 90)
    private let point4 = Point(x: 330, y: 450)
    
    private let rgb1 = RGBColor(red: 245, green: 0, blue: 245)
    private let rgb2 = RGBColor(red: 43, green: 124, blue: 95)
    private let rgb3 = RGBColor(red: 98, green: 244, blue: 15)
    private let rgb4 = RGBColor(red: 125, green: 39, blue: 99)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        
        let rect1 = factory.createRectangleModel(size: size,
                                                 point: point1,
                                                 backgroundColor: rgb1,
                                                 opacity: 9)
        logger.log(level: .info, "Rect1 \(rect1.description)")
        
        
        let rect2 = factory.createRectangleModel(size: size,
                                                 point: point2,
                                                 backgroundColor: rgb2,
                                                 opacity: 5)
        logger.log(level: .info, "Rect2 \(rect2.description)")
        
        let rect3 = factory.createRectangleModel(size: size,
                                                 point: point3,
                                                 backgroundColor: rgb3,
                                                 opacity: 7)
        logger.log(level: .info, "Rect3 \(rect3.description)")
        
        let rect4 = factory.createRectangleModel(size: size,
                                                 point: point4,
                                                 backgroundColor: rgb4,
                                                 opacity: 1)
        logger.log(level: .info, "Rect4 \(rect4.description)")
        
    }


}

