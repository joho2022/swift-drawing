//
//  MainViewController.swift
//  DrawingApp
//
//  Created by 조호근 on 3/20/24.
//

import UIKit
import os
import SnapKit

class MainViewController: UIViewController {
    private let logger = os.Logger(subsystem: "pro.DrawingApp.model", category: "Main")
    private let factory = RectangleFactory()
    
    private let drawableButtonStack = DrawableButtonStack()
    
    private let drawingViewController = DrawingViewController()
    private let settingsPanelViewController = SettingsPanelViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settingsFrame = view.bounds.with(width: 200)
        addChild(settingsPanelViewController, settingsFrame)
        
        let drawingFrame = view.bounds.remaining(after: settingsFrame)
        addChild(drawingViewController, drawingFrame)
        
        setupView()
    }
    
    private func addChild(_ child: UIViewController, _ frame: CGRect) {
        addChild(child)
        child.view.frame = frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}

extension MainViewController {
    func setupView() {
        [ drawableButtonStack ].forEach { view.addSubview($0) }
        
        drawableButtonStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.height.equalTo(100)
            $0.width.equalTo(300)
        }
        
        drawableButtonStack.setButtonActions(
            rectangleAction: #selector(rectangleButtonTapped),
            photoAction: #selector(photoButtonTapped),
            target: self
        )
    }
    
    @objc private func rectangleButtonTapped() {
        logger.info("사각형 버튼 Tapped!!")
    }
    
    @objc private func photoButtonTapped() {
        logger.info("사진 버튼 Tapped!!")
    }
}
