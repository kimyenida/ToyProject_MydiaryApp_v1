//
//  TableViewController.swift
//  MyFistApp
//
//  Created by Admin iMBC on 11/13/23.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
        return cell
    }
    
    lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    let data = [["Test 1-1", "Test 1-2", "Test1-3"],
                ["Test 2-1", "Test 2-2", "Test2-3"],
                ["Test 3-1", "Test 3-2", "Test3-3"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        self.tableView.dataSource = self
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([self.tableView.topAnchor.constraint(equalTo:       self.view.safeAreaLayoutGuide.topAnchor),
                                     self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                                     self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)])
    }
}


