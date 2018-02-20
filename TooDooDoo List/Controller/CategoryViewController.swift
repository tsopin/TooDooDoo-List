//
//  CategoryViewController.swift
//  TooDooDoo List
//
//  Created by Timofei Sopin on 2018-02-18.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<ListOfCategories>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        tableView.separatorStyle = .none
    }
    
    //MARK: TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories"
        
        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].color ?? "D4FB79")
        
        return cell
    }
    
    //MARK: TablewView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItemsList", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]        }
        
    }
    
    
    //MARK: Add New Category Button
    // Creating new Category Object
    @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory  = ListOfCategories()
            if textField.text?.count != 0 {
                
                newCategory.name = textField.text!
                newCategory.color = UIColor.randomFlat.hexValue()
                self.saveCategory(category: newCategory)
                
            } else {
                
                newCategory.name = "Noname Category"
                newCategory.color = UIColor.flatGray.hexValue()
                self.saveCategory(category: newCategory)
                
                
            }
            
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Data Manipulation Methods
    // Save Items to CoreData
    func saveCategory(category: ListOfCategories ) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            fatalError("Some error")
        }
        self.tableView.reloadData()
    }
    
    // Load Items from CoreData
    
    func loadCategories() {
        
        categoryArray = realm.objects(ListOfCategories.self)
        
        
        tableView.reloadData()
    }
    
    //DELETE
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDelete = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDelete)
                }
            } catch {
                print("Error")
            }
        }
    }
    
}













