//
//  StepperControl.swift
//  DrawingApp
//
//  Created by 조호근 on 3/27/24.
//

import Foundation
import UIKit

class StepperControl: UIStackView {
    var valueChanged: ((Double) -> Void)?
    
    var value: Double = 0 {
        didSet {
            valueChanged?(value)
        }
    }
    
    private let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        return button
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        return button
    }()
    
    private func setupStackView() {
        axis = .vertical
        distribution = .fillEqually
        
        [ minusButton, plusButton ].forEach { addArrangedSubview($0) }
        
    }
}
