//
//  MainViewController.swift
//  DrawingApp
//
//  Created by 조호근 on 3/20/24.
//

import UIKit
import os
import SnapKit

class MainViewController: UIViewController {
    private let logger = os.Logger(subsystem: "pro.DrawingApp.model", category: "Main")
    private var selectedRectangleView: UIView?
    
    private let factory = RectangleFactory()
    private var plane = Plane()
    
    private let drawableButtonStack = DrawableButtonStack()
    private let settingsPanelViewController = SettingsPanelViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let settingsFrame = view.bounds.with(width: 200)
        addChild(settingsPanelViewController, settingsFrame)

        setupOpacityAction()
        setupBackgroundAction()
        setupView()
    }
    
    private func addChild(_ child: UIViewController, _ frame: CGRect) {
        addChild(child)
        child.view.frame = frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}

extension MainViewController {
    func setupView() {
        [ drawableButtonStack ].forEach { view.addSubview($0) }
        
        drawableButtonStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(100)
            $0.width.equalTo(300)
        }
        
        drawableButtonStack.setRectangleButtonAction(#selector(rectangleButtonTapped), target: self)
        
        drawableButtonStack.setPhotoButtonAction(#selector(photoButtonTapped), target: self)
    }
    
    @objc private func rectangleButtonTapped() {
        let size = Size(width: 150.0, height: 120.0)
        let subViewWidth = settingsPanelViewController.view.bounds.width
        let randomPoint = Point(x: Double.random(in: 0...(view.bounds.width - size.width - subViewWidth)), y: Double.random(in: 0...(view.bounds.height - size.height)))
        let randomColor = RGBColor(red: Int.random(in: 0...255), green: Int.random(in: 0...255), blue: Int.random(in: 0...255))!
        let opacity = Opacity(value: 10)!
        
        let rect = factory.createRectangleModel(size: size, point: randomPoint, backgroundColor: randomColor, opacity: opacity)
        plane.addRectangle(rect)
        
        let rectView = UIView(frame: CGRect(x: rect.point.x, y: rect.point.y, width: rect.size.width, height: rect.size.height))
        rectView.backgroundColor = UIColor(red: CGFloat(randomColor.red) / 255.0, green: CGFloat(randomColor.green) / 255.0, blue: CGFloat(randomColor.blue) / 255.0, alpha: CGFloat(opacity.rawValue) / 10.0)
        rectView.tag = rect.uniqueID.hashValue
        
        view.addSubview(rectView)
        
        logger.info("사각형 버튼 Tapped!!")
    }
    
    @objc private func photoButtonTapped() {
        logger.info("사진 버튼 Tapped!!")
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        let selectedPoint = Point(x: location.x, y: location.y)
        
        if let rectangleModel = plane.rectangle(at: selectedPoint) {
            guard let rectangleView = findRectangleView(for: rectangleModel) else { return }
            selectedRectangleView?.layer.borderWidth = 0
            
            selectedRectangleView = rectangleView
            selectedRectangleView?.layer.borderWidth = 2
            selectedRectangleView?.layer.borderColor = UIColor.blue.cgColor
            
            logger.info("선택된 사각형의 ID는 \(rectangleModel.uniqueID.value)")
            
        } else {
            selectedRectangleView?.layer.borderWidth = 0
            selectedRectangleView = nil
        }
    }
    
    private func findRectangleView(for model: RectangleModel) -> UIView? {
        return view.subviews.first { $0.tag == model.uniqueID.hashValue }
    }
    
    private func setupBackgroundAction() {
        settingsPanelViewController.onColorChangeRequested = { [weak self] in
            guard let self = self,
            let selectedRectangleView = self.selectedRectangleView else {
                self?.logger.error("선택된 사각형이 없습니다.")
                return
            }
            
            let randomColor = RGBColor(red: Int.random(in: 0...255), green: Int.random(in: 0...255), blue: Int.random(in: 0...255))!
            let rectangleModel = plane.rectangles.first { $0.uniqueID.hashValue ==  selectedRectangleView.tag }
            
            rectangleModel?.setBackgroundColor(randomColor)
            
            selectedRectangleView.backgroundColor = UIColor(red: CGFloat(randomColor.red) / 255.0, green: CGFloat(randomColor.green) / 255.0, blue: CGFloat(randomColor.blue) / 255.0, alpha:  CGFloat((rectangleModel?.opacity.rawValue)!) / 10.0 )
            
            let hexString = String(format: "%02X%02X%02X", randomColor.red, randomColor.green, randomColor.blue)
            
            self.settingsPanelViewController.backgroundStack.updateColorButtonTitle(hexString)
            
            self.logger.info("배경색이 변경되었습니다.")
        }
    }
    
    private func setupOpacityAction() {
        settingsPanelViewController.onOpacityChangeRequested = { [weak self] newOpacity in
            guard let self = self,
                  let selectedRectangleView = self.selectedRectangleView else {
                self?.logger.error("선택된 사각형이 없습니다.")
                return
            }
            
            let rectangleModel = plane.rectangles.first { $0.uniqueID.hashValue == selectedRectangleView.tag }
            
            rectangleModel?.setOpacity(newOpacity)
            
            selectedRectangleView.alpha = CGFloat(newOpacity.rawValue) / 10.0
            logger.info("변경된 투명도는 \(Double(newOpacity.rawValue) / 10.0)")
        }
    }
}
