//
//  TodoViewController.swift
//  TooDooDoo List
//
//  Created by Timofei Sopin on 2018-02-15.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoViewController: SwipeTableViewController {
    
    // Variables
    let realm = try! Realm()
    
    var todoItems : Results<ListOfItems>?
    var selectedCategory : ListOfCategories? {
        didSet {
            loadItems()
        }
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //    let date = Date()
    //    let dateFormatter = DateFormatter()
    //
    //    func getCurrentDate() {
    //        dateFormatter.dateFormat = "dd.MM.yyyy"
    //
    //      let result = dateFormatter.string(from: date)
    //
    //    }
    //
    
    
    
    // ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let colorHex = selectedCategory?.color else {fatalError("FatalError")}
        guard let navigationBar = navigationController?.navigationBar else {fatalError("ERRRROOOORRR")}
        guard let navigationBarColor = UIColor(hexString: colorHex) else {fatalError("ERRRROOOORRR")}
        
        title = selectedCategory?.name
        
        navigationBar.barTintColor = navigationBarColor
        navigationBar.tintColor = ContrastColorOf(navigationBarColor, returnFlat: true)
        searchBar.barTintColor = navigationBarColor
        navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navigationBarColor, returnFlat: true)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor = UIColor(hexString: "C0C0C0") else {fatalError("ERRRROOOORRR")}
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : FlatWhite()]
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    // Fill Table View
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    // Make row highlited when pressed
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("srafsdfsdfsdfsdfgsfgsdfgsdfgdsfgdsfgdsfghsdfgfda")
            }
        }
        tableView.reloadData()
        
        
    }
    
    
    // Add new Tasks
    @IBAction func addTaskButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Task", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem  = ListOfItems()
                        if textField.text?.count != 0 {
                            newItem.title = textField.text!
                            newItem.creationDate = Date()
                            currentCategory.items.append(newItem)
                        } else {
                            
                            newItem.title = "Noname task"
                            newItem.creationDate = Date()
                            currentCategory.items.append(newItem)
                            
                            
                        }
                    }
                } catch {
                    print("DFD")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new task"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Eror")
            }
        }
    }
}

//    MARK: - Search Bar methods
extension TodoViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "creationDate", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        
    }
}




