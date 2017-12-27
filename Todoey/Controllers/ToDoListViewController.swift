//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Pradeep Chandrasekaran on 18/12/17.
//  Copyright © 2017 Pradeep Chandrasekaran. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

//  var itemArray = ["First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item","First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item","First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item","First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item","First Item", "Second Item", "Third Item", "Fourth Item", "Fifth Item"]
  
  let realm = try! Realm()
 
  var itemArray: Results<Item>?
  
  var selectedCategory : Category? {
    didSet {
      loadItems()
    }
  }

  
  override func viewDidLoad() {
    super.viewDidLoad()
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
   
  
 
  
  }

  //MARK: - Tableview Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return itemArray?.count ?? 1
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCell", for: indexPath)
    
    if let item = itemArray?[indexPath.row] {
    
    cell.textLabel?.text = item.title
    
    cell.accessoryType = item.done ? .checkmark : .none
    } else {
       cell.textLabel?.text = "No items aded yet"
    }
    
//    if item.done == true {
//      cell.accessoryType = .checkmark
//    } else {
//      cell.accessoryType = .none
//    }
    
    
    return cell
    
    
  }
  
  
  //MARK: -  Tableview Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let item = itemArray?[indexPath.row] {
      do {
      try realm.write {
        //Update
        item.done = !item.done
        
        //Delete
      //  realm.delete(item)
        
      }
      } catch {
        print("Error updating: \(error)")
      }
      
    }
    tableView.reloadData()
  }

  //MARK: - Add Item Action
  
  @IBAction func addItemButtonTapped(_ sender: UIBarButtonItem) {
    
    var newItemTextField = UITextField()

    let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)

    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in


      if let currentCategory = self.selectedCategory {
        do {
        try self.realm.write {
          let newItem = Item()
          newItem.title = newItemTextField.text!
          currentCategory.items.append(newItem)
        }
        } catch {
          print("Error adding item: \(error)")
        }
      }
      
       self.tableView.reloadData()
    }
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "New item"
      newItemTextField = alertTextField
    }
    alert.addAction(action)

    present(alert, animated: true, completion: nil)
    
  }
  

  func loadItems() {
    
    itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

    self.tableView.reloadData()
  }

}

extension ToDoListViewController: UISearchBarDelegate {

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
    tableView.reloadData()
    
//    let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//    loadItems(with: request, predicate: predicate)

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

