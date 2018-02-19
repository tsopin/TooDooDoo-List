//
//  CtegoryViewController.swift
//  TooDooDoo List
//
//  Created by Timofei Sopin on 2018-02-18.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import UIKit
import CoreData

class CtegoryViewController: UITableViewController {
    
    var categoryArray = [ListOfCategories]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadCategories()
    }
    
    //MARK: TableView Datasource Method

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //MARK: TablewView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItemsList", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]        }
        
    }
    
    
    //MARK: Add New Category Button
    @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory  = ListOfCategories(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            self.saveCategory()
            
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
    func saveCategory() {
        
        do {
            try context.save()
        } catch {
            fatalError("Some error")
        }
        self.tableView.reloadData()
    }
    
    // Load Items from CoreData
    func loadCategories(with request : NSFetchRequest<ListOfCategories> =  ListOfCategories.fetchRequest()) {
        
        do {
            categoryArray =  try context.fetch(request)
        } catch {
            fatalError("Some error")
        }
        tableView.reloadData()
    }
    
}















