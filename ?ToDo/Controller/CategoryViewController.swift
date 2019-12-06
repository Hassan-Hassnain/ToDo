//
//  CategoryViewController.swift
//  ?ToDo
//
//  Created by Usama Sadiq on 12/2/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{
    
        let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation Controller does not exist")  }
        if let color = UIColor(hexString: "4400FF"){
        //navBar.backgroundColor = UIColor(hexString: "4400FF")
         navBar.barTintColor = color
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(color, returnFlat: true)]
        }
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
                
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.categoryColor = UIColor.randomFlat().hexValue()
                self.saveData(category: newCategory)
                
            }
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    
    }
    
    //MARK: - TableView Datasource Methods
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories?.count  ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            
            guard let catColor = UIColor(hexString: category.categoryColor!) else {fatalError()}
            
            cell.textLabel?.text = category.name ?? "No Category added yet"
        cell.backgroundColor = catColor
            cell.textLabel?.textColor = ContrastColorOf(catColor, returnFlat: true)
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        let destinationVC = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveData(category: Category)
    {
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("Error saving new Category  \(error)")
        }
        
        tableView.reloadData()
    }
    func loadCategories()
    {
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    //MARK: - Delete Data from swipe
    override func updateModel(at indexPath: IndexPath) {
        
      if let categoryForDeletion = self.categories?[(indexPath.row)]
      {
          do
          {
              try self.realm.write
              {
                  self.realm.delete(categoryForDeletion)
              }
          } catch
          {
              print("Error while deleting the Category \(error)")
          }
      }
        tableView.reloadData()
    }
    
    // Function to update data in database if needed
//   func updateData(rowIndex: Int, nameString: String)
//   {
//       categories[rowIndex].name = nameString
//    saveData(category: categories[rowIndex])
//   }
   //Function to remove data from database if needed
//   func removeData(rowIndex: Int)
//   {
//       print(rowIndex)
//       context.delete(categories[rowIndex])          //It is compulsory to call context.delete before removing the item from itemArray
//       categories.remove(at: rowIndex)
//   }
//
    
    
}
