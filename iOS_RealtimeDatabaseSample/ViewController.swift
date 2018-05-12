//
//  ViewController.swift
//  iOS_RealtimeDatabaseSample
//
//  Created by mn(D128) on 2018/05/12.
//  Copyright © 2018年 mn(D128). All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController,
    UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addBtn: UIButton!
    @IBOutlet private weak var textField: UITextField!
    
    private let dbRef: DatabaseReference = Database.database().reference()
    private var dataSource: [String] = [String]()
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textFieldTextDidChange(_:)),
                                               name: .UITextFieldTextDidChange,
                                               object: nil)
        self.addBtn.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*let handle: DatabaseHandle = */dbRef.observe(DataEventType.value, with: { (snapshot: DataSnapshot) in
            self.dataSource.removeAll()
            
            for child in snapshot.children {
                guard let child: DataSnapshot = child as? DataSnapshot else {
                    continue
                }
                
                if let comment: String = child.childSnapshot(forPath: "comment").value as? String {
                    self.dataSource.append(comment)
                }
            }
            
            self.tableView.reloadData()
        })
        
//        dbRef.removeObserver(withHandle: handle)
    }
    
    // MARK: - Action
    
    @IBAction func addDidTap(_ sender: Any) {
        guard let text = self.textField.text else {
            return
        }
        
        self.dbRef.childByAutoId().setValue(["comment": text])
        
        self.textField.text = nil
        self.addBtn.isEnabled = false
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "Cell") {
            cell = reuseCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        
        if indexPath.row < self.dataSource.count {
            cell.textLabel?.text = self.dataSource[indexPath.row]
        }

        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    // MARK: - NotificationCenter
    
    @objc private func textFieldTextDidChange(_ notification: Notification) {
        let count = self.textField.text?.utf8.count ?? 0
        self.addBtn.isEnabled = 0 < count
    }

}

