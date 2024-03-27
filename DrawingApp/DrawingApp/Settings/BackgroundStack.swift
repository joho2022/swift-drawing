//
//  BackgroundStack.swift
//  DrawingApp
//
//  Created by 조호근 on 3/20/24.
//

import SnapKit
import UIKit


class BackgroundStack: UIStackView {
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "배경색"
        label.textColor = .black
        return label
    }()
    
    private let changeColorButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .medium
        config.title = "None"
        config.baseForegroundColor = UIColor.systemGray
        
        let button = UIButton(configuration: config, primaryAction: nil)
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray3.cgColor
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
    }
    
    func updateColorButtonTitle(with color: RGBColor?) {
        guard let color = color else {
            changeColorButton.setTitle("None", for: .normal)
            changeColorButton.setTitleColor(UIColor.systemGray, for: .normal)
            return
        }

        let hexString = convertToHexString(from: color)
        changeColorButton.setTitle(hexString, for: .normal)
        changeColorButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    private func setupStackView() {
        axis = .vertical
        distribution = .fillEqually
        
        [ colorLabel, changeColorButton ].forEach { addArrangedSubview($0) }
    }
    
    func setButtonAction(changeAction: Selector?, target: Any?) {
        if let action = changeAction {
            changeColorButton.addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    private func convertToHexString(from color: RGBColor) -> String {
        return String(format: "%02X%02X%02X", color.red, color.green, color.blue)
    }
}
