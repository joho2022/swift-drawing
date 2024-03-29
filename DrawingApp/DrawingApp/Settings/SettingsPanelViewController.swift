//
//  SettingsPanelViewController.swift
//  DrawingApp
//
//  Created by 조호근 on 3/20/24.
//

import UIKit
import SnapKit
import os

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
}
