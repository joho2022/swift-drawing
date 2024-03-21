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
        
        [ rectangleButton, photoButton ].forEach { addArrangedSubview($0) }
    }
    
    func setRectangleButtonAction(_ action: Selector?, target: Any?) {
        if let action = action {
            rectangleButton.addTarget(target, action: action, for: .touchUpInside)
        }
    }

    func setPhotoButtonAction(_ action: Selector?, target: Any?) {
        if let action = action {
            photoButton.addTarget(target, action: action, for: .touchUpInside)
        }
    }
}
