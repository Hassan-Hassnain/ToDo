//
//  ViewController.swift
//  ?ToDo
//
//  Created by Usama Sadiq on 11/27/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggs", "Distroy Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //Mark:- Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(String(itemArray.count))
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    //MARK - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
                
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK - Add new item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Local Variable to passing data in different blocks
        var textField = UITextField()
        
        //Creating a alert dialog box for user interface
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        //Adding text Field in alert dialog box
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Write the title of the new ToDo item"
            textField = alertTextField
        }
        
        //Creating action that will be triggered by pressing the "Add Item" on the alert dialog box
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Sucess!")
            if textField.text != nil {
                self.itemArray.append(textField.text!)

                self.tableView.reloadData()
            }
        }
        
        //Attaching the action / Function that will be triggered on pressing the button
        alert.addAction(action)
        
        //Following line will present the alert dialog box to user that is prepared in upper line of codes
        present(alert, animated: true, completion: nil)
        
    }
    
    

}

