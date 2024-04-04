//
//  StepperStack.swift
//  DrawingApp
//
//  Created by 조호근 on 3/28/24.
//

import Foundation
import UIKit

class StepperStack: UIStackView {
    private let titleLabel: UILabel
    
    private let firstLabel = UILabel()
    private let secondLabel = UILabel()
    
    private(set) var firstStepper: StepperControl
    private(set) var secondStepper: StepperControl
    
    init(frame: CGRect, title: String, firstLabelText: String, secondLabelText: String, firstStepperType: StepperType, secondStepperType: StepperType) {
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .black
        
        self.firstStepper = StepperControl(stepperType: firstStepperType)
        self.secondStepper = StepperControl(stepperType: secondStepperType)
        
        super.init(frame: frame)
        setupStackView(firstLabelText: firstLabelText, secondLabelText: secondLabelText)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView(firstLabelText: String, secondLabelText: String) {
        axis = .vertical
        spacing = 10
        distribution = .fill
        
        
        addArrangedSubview(titleLabel)
        setupViews(firstLabel, stepper: firstStepper, labelText: firstLabelText)
        setupViews(secondLabel, stepper: secondStepper, labelText: secondLabelText)
    }
    
    private func setupViews(_ valueLabel: UILabel, stepper: StepperControl, labelText: String) {
        let label = UILabel()
        label.text = labelText
        label.textColor = UIColor.systemGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [label, valueLabel, stepper])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fill
        stack.layer.borderWidth = 1
        stack.layer.borderColor = UIColor.systemGray3.cgColor
        stack.layer.cornerRadius = 8
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 8)
        
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stepper.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        stepper.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        valueLabel.text = "0"
        valueLabel.textAlignment = .left
        
        stepper.valueChanged = { newValue in
            valueLabel.text = "\(Int(newValue))"
        }
        
        addArrangedSubview(stack)
    }
    
    func updateStepperValue(firstValue: Double, secondValue: Double) {
        firstLabel.text = "\(Int(firstValue))"
        firstStepper.value = firstValue

        secondLabel.text = "\(Int(secondValue))"
        secondStepper.value = secondValue
    }
    
    func updateStepperTempValue(firstValue: Double, secondValue: Double) {
        firstLabel.text = "\(Int(firstValue))"

        secondLabel.text = "\(Int(secondValue))"
    }
}
