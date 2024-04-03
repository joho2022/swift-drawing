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
    
    private var viewRegistry: [AnyVisualComponent: UIView] = [:]
    
    private var plane = Plane()
    private var factory = RectangleFactory()
    private var photoFactory = PhotoFactory()
    private var textFactory = LabelFactory()
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleCreateLabel(notification:)), name: .labelCreated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleColorChanged(notification:)), name: .rectangleColorChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleOpacityChanged(notification:)), name: .opacityChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePointUpdate(notification:)), name: .pointUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSizeUpdate(notification:)), name: .sizeUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePositionChanged(notification:)), name: .positionChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSizeChanged(notification:)), name: .sizeChanged, object: nil)
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
            $0.width.equalTo(400)
        }
        
        drawableButtonStack.setRectangleButtonAction(#selector(rectangleButtonTapped), target: self)
        
        drawableButtonStack.setPhotoButtonAction(#selector(photoButtonTapped), target: self)
        
        drawableButtonStack.setTextButtonAction(#selector(textButtonTapped), target: self)
    }
    
    @objc private func rectangleButtonTapped() {
        let rectangleModel = createRectangleData()
        plane.createRectangleView(rectangleModel)
    }
    
    @objc private func handlePointUpdate(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let selectedModel = userInfo["selectedModel"] as? VisualComponent,
              let newPoint = userInfo["point"] as? Point,
              let selectedView = viewRegistry[AnyVisualComponent(selectedModel)] else { return }
        let newX = CGFloat(newPoint.x)
        let newY = CGFloat(newPoint.y)
        
        selectedView.frame = CGRect(x: newX, y: newY, width: selectedView.frame.size.width, height: selectedView.frame.size.height)
    }
    
    @objc private func handleSizeUpdate(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let selectedModel = userInfo["selectedModel"] as? VisualComponent,
              let newSize = userInfo["size"] as? Size,
        let selectedView = viewRegistry[AnyVisualComponent(selectedModel)] else { return }
        let newWidth = newSize.width
        let newheight = newSize.height
        let selectedViewOriginX = selectedView.frame.origin.x
        let selectedViewOriginY = selectedView.frame.origin.y
        
        selectedView.frame = CGRect(x: selectedViewOriginX, y: selectedViewOriginY, width: newWidth, height: newheight)
    }
    
    @objc private func handleCreateRectangle(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let rectModel = userInfo["rectModel"] as? RectangleModel,
              let rectView = userInfo["rectView"] as? UIView else { return }
        
        logger.info("사각형 생성 수신완료!!")
        addViews(for: rectView, with: rectModel)
        view.bringSubviewToFront(drawableButtonStack)
    }
    
    @objc private func handleCreateLabel(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let labelModel = userInfo["labelModel"] as? Label,
              let labelView = userInfo["labelView"] as? UILabel else { return }
        
        logger.info("텍스트 생성 수신완료!!")
        addViews(for: labelView, with: labelModel)
        view.bringSubviewToFront(drawableButtonStack)
    }
    
    @objc private func handleColorChanged(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let selectedModel = userInfo["selectedModel"] as? VisualComponent,
              let randomColor = userInfo["randomColor"] as? RGBColor,
              let selectedView = viewRegistry[AnyVisualComponent(selectedModel)] else { return }
        
        self.logger.info("배경색 변경 수신완료(Main)!")
        updateViewBackgroundColor(for: selectedView, using: randomColor)
    }
    
    @objc private func handleOpacityChanged(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let selectedModel = userInfo["selectedModel"] as? VisualComponent,
              let newOpacity = userInfo["opacity"] as? Opacity,
              let selectedView = viewRegistry[AnyVisualComponent(selectedModel)] else { return }
        
        updateViewOpacity(for: selectedView, using: newOpacity)
    }
    
    private func setupBackgroundAction() {
        settingsPanelViewController.onColorChangeRequested = { [weak self] in
            guard let self = self,
                  let selectedRectangleView = self.selectedView else {
                self?.logger.error("선택된 사각형이 없습니다.")
                return
            }
            let selectedModel = findComponent(for: selectedRectangleView)!
            plane.updateRectangleColor(uniqueID: selectedModel.getUniqueID())
        }
    }
    
    private func setupOpacityAction() {
        settingsPanelViewController.onOpacityChangeRequested = { [weak self] newOpacity in
            guard let self = self,
                  let selectedView = self.selectedView else {
                self?.logger.error("선택된 사각형 또는 이미지가 없습니다.")
                return
            }
            
            if let selectedModel = self.findComponent(for: selectedView) {
                plane.updateOpacity(uniqueID: selectedModel.getUniqueID(), opacity: newOpacity)
                self.logger.info("투명도 업데이트!")
            }
        }
    }
    
    private func addViews(for view: UIView, with model: VisualComponent) {
        viewRegistry[AnyVisualComponent(model)] = view
        
        logger.info("생성된 키는\(self.viewRegistry.keys)")
        self.view.addSubview(view)
    }
    
    private func findView(for component: any VisualComponent) -> UIView? {
        return viewRegistry[AnyVisualComponent(component)]
    }
    
    private func findComponent(for view: UIView) -> VisualComponent? {
        let result = viewRegistry.first(where: { $0.value === view })
        return result?.key.component
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
            self.plane.createImageView(photoModel)
        }
    }
    
    private func createPhotoData(with imageData: Data) -> PhotoModel {
        let size = Size(width: 150.0, height: 120.0)
        let subViewWidth = 200.0
        let randomPoint = Point(x: Double.random(in: 0...(view.bounds.width - size.width - subViewWidth)), y: Double.random(in: 0...(view.bounds.height - size.height)))
        let opacity = Opacity(value: 10)!
        
        let photo = photoFactory.createPhotoModel(imageData: imageData, size: size, point: randomPoint, opacity: opacity)
        plane.addPhoto(photo)
        
        return photo
    }
    
    @objc func handlePhotoCreated(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let photoModel = userInfo["photoModel"] as? PhotoModel,
              let photoView = userInfo["photoView"] as? UIView else { return }
        
        addViews(for: photoView, with: photoModel)
    }
    
    @objc private func textButtonTapped() {
        logger.info("텍스트 버튼 Tapped!")
        let labelData = createTextData()
        plane.createLabelView(labelData)
        
    }
    
    private func createTextData() -> Label {
        let size = Size(width: 470, height: 40)
        let subViewWidth = 200.0
        let randomPoint = Point(x: Double.random(in: 0...(view.bounds.width - size.width - subViewWidth)), y: Double.random(in: 0...(view.bounds.height - size.height)))
        let blackColor = RGBColor(red: 0, green: 0, blue: 0)!
        let opacity = Opacity(value: 10)!
        
        let textLabel = textFactory.createLabel(size: size, point: randomPoint, backgroundColor: blackColor, opacity: opacity)
        
        plane.addLabel(textLabel)
        
        return textLabel
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
            if gestureRecognizer is UIPanGestureRecognizer {
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
            if let component = plane.hasComponent(at: selectedPoint), let selectedView = findView(for: component) {
                createTemporaryView(from: selectedView)
            }
        case .changed:
            if let tempView = temporaryView {
                NotificationCenter.default.post(name: .componentPositionChanged, object: self, userInfo: [
                    "tempView": tempView,
                    "newX": newX - (tempView.frame.size.width / 2),
                    "newY": newY - (tempView.frame.size.height / 2),
                    "width": tempView.frame.size.width,
                    "height": tempView.frame.size.height
                ])
                
            }
        case .ended, .cancelled:
            guard let selectedView = selectedView else { return }
            let selectedComponent = findComponent(for: selectedView)
            let pointX = newX - (selectedView.frame.size.width / 2)
            let pointY = newY - (selectedView.frame.size.height / 2)
            updateModelPosition(for: selectedView, to: Point(x: pointX, y: pointY))
            settingsPanelViewController.updateUIForSelectedComponent(selectedComponent)
            temporaryView?.removeFromSuperview()
            temporaryView = nil
            
        default:
            break
        }
    }
    
    private func createTemporaryView(from selectedView: UIView?) {
        guard let selectedView = selectedView else { return }
        let snapshot = selectedView.snapshotView(afterScreenUpdates: false)
        
        if let snapshot = snapshot {
            snapshot.frame = selectedView.frame
            snapshot.alpha = 0.5
            self.view.addSubview(snapshot)
            temporaryView = snapshot
        }
    }
    
    private func updateModelPosition(for selectedView: UIView, to newPoint: Point) {
        if let selectedModel = findComponent(for: selectedView) {
            plane.updatePoint(uniqueID: selectedModel.getUniqueID(), point: newPoint)
        }
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let newX = sender.location(in: view).x
        let newY = sender.location(in: view).y
        
        let selectedPoint = Point(x: newX, y: newY)
        let selectedComponent = plane.hasComponent(at: selectedPoint)
        viewRegistry.forEach { $0.value.layer.borderWidth = 0 }
        
        if let component = selectedComponent, let view = findView(for: component) {
            selectedView = view
            selectedView?.layer.borderWidth = 4
            selectedView?.layer.borderColor = UIColor.blue.cgColor
            settingsPanelViewController.updateUIForSelectedComponent(component)
            
        } else {
            selectedView = nil
            settingsPanelViewController.updateUIForSelectedComponent(nil)
        }
    }
   
    @objc func handlePositionChanged(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let value = userInfo["value"] as? Double,
              let stepperType = userInfo["stepperType"] as? StepperType,
              let selectedView = self.selectedView,
              let selectedModel = self.findComponent(for: selectedView) else { return }
        
        var newPosition: Point?
        
        switch stepperType {
        case .positionX:
            newPosition = Point(x: value, y: selectedView.frame.origin.y)
            break
        case .positionY:
            newPosition = Point(x: selectedView.frame.origin.x, y: value)
            break
        default:
            break
        }
        
        if let newPosition = newPosition {
            plane.updatePoint(uniqueID: selectedModel.getUniqueID(), point: newPosition)
            
        }
    }
    
    @objc func handleSizeChanged(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let value = userInfo["value"] as? Double,
              let stepperType = userInfo["stepperType"] as? StepperType,
              let selectedView = self.selectedView,
              let selectedModel = self.findComponent(for: selectedView) else { return }
        
        var newSize: Size?
        
        switch stepperType {
        case .width:
            newSize = Size(width: value, height: selectedView.frame.size.height)
            break
        case .height:
            newSize = Size(width: selectedView.frame.size.width, height: value)
            break
        default:
            break
        }
        
        if let newSize = newSize {
            plane.updateSize(uniqueID: selectedModel.getUniqueID(), size: newSize)
        }
    }
}


