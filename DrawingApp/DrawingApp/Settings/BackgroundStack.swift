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
        config.baseForegroundColor = UIColor.black
        
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
    
    func updateColorButtonTitle(_ title: String) {
        changeColorButton.setTitle(title, for: .normal)
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
}
