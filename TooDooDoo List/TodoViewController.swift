//
//  TodoViewController.swift
//  TooDooDoo List
//
//  Created by Timofei Sopin on 2018-02-15.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    
   let doArray = ["Task1", "Task2", "Task3"]

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = doArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(doArray[indexPath.row])
     
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

