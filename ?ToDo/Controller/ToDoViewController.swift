//
//  ViewController.swift
//  ?ToDo
//
//  Created by Usama Sadiq on 11/27/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UITableViewController{
        
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()
    
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
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let newItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = newItem.title
        
        cell.accessoryType = (newItem.done ? .checkmark : .none)
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
                
                let newItem = Item(context: self.context)
                
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                
                self.saveData()
            }
        }
        
        //Attaching the action / Function that will be triggered on pressing the button
        alert.addAction(action)
        
        //Following line will present the alert dialog box to user that is prepared in upper line of codes
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - DATABASE FUNCTIONS
    
    
    func saveData(){
        
        do{
            try context.save()
        } catch{
            print("Error Saving new item in context.save\(error)")
        }
        
        //Update the UITableViewController items
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else{
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error during performing the fetch request\(error)")
        }
    }
    // Function to update data in database
    func updateData(rowIndex: Int, titleString: String)
    {
        itemArray[rowIndex].title = titleString
        saveData()
    }
    //Function to remove data from database
    func removeData(rowIndex: Int)
    {
        print(rowIndex)
        context.delete(itemArray[rowIndex])          //It is compulsory to call context.delete before removing the item from itemArray
        itemArray.remove(at: rowIndex)
    }
    
}

//MARK:- UISearchBar Delegate Methods
extension ToDoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
                
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                
        loadItems(with: request, predicate: predicate)
        
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
//        else   ///Extra functionality from lectures
//        {
//            let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//            request.predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
//
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//            loadItems(with: request)
//
//            tableView.reloadData()
//        }
    }
        
}



