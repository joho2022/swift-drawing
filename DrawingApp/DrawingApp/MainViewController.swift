//
//  MainViewController.swift
//  DrawingApp
//
//  Created by 조호근 on 3/20/24.
//

import UIKit
import os
import SnapKit
import Foundation

class MainViewController: UIViewController {
    private let logger = os.Logger(subsystem: "pro.DrawingApp.model", category: "Main")
    private var selectedView: UIView?
    private var temporaryView: UIView?
    
    private var viewRegistry: [UniqueID: UIView] = [:]
    
    private var plane = Plane()
    private var photoManager = PhotoManager()
    private var factory = RectangleFactory()
    private var photoFactory = PhotoFactory()
    
    private let drawableButtonStack = DrawableButtonStack()
    private let settingsPanelViewController = SettingsPanelViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settingsFrame = view.bounds.with(width: 200)
        addChild(settingsPanelViewController, settingsFrame)
        
        setupGesture()
        setupOpacityAction()
        setupBackgroundAction()
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePhotoCreated(notification:)), name: .photoSelected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCreateRectangle(notification:)), name: .rectangleCreated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleColorChanged(notification:)), name: .rectangleColorChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRectOpacityChanged(notification:)), name: .rectangleOpacityChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePhotoOpacityChanged(notification: )), name: .photoOpacityChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePointUpdate(notification:)), name: .pointUpdated, object: nil)
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
        
        drawableButtonStack.setRectangleButtonAction(#selector(rectangleButtonTapped), target: self)
        
        drawableButtonStack.setPhotoButtonAction(#selector(photoButtonTapped), target: self)
    }
    
    @objc private func rectangleButtonTapped() {
        let rectangleModel = createRectangleData()
        plane.createRectangleView(rectangleModel)
    }
    
    @objc private func handlePointUpdate(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let uniqueID = userInfo["uniqueID"] as? UniqueID,
              let newPoint = userInfo["point"] as? Point,
              let selectedView = viewRegistry[uniqueID] else { return }
        let newX = CGFloat(newPoint.x)
        let newY = CGFloat(newPoint.y)
        
        selectedView.frame = CGRect(x: newX, y: newY, width: selectedView.frame.size.width, height: selectedView.frame.size.height)
    }
    
    @objc private func handleCreateRectangle(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let rectModel = userInfo["rectModel"] as? RectangleModel,
              let rectView = userInfo["rectView"] as? UIView else { return }
        
        logger.info("사각형 생성 수신완료!!")
        addRectangleViews(for: rectView, with: rectModel)
        view.bringSubviewToFront(drawableButtonStack)
    }
    
    @objc private func handleColorChanged(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let uniqueID = userInfo["uniqueID"] as? UniqueID,
              let randomColor = userInfo["randomColor"] as? RGBColor,
              let rectangleView = viewRegistry[uniqueID] else { return }
        
        self.logger.info("배경색 변경 수신완료!")
        updateViewBackgroundColor(for: rectangleView, using: randomColor)
        changeColorButtonTitle(with: randomColor)
    }
    
    @objc private func handleRectOpacityChanged(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let uniqueID = userInfo["uniqueID"] as? UniqueID,
              let newOpacity = userInfo["opacity"] as? Opacity,
              let rectangleView = viewRegistry[uniqueID] else { return }
        
        updateViewOpacity(for: rectangleView, using: newOpacity)
    }
    
    @objc private func handlePhotoOpacityChanged(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let uniqueID = userInfo["uniqueID"] as? UniqueID,
              let newOpacity = userInfo["opacity"] as? Opacity,
              let photoView = viewRegistry[uniqueID] else { return }
        
        updateViewOpacity(for: photoView, using: newOpacity)
    }
    
    private func setupBackgroundAction() {
        settingsPanelViewController.onColorChangeRequested = { [weak self] in
            guard let self = self,
                  let selectedRectangleView = self.selectedView else {
                self?.logger.error("선택된 사각형이 없습니다.")
                return
            }
            let uniqueID = findKey(for: selectedRectangleView)!
            plane.updateRectangleColor(uniqueID: uniqueID)
        }
    }
    
    private func setupOpacityAction() {
        settingsPanelViewController.onOpacityChangeRequested = { [weak self] newOpacity in
            guard let self = self,
                  let selectedView = self.selectedView else {
                self?.logger.error("선택된 사각형 또는 이미지가 없습니다.")
                return
            }
            
            if let uniqueID = self.findKey(for: selectedView) {
                var manager: Updatable? = self.findManager(for: uniqueID)
                
                manager?.updateOpacity(uniqueID: uniqueID, opacity: newOpacity)
                self.logger.info("투명도 업데이트!")
            }
        }
    }
    
    private func findManager(for uniqueID: UniqueID) -> Updatable? {
        if plane.rectangles.contains(where: { $0.uniqueID == uniqueID }) {
            return plane
        } else if photoManager.photos.contains(where: { $0.uniqueID == uniqueID }) {
            return photoManager
        }
        
        return nil
    }
    
    private func addRectangleViews(for view: UIView, with model: RectangleModel) {
        viewRegistry[model.uniqueID] = view
        
        logger.info("생성된 키는\(self.viewRegistry.keys)")
        self.view.addSubview(view)
    }
    
    private func findView(for model: RectangleModel) -> UIView? {
        return viewRegistry[model.uniqueID]
    }
    
    private func findView(for model: PhotoModel) -> UIImageView? {
        return viewRegistry[model.uniqueID] as? UIImageView
    }
    
    private func findKey(for view: UIView) -> UniqueID? {
        return viewRegistry.first(where: { $0.value === view })?.key
    }
    
    private func updateViewBackgroundColor(for view: UIView, using color: RGBColor) {
        let backgroundColor = UIColor(
            red: CGFloat(color.red) / 255.0,
            green: CGFloat(color.green) / 255.0,
            blue: CGFloat(color.blue) / 255.0,
            alpha: 10.0
        )
        
        view.backgroundColor = backgroundColor
    }
    
    private func updateViewOpacity(for view: UIView, using opacity: Opacity) {
        view.alpha = CGFloat(opacity.rawValue) / 10.0
    }
    
    private func updateViewOpacity(for view: UIImageView, using opacity: Opacity) {
        view.alpha = CGFloat(opacity.rawValue) / 10.0
    }
    
    private func changeColorButtonTitle(with color: RGBColor) {
            let hexString = String(format: "%02X%02X%02X", color.red, color.green, color.blue)
            self.settingsPanelViewController.backgroundStack.updateColorButtonTitle(hexString)
        }
    
    private func convertToHexString(from color: RGBColor) -> String {
        return String(format: "%02X%02X%02X", color.red, color.green, color.blue)
    }
    
    private func createRectangleData() -> RectangleModel {
        let size = Size(width: 150.0, height: 120.0)
        let subViewWidth = 200.0
        let randomPoint = Point(x: Double.random(in: 0...(view.bounds.width - size.width - subViewWidth)), y: Double.random(in: 0...(view.bounds.height - size.height)))
        let randomColor = RGBColor(red: Int.random(in: 0...255), green: Int.random(in: 0...255), blue: Int.random(in: 0...255))!
        let opacity = Opacity(value: 10)!
        
        let rect = factory.createRectangleModel(size: size, point: randomPoint, backgroundColor: randomColor, opacity: opacity)
        
        plane.addRectangle(rect)
        
        return rect
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc private func photoButtonTapped() {
        logger.info("사진 버튼 Tapped!")
        presentImagePicker()
    }
    
    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            guard let image = info[.originalImage] as? UIImage, let imageData = image.pngData() else {
                self.logger.error("이미지가 존재하지 않습니다.")
                return
            }
            let photoModel = self.createPhotoData(with: imageData)
            self.photoManager.createImageView(photoModel)
        }
    }
    
    private func createPhotoData(with imageData: Data) -> PhotoModel {
        let size = Size(width: 150.0, height: 120.0)
        let subViewWidth = 200.0
        let randomPoint = Point(x: Double.random(in: 0...(view.bounds.width - size.width - subViewWidth)), y: Double.random(in: 0...(view.bounds.height - size.height)))
        let opacity = Opacity(value: 10)!
        
        let photo = photoFactory.createPhotoModel(imageData: imageData, size: size, point: randomPoint, opacity: opacity)
        photoManager.addPhoto(photo)
        
        return photo
    }
    
    @objc func handlePhotoCreated(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let photoModel = userInfo["photoModel"] as? PhotoModel,
              let photoView = userInfo["photoView"] as? UIImageView else { return }
        
        addPhotoViews(for: photoView, with: photoModel)
    }
    
    func addPhotoViews(for view: UIImageView, with model: PhotoModel) {
        viewRegistry[model.uniqueID] = view
        
        logger.info("생성된 이미지: \(self.viewRegistry.keys)")
        self.view.addSubview(view)
    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    private func setupGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            if gestureRecognizer == panGesture {
                return selectedView != nil
            }
            return true
        }
    }
    
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let newX = sender.location(in: view).x
        let newY = sender.location(in: view).y
        
        let selectedPoint = Point(x: newX, y: newY)
        
        switch sender.state {
        case .began:
            if let rectangleModel = plane.rectangle(at: selectedPoint), let rectangleView = findView(for: rectangleModel), rectangleView == selectedView {
                selectedView = rectangleView
            } else if let photoModel = photoManager.photo(at: selectedPoint), let photoView = findView(for: photoModel), photoView == selectedView {
                selectedView = photoView
            }
            
            createTemporaryView(from: selectedView ?? nil)
        case .changed:
            if let tempView = temporaryView {
                let newFrame = CGRect(x: newX - (tempView.frame.size.width / 2), y: newY - (tempView.frame.size.height / 2),width: tempView.frame.size.width, height: tempView.frame.size.height)
                temporaryView?.frame = newFrame
            }
        case .ended, .cancelled:
            guard let selectedView = selectedView else { return }
            
            updateModelPosition(for: selectedView, to: Point(x: newX - (selectedView.frame.size.width / 2), y: newY - (selectedView.frame.size.height / 2)))
            
            temporaryView?.removeFromSuperview()
            temporaryView = nil
        default:
            break
        }
    }
      
    private func createTemporaryView(from selectedView: UIView?) {
        guard let selectedView = selectedView else { return }
        let snapshot = selectedView.snapshotView(afterScreenUpdates: true)
        
        if let snapshot = snapshot {
            snapshot.frame = selectedView.frame
            snapshot.alpha = 0.5
            self.view.addSubview(snapshot)
            
            temporaryView = snapshot
        }
    }
    
    private func updateModelPosition(for selectedView: UIView, to newPoint: Point) {
        
        if let uniqueID = findKey(for: selectedView) {
            var manager: Updatable? = self.findManager(for: uniqueID)
            manager?.updatePoint(uniqueID: uniqueID, point: newPoint)
        }
    }
    
        
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let newX = sender.location(in: view).x
        let newY = sender.location(in: view).y
        
        let selectedPoint = Point(x: newX, y: newY)
        viewRegistry.forEach { $0.value.layer.borderWidth = 0 }
        
        if let rectangleModel = plane.rectangle(at: selectedPoint), let rectangleView = findView(for: rectangleModel) {
            selectedView = rectangleView
            logger.info("선택된 사각형의 ID는 \(rectangleModel.uniqueID.value)")
        }
        else if let photoModel = photoManager.photo(at: selectedPoint), let photoView = findView(for: photoModel) {
            selectedView = photoView
            logger.info("선택된 이미지는 \(photoModel.uniqueID.value)")
        } else {
            selectedView = nil
        }
        
        if let selectedView = selectedView {
            selectedView.layer.borderWidth = 4
            selectedView.layer.borderColor = UIColor.blue.cgColor
        }
        
        updateColorButtonTitle()
    }
    
    private func updateColorButtonTitle() {
        if let selectedView = selectedView, let uniqueID = findKey(for: selectedView) {
            if let rectangleModel = plane.findRectangle(uniqueID: uniqueID.value) {
                let hexString = convertToHexString(from: rectangleModel.backgroundColor)
                self.settingsPanelViewController.backgroundStack.updateColorButtonTitle(hexString)
            } else {
                self.settingsPanelViewController.backgroundStack.updateColorButtonTitle("None")
            }
        } else {
            self.settingsPanelViewController.backgroundStack.updateColorButtonTitle("None")
        }
    }
}


