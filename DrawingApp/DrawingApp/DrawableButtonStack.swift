//
//  DrawableButtonStack.swift
//  DrawingApp
//
//  Created by 조호근 on 3/20/24.
//

import Foundation
import UIKit

class DrawableButtonStack: UIStackView {
    
    let rectangleButton = DrawableButton(title: "사각형", image: UIImage(systemName: "rectangle"))
    let photoButton = DrawableButton(title: "사진", image: UIImage(systemName: "photo"))
    let textButton = DrawableButton(title: "텍스트", image: UIImage(systemName:"textformat"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
    }
    
    private func setupStackView() {
        axis = .horizontal
        distribution = .fillEqually
        spacing = 5
        
        [ rectangleButton, photoButton, textButton ].forEach { addArrangedSubview($0) }
    }
    
    // action에 nil을 주고 일시적으로 동작하지 않도록 생각한 방법
    func setRectangleButtonAction(_ action: Selector?, target: Any?) {
        if let action = action {
            rectangleButton.addTarget(target, action: action, for: .touchUpInside)
            rectangleButton.isEnabled = true
        } else {
            rectangleButton.isEnabled = false
        }
    }
    
    func setPhotoButtonAction(_ action: Selector?, target: Any?) {
        if let action = action {
            photoButton.addTarget(target, action: action, for: .touchUpInside)
            photoButton.isEnabled = true
        } else {
            photoButton.isEnabled = false
        }
    }
    
    func setTextButtonAction(_ action: Selector?, target: Any?) {
        if let action = action {
            textButton.addTarget(target, action: action, for: .touchUpInside)
            textButton.isEnabled = true
        } else {
            textButton.isEnabled = false
        }
    }
}
