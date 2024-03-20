//
//  DrawingViewController.swift
//  DrawingApp
//
//  Created by 조호근 on 3/18/24.
//

import UIKit
import os
import SnapKit

class DrawingViewController: UIViewController {
    private let logger = os.Logger(subsystem: "pro.DrawingApp.model", category: "ModelLogging")
    private let factory = RectangleFactory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

    }
}

