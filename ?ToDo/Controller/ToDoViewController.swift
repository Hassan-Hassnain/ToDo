//
//  ViewController.swift
//  ?ToDo
//
//  Created by Usama Sadiq on 11/27/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: UITableViewController{
    
    var item: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
    }
    
    //MARK: - Table View Data Source Me thods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(String(itemArray.count))
        return item?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let newItem = item?[indexPath.row]{
            
            cell.textLabel?.text = newItem.title
            
            cell.accessoryType = (newItem.done ? .checkmark : .none)
        } else {
            cell.textLabel?.text = "No Item Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let newItem = item?[indexPath.row]{
            do {
                try realm.write {  newItem.done = !newItem.done   }
                // To delete item from realm database
              //  try realm.delete(newItem)
            } catch {
                print("Error updating the done status of the clicked item \(error)")
            }
        }
        tableView.reloadData()
        
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
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error Saving new item \(error)")
                    }
                }
                self.tableView.reloadData()
            }
        }
        
        //Attaching the action / Function that will be triggered on pressing the button
        alert.addAction(action)
        
        //Following line will present the alert dialog box to user that is prepared in upper line of codes
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - DATABASE FUNCTIONS
    
    
    
    func loadItems(){
        item = selectedCategory?.items.sorted(byKeyPath:  "title", ascending: true)
        tableView.reloadData()
    }
    // Function to update data in database
    //    func updateData(rowIndex: Int, titleString: String)
    //    {
    //        itemArray[rowIndex].title = titleString
    //        saveData()
    //    }
    //Function to remove data from database
    //    func removeData(rowIndex: Int)
    //    {
    //        print(rowIndex)
    //        context.delete(itemArray[rowIndex])          //It is compulsory to call context.delete before removing the item from itemArray
    //        itemArray.remove(at: rowIndex)
    //    }
    
}

//MARK: - UISearchBar Delegate Methods
extension ToDoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        
        item = item?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text!.count == 0
        {
            loadItems()
            tableView.reloadData()
            DispatchQueue.main.async
                {
                    searchBar.resignFirstResponder()
                }
        }
    }
////        else   ///Extra functionality from lectures
////        {
////            let request: NSFetchRequest<Item> = Item.fetchRequest()
////
////            request.predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
////
////            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
////
////            loadItems(with: request)
////
////            tableView.reloadData()
////        }
//
//
}



