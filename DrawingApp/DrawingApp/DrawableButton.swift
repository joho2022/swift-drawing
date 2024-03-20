//
//  DrawableButton.swift
//  DrawingApp
//
//  Created by 조호근 on 3/20/24.
//

import Foundation
import UIKit

class DrawableButton: UIButton {
    
    init(title: String, image: UIImage?) {
        super.init(frame: .zero)
        configure(title: title, image: image)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(title: "버튼", image: UIImage(systemName: "x.square"))
    }
    
    private func configure(title: String, image: UIImage?) {
        var config = UIButton.Configuration.gray()
        config.title = title
        config.image = image
        config.baseForegroundColor = .black
        
        config.buttonSize = .large
        config.imagePlacement = .top
        
        config.imagePadding = 5
        config.titlePadding = 5
        self.configuration = config
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray3.cgColor
        self.layer.cornerRadius = 8
        
    }
}
