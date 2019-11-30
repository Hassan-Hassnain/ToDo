//
//  ViewController.swift
//  ?ToDo
//
//  Created by Usama Sadiq on 11/27/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var itemArray = [MyItem]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(dataFilePath)
        
        // Do any additional setup after loading the view.
        let newItem = MyItem()
        newItem.title = "Find Mike"
        newItem.done = false
        itemArray.append(newItem)
        
        let newItem1 = MyItem()
        newItem1.title = "Buy Eggos"
        newItem1.done = false
        itemArray.append(newItem1)
        
        let newItem2 = MyItem()
        newItem2.title = "Buy Milk"
        newItem2.done = false
        itemArray.append(newItem2)
        
//        if let item = defaults.array(forKey: "ToDoListArray") as? [MyItem]{
//            itemArray = item
//        }
    }
    
    //MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(String(itemArray.count))
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = (item.done ? .checkmark : .none)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        self.saveData()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add new item
    
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
                let item = MyItem()
                item.title = textField.text!
                item.done = false
                
                self.itemArray.append(item)
                
                self.saveData()
            }
        }
        
        //Attaching the action / Function that will be triggered on pressing the button
        alert.addAction(action)
        
        //Following line will present the alert dialog box to user that is prepared in upper line of codes
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveData(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch{
            print("Error encoding item array/(error)")
        }
        
        //Update the UITableViewController items
        self.tableView.reloadData()
    }
    
}



