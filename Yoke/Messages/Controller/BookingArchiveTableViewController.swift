//
//  BookingArchiveTableViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/18/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class BookingArchiveTableViewController: UITableViewController {
    
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func fetchArchives() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        BookingController.shared.fetchArchivesWith(uid: currentUserUid) { (result) in
            switch result {
            default:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookingController.shared.archives.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RequestTableViewCell
        cell.booking = BookingController.shared.archives[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.LightGrayBg()
        return cell
    }
}
