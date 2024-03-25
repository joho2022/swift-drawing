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
    private var rectangleViews: [String: UIView] = [:]

    private var plane = Plane()
    private var factory = RectangleFactory()
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCreateRectangle(notification:)), name: .rectangleCreated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleColorChanged(notification:)), name: .rectangleColorChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOpacityChanged(notification:)), name: .rectangleOpacityChanged, object: nil)
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
        let rectangleModel = createRectangleData()
        plane.createRectangleView(rectangleModel)
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
            selectedRectangleView?.layer.borderWidth = 4
            selectedRectangleView?.layer.borderColor = UIColor.blue.cgColor
            
            logger.info("선택된 사각형의 ID는 \(rectangleModel.uniqueID.value)")
            
        } else {
            selectedRectangleView?.layer.borderWidth = 0
            selectedRectangleView = nil
        }
    }
    
    @objc private func handleCreateRectangle(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let rectModel = userInfo["rectModel"] as? RectangleModel,
              let rectView = userInfo["rectView"] as? UIView else { return }
        
        logger.info("사각형 생성 수신완료!!")
        addRectangleViews(for: rectView, with: rectModel)
        view.bringSubviewToFront(drawableButtonStack)
    }
    
    @objc private func handleColorChanged(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let uniqueID = userInfo["uniqueID"] as? String,
              let randomColor = userInfo["randomColor"] as? RGBColor,
              let rectangleView = rectangleViews[uniqueID] else { return }
        
        self.logger.info("배경색 변경 수신완료!")
        updateViewBackgroundColor(for: rectangleView, using: randomColor)
        updateColorButtonTitle(with: randomColor)
        
    }
    
    @objc private func handleOpacityChanged(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let uniqueID = userInfo["uniqueID"] as? String,
              let newOpacity = userInfo["opacity"] as? Opacity,
              let rectangleView = rectangleViews[uniqueID] else { return }
        
        updateViewOpacity(for: rectangleView, using: newOpacity)
        logger.info("투명도 변경 수신완료! 투명도: \(Double(newOpacity.rawValue) / 10.0)")
    }
    
    private func setupBackgroundAction() {
        settingsPanelViewController.onColorChangeRequested = { [weak self] in
            guard let self = self,
            let selectedRectangleView = self.selectedRectangleView else {
                self?.logger.error("선택된 사각형이 없습니다.")
                return
            }
            let uniqueID = findKey(for: selectedRectangleView)!
            plane.updateRectangleColor(uniqueID: uniqueID)
        }
    }
    
    private func setupOpacityAction() {
        settingsPanelViewController.onOpacityChangeRequested = { [weak self] newOpacity in
            guard let self = self,
                  let selectedRectangleView = self.selectedRectangleView else {
                self?.logger.error("선택된 사각형이 없습니다.")
                return
            }
            let uniqueID = findKey(for: selectedRectangleView)!
            plane.updateRectangleOpacity(uniqueID: uniqueID, opacity: newOpacity)
        }
    }
    
    private func addRectangleViews(for view: UIView, with model: RectangleModel) {
        rectangleViews[model.uniqueID.value] = view
        
        logger.info("생성된 키는\(self.rectangleViews.keys)")
        self.view.addSubview(view)
    }
    
    private func findRectangleView(for model: RectangleModel) -> UIView? {
        return rectangleViews[model.uniqueID.value]
    }
    
    private func findKey(for view: UIView) -> String? {
        return rectangleViews.first(where: { $0.value === view })?.key
    }
    
    private func updateViewBackgroundColor(for view: UIView, using color: RGBColor) {
        let backgroundColor = UIColor(
            red: CGFloat(color.red) / 255.0,
            green: CGFloat(color.green) / 255.0,
            blue: CGFloat(color.blue) / 255.0,
            alpha: 10.0
        )
        
        view.backgroundColor = backgroundColor
    }
    
    private func updateViewOpacity(for view: UIView, using opacity: Opacity) {
        view.alpha = CGFloat(opacity.rawValue) / 10.0
    }
    
    private func updateColorButtonTitle(with color: RGBColor) {
        let hexString = String(format: "%02X%02X%02X", color.red, color.green, color.blue)
        self.settingsPanelViewController.backgroundStack.updateColorButtonTitle(hexString)
    }
    
    private func createRectangleData() -> RectangleModel {
        let size = Size(width: 150.0, height: 120.0)
        let subViewWidth = 200.0
        let randomPoint = Point(x: Double.random(in: 0...(view.bounds.width - size.width - subViewWidth)), y: Double.random(in: 0...(view.bounds.height - size.height)))
        let randomColor = RGBColor(red: Int.random(in: 0...255), green: Int.random(in: 0...255), blue: Int.random(in: 0...255))!
        let opacity = Opacity(value: 10)!
        
        let rect = factory.createRectangleModel(size: size, point: randomPoint, backgroundColor: randomColor, opacity: opacity)
        
        plane.addRectangle(rect)
        
        return rect
    }
}
