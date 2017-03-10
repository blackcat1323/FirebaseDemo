//
//  ItemTableViewController.swift
//  FirebaseDemo
//
//  Created by admin on 3/10/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase

class ItemTableViewController: UITableViewController {

    var user : FIRUser!
    var ref: FIRDatabaseReference!
    var item = [Item]()
    private var dataHandle: FIRDatabaseHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "To Do List"
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        listenData()
    }
    
    @IBAction func addItem(_ sender: Any) {
        let prom = UIAlertController(title: "To do app", message: "Add to do item", preferredStyle: .alert)
        let actOk = UIAlertAction(title: "OK", style: .default) { (action) in
            let userInput = prom.textFields?[0].text
            if userInput!.isEmpty{
                return
            }
            self.ref.child("users/\(self.user.uid)/items").childByAutoId().child("title").setValue(userInput)
        }
        prom.addTextField(configurationHandler: nil)
        prom.addAction(actOk)
        present(prom, animated: true, completion: nil)
    }
    
    func listenData(){
        self.ref.child("users/\(self.user.uid)/items").observe(.value, with: { (snapshot) in
            var newItem = [Item]()
            for itemSnapshot in snapshot.children{
                let item = Item(snapShot: itemSnapshot as! FIRDataSnapshot)
                newItem.append(item)
            }
            self.item = newItem
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.item.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let item = self.item[indexPath.row]
        cell.textLabel?.text = item.title
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let item = self.item[indexPath.row]
            item.ref?.removeValue()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
