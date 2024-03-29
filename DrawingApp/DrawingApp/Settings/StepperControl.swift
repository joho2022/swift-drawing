//
//  StepperControl.swift
//  DrawingApp
//
//  Created by 조호근 on 3/27/24.
//

import Foundation
import UIKit

extension Notification.Name {
    static let positionChanged = Notification.Name("StepperControl.positionChanged")
    static let sizeChanged = Notification.Name("StepperControl.sizeChanged")
}

enum StepperType {
    case positionX, positionY, width, height
    
    var notificationName: Notification.Name {
        switch self {
        case .positionX, .positionY:
            return .positionChanged
        case .width, .height:
            return .sizeChanged
        }
    }
}

class StepperControl: UIStackView {
    var stepperType: StepperType
    
    var valueChanged: ((Double) -> Void)?
    
    var value: Double = 0 {
        didSet {
            valueChanged?(value)
            
            switch stepperType {
            case .positionX, .positionY:
                NotificationCenter.default.post(name: .positionChanged, object: nil, userInfo: ["value": value, "stepperType": stepperType])
            case .width, .height:
                NotificationCenter.default.post(name: .sizeChanged, object: nil, userInfo: ["value": value, "stepperType": stepperType])
            }
        }
    }
    
    init(stepperType: StepperType) {
        self.stepperType = stepperType
        super.init(frame: .zero)
        setupStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▼", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▲", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    private func setupStackView() {
        axis = .vertical
        distribution = .fillEqually
        
        [ plusButton, minusButton ].forEach { addArrangedSubview($0) }
        
        minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
    }
    
    func setValueLabel(_ newValue: Double) {
        return self.value = newValue
    }
    
    @objc private func minusTapped() {
        value = max(value - 4, 0)
        valueChanged?(value)
    }
    
    @objc private func plusTapped() {
        value += 4
        valueChanged?(value)
    }
}
