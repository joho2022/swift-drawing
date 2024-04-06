//
//  ListViewController.swift
//  DrawingApp
//
//  Created by 조호근 on 4/5/24.
//

import Foundation
import UIKit

extension Notification.Name {
    static let componentSelected = Notification.Name("ListViewController.componentSelected")
}

class ListViewController: UIViewController {
    var tableView: UITableView!
    var components: [BaseRect] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    func updateData(_ data: [BaseRect]) {
        self.components = data.reversed()
        tableView.reloadData()
        
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .systemGray5
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                presentContextMenu(forRowAt: indexPath)
            }
        }
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return components.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let component = components[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        if let describableComponent = component as? ObjectDescription {
            content.text = describableComponent.titleText
            content.image = UIImage(systemName: describableComponent.imageName)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
        cell.backgroundColor = .systemGray5
        cell.contentConfiguration = content
    
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "레이어"
        label.textColor = .black
        
        let headerView = UIView()
        headerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUniqueID = components[indexPath.row].uniqueID
        print("selectedUniqueID: \(selectedUniqueID)")
        
        NotificationCenter.default.post(name: .componentSelected, object: nil, userInfo: ["selectedUniqueID": selectedUniqueID])
    }
}

extension ListViewController {
    func presentContextMenu(forRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let sendToBackAction = UIAlertAction(title: "맨 뒤로 보내기", style: .default) { [weak self] _ in
            self?.sendToBack(at: indexPath)
        }
        alertController.addAction(sendToBackAction)

        let moveBackwardAction = UIAlertAction(title: "뒤로 보내기", style: .default) { [weak self] _ in
            self?.moveBackward(at: indexPath)
        }
        alertController.addAction(moveBackwardAction)

        let moveForwardAction = UIAlertAction(title: "앞으로 보내기", style: .default) { [weak self] _ in
            self?.moveForward(at: indexPath)
        }
        alertController.addAction(moveForwardAction)

        let bringToFrontAction = UIAlertAction(title: "맨 앞으로 보내기", style: .default) { [weak self] _ in
            self?.bringToFront(at: indexPath)
        }
        alertController.addAction(bringToFrontAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            if let cell = tableView.cellForRow(at: indexPath) {
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
            } else {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }

        present(alertController, animated: true, completion: nil)
    }
    
    func sendToBack(at indexPath: IndexPath) {
        guard indexPath.row < components.count else { return }
        let component = components.remove(at: indexPath.row)
        components.insert(component, at: 0)
        tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
    }

    func moveBackward(at indexPath: IndexPath) {
        guard indexPath.row < components.count, indexPath.row > 0 else { return }
        let component = components.remove(at: indexPath.row)
        components.insert(component, at: indexPath.row - 1)
        tableView.moveRow(at: indexPath, to: IndexPath(row: indexPath.row - 1, section: 0))
    }

    func moveForward(at indexPath: IndexPath) {
        guard indexPath.row < components.count - 1 else { return }
        let component = components.remove(at: indexPath.row)
        components.insert(component, at: indexPath.row + 1)
        tableView.moveRow(at: indexPath, to: IndexPath(row: indexPath.row + 1, section: 0))
    }

    func bringToFront(at indexPath: IndexPath) {
        guard indexPath.row < components.count else { return }
        let component = components.remove(at: indexPath.row)
        components.insert(component, at: components.count)
        tableView.moveRow(at: indexPath, to: IndexPath(row: components.count - 1, section: 0))
    }
}
