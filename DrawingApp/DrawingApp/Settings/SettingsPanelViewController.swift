//
//  SettingsPanelViewController.swift
//  DrawingApp
//
//  Created by 조호근 on 3/20/24.
//

import UIKit
import SnapKit
import os

extension Notification.Name {
    static let componentPositionChanged = Notification.Name("SettingsPanelViewController.componentPositionChanged")
}

class SettingsPanelViewController: UIViewController {
    private let logger = os.Logger(subsystem: "pro.DrawingApp.model", category: "BackgroundStack")
    
    private(set) var backgroundStack = BackgroundStack()
    private(set) var opacityStack = OpacityStack()
    private(set) var pointStack = StepperStack(frame: .zero, title: "위치", firstLabelText: "X", secondLabelText: "Y", firstStepperType: .positionX, secondStepperType: .positionY)
    private(set) var sizeStack = StepperStack(frame: .zero, title: "크기", firstLabelText: "W", secondLabelText: "H", firstStepperType: .width, secondStepperType: .height)

    
    var onColorChangeRequested: (() -> Void)?
    var onOpacityChangeRequested: ((Opacity) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleColorChanged(notification:)), name: .rectangleColorChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleComponentPositionChanged(notification:)), name: .componentPositionChanged, object: nil)
    }
    
    @objc private func handleColorChanged(notification: Notification) {
        guard let randomColor = notification.userInfo?["randomColor"] as? RGBColor else { return }
        
        self.logger.info("배경색 변경 수신완료(Setting)!")
        backgroundStack.updateColorButtonTitle(with: randomColor)
    }
    
    @objc private func handleComponentPositionChanged(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let tempView = userInfo["tempView"] as? UIView,
              let newX = userInfo["newX"] as? CGFloat,
              let newY = userInfo["newY"] as? CGFloat,
              let width = userInfo["width"] as? CGFloat,
              let height = userInfo["height"] as? CGFloat else { return }
        
        pointStack.updateStepperValue(firstValue: newX, secondValue: newY)
        sizeStack.updateStepperValue(firstValue: width, secondValue: height)
    }
    
    func updateUIForSelectedComponent(_ component: VisualComponent?) {
        updateColorButtonTitle(with: component?.getColor())
        updateStepperValues(with: component)
    }
}

extension SettingsPanelViewController {
    func setupView() {
        [
            backgroundStack,
            opacityStack,
            pointStack,
            sizeStack
        ].forEach { view.addSubview($0) }
        
        backgroundStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(25)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        backgroundStack.setButtonAction(
            changeAction: #selector(changeColorTapped),
            target: self
        )
        
        opacityStack.snp.makeConstraints {
            $0.top.equalTo(backgroundStack.snp.bottom).offset(20)
            $0.leading.equalTo(backgroundStack.snp.leading)
            $0.trailing.equalTo(backgroundStack.snp.trailing)
        }
        
        opacityStack.setSliderAction(
            sliderChanged: #selector(sliderChanged),
            target: self
        )
        
        pointStack.snp.makeConstraints {
            $0.top.equalTo(opacityStack.snp.bottom).offset(20)
            $0.leading.equalTo(opacityStack.snp.leading)
            $0.trailing.equalTo(opacityStack.snp.trailing)
        }
        
        sizeStack.snp.makeConstraints {
            $0.top.equalTo(pointStack.snp.bottom).offset(20)
            $0.leading.equalTo(pointStack.snp.leading)
            $0.trailing.equalTo(pointStack.snp.trailing)
        }
    }
    
    @objc func changeColorTapped() {
        onColorChangeRequested?()
        logger.info("배경색 버튼 Tapped!!!")
    }
    
    @objc func sliderChanged(_ sender: UISlider) {
        guard let opacity = Opacity(value: Int(sender.value)) else {
            return
        }
        onOpacityChangeRequested?(opacity)
    }
    
    private func updateColorButtonTitle(with color: RGBColor?) {
        let color = color ?? nil
        backgroundStack.updateColorButtonTitle(with: color)
    }
    
    private func updateStepperValues(with component: VisualComponent?) {
        let positionX = component?.getPoint().x ?? 0
        let positionY = component?.getPoint().y ?? 0
        let width = component?.getSize().width ?? 0
        let height = component?.getSize().height ?? 0
        
        pointStack.updateStepperValue(firstValue: Double(positionX), secondValue: Double(positionY))
        sizeStack.updateStepperValue(firstValue: Double(width), secondValue: Double(height))
    }
}
