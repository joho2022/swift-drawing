//
//  ListViewController.swift
//  DrawingApp
//
//  Created by 조호근 on 4/5/24.
//

import Foundation
import UIKit

class ListViewController: UIViewController {
    var tableView: UITableView!
    var components: [BaseRect] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
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
        
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
        
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
        let selectedComponent = components[indexPath.row]
    }
}

extension ListViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let cell = interaction.view as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let moveToBack = UIAction(title: "맨 뒤로 보내기", image: UIImage(systemName: "arrow.up.to.line.alt")) { _ in
                self.sendToBack(at: indexPath)
            }
            let moveBackward = UIAction(title: "뒤로 보내기", image: UIImage(systemName: "arrow.up")) { _ in
                self.moveBackward(at: indexPath)
            }
            let moveForward = UIAction(title: "앞으로 보내기", image: UIImage(systemName: "arrow.down")) { _ in
                self.moveForward(at: indexPath)
            }
            let bringToFront = UIAction(title: "맨 앞으로 보내기", image: UIImage(systemName: "arrow.down.to.line.alt")) { _ in
                self.bringToFront(at: indexPath)
            }
            return UIMenu(title: "", children: [moveToBack, moveBackward, moveForward, bringToFront])
        }
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

