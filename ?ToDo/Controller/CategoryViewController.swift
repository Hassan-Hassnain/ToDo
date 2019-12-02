//
//  CategoryViewController.swift
//  ?ToDo
//
//  Created by Usama Sadiq on 12/2/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add the name of new category"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text != nil {
                
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text
                self.categories.append(newCategory)
                
                self.saveData()
                
            }
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    //MARK: - TableView Datasource Methods
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveData()
    {
        do {
            try context.save()
        }
        catch{
            print("Error saving Context \(error)")
        }
        
        tableView.reloadData()
    }
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest())
    {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error during fetch request from context \(error)")
        }
    }
    // Function to update data in database if needed
   func updateData(rowIndex: Int, nameString: String)
   {
       categories[rowIndex].name = nameString
       saveData()
   }
   //Function to remove data from database if needed
   func removeData(rowIndex: Int)
   {
       print(rowIndex)
       context.delete(categories[rowIndex])          //It is compulsory to call context.delete before removing the item from itemArray
       categories.remove(at: rowIndex)
   }
    
    
    
}
