//
//  OpacityStack.swift
//  DrawingApp
//
//  Created by 조호근 on 3/20/24.
//

import Foundation
import UIKit

class OpacityStack: UIStackView {
    private let opacityLabel: UILabel = {
        let label = UILabel()
        label.text = "투명도"
        label.textColor = .black
        
        return label
    }()
    
    private let opacitySlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.value = 10
        
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
    }
    
    private func setupStackView() {
        axis = .vertical
        distribution = .fillEqually
        
        [ opacityLabel, opacitySlider ].forEach { addArrangedSubview($0) }
    }
    
    func setSliderAction(sliderChanged: Selector?, target: Any?) {
        if let action = sliderChanged {
            opacitySlider.addTarget(target, action: action, for: .valueChanged)
        }
    }
}
