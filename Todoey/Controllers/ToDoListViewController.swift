//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Pradeep Chandrasekaran on 18/12/17.
//  Copyright © 2017 Pradeep Chandrasekaran. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

//  var itemArray = ["First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item","First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item","First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item","First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item","First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item"]
  
  var itemArray = [Item]()
  
   let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
   loadItems()
 
  
  }

  //MARK: - Tableview Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return itemArray.count
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCell", for: indexPath)
    
    let item = itemArray[indexPath.row]
    
    cell.textLabel?.text = item.title
    
    cell.accessoryType = item.done ? .checkmark : .none
    
//    if item.done == true {
//      cell.accessoryType = .checkmark
//    } else {
//      cell.accessoryType = .none
//    }
    
    
    return cell
    
    
  }
  
  
  //MARK: -  Tableview Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    saveItems()
    tableView.deselectRow(at: indexPath, animated: true)
    
  }

  //MARK: - Add Item Action
  
  @IBAction func addItemButtonTapped(_ sender: UIBarButtonItem) {
    
    var newItemTextField = UITextField()
    
    let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      
    //TODO: - Do some Action
      
      let newItem = Item()
      newItem.title = newItemTextField.text!
      
      
     self.itemArray.append(newItem)
      self.saveItems()
      
      
      
    }
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "New item"
      newItemTextField = alertTextField
    }
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
    
  }
  
  //MARK: - Model Manipulation Methods
  
  func saveItems() {
    
    let encoder = PropertyListEncoder()
    
    do {
      let data = try encoder.encode(itemArray)
      try data.write(to: dataFilePath!)
    } catch {
      print(error)
    }
    
    
    
    self.tableView.reloadData()
    
  }
  
  func loadItems() {
    
    if let data = try? Data(contentsOf: dataFilePath!) {
      
      let decoder = PropertyListDecoder()
      do{
      itemArray = try decoder.decode([Item].self, from: data)
      } catch {
        print(error)
      }
  }
  
  }
}

