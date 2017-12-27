//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Pradeep Chandrasekaran on 18/12/17.
//  Copyright © 2017 Pradeep Chandrasekaran. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

//  var itemArray = ["First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item","First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item","First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item","First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item","First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item"]
  
 
  var itemArray = [Item]()
  
  var selectedCategory : Category? {
    didSet {
      loadItems()
    }
  }
//   let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
   
  
 
  
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
    
//    context.delete(itemArray[indexPath.row])
//    itemArray.remove(at: indexPath.row)
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    saveItems()
    tableView.deselectRow(at: indexPath, animated: true)
    
  }

  //MARK: - Add Item Action
  
  @IBAction func addItemButtonTapped(_ sender: UIBarButtonItem) {
    
    var newItemTextField = UITextField()
    
    let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      
    
      let newItem = Item(context: self.context)
      newItem.title = newItemTextField.text!
      newItem.done = false
      newItem.parentCategory = self.selectedCategory
      
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
 
    do {
    try context.save()
    } catch {
      print("Error saving the item: \(error)")
    }
    
    
    
    self.tableView.reloadData()
    
  }
  
  func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

    let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    
    if let additionalPredicate = predicate {
      request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
    }
    else {
      request.predicate = categoryPredicate
    }
    
  
    do {
    itemArray =  try  context.fetch(request)
    } catch {
      print("Error fetching item: \(error)")
    }
    
    self.tableView.reloadData()
  }

}

extension ToDoListViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    
    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
  
    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
    loadItems(with: request, predicate: predicate)
 
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    if searchBar.text!.count == 0 {
      loadItems()
      

      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
      
      
    }
    
  }
  
  
}

