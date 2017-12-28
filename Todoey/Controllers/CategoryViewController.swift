//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Pradeep Chandrasekaran on 26/12/17.
//  Copyright © 2017 Pradeep Chandrasekaran. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {

  let realm = try! Realm()
  var categoryArray: Results<Category>?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
     loadCategory()
    tableView.rowHeight = 80.0
  
    }
  
  //MARK:-  TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return categoryArray?.count ?? 1
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    if let category = categoryArray?[indexPath.row] {
    
//    cell.textLabel?.text =  category.name ?? "No Category added yet"
//    cell.backgroundColor = UIColor(hexString:category.color ?? "1D9BF6")
//    cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
      
      cell.textLabel?.text =  category.name
      
      guard let categoryColor = UIColor(hexString:category.color) else {fatalError()}
      
      cell.backgroundColor = categoryColor
      cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
    }
    
    //1D9BF6
    
    return cell
    
  }
  
  //MARK:- TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    //tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: "itemsSegue", sender: self)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    let destionationVC = segue.destination as! ToDoListViewController
    
    if  let indexPath = tableView.indexPathForSelectedRow {
    destionationVC.selectedCategory = categoryArray?[indexPath.row]
     
    }
    
  }
  
  
  //MARK:- Action Methods

  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var newCategoryTextField = UITextField()
    
    let alertController = UIAlertController(title: "Category", message: "Add new category", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
      
      //TODO:- Save items to the coredata
      
      let newCategory = Category()
      newCategory.name = newCategoryTextField.text!
      newCategory.color = UIColor.randomFlat.hexValue()
      self.saveCategory(category: newCategory)
      
     
      
      
    }
    
    alertController.addTextField { (categoryTextField) in
      
      categoryTextField.placeholder = "New Category"
      newCategoryTextField = categoryTextField
      
    }
    
    alertController.addAction(action)
    present(alertController, animated: true, completion: nil)
    
  }
  
  //MARK:- Model Manipulation Methods
  
  override func updateModel(at indexPath: IndexPath) {
    
          if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            do {
              try self.realm.write {
                self.realm.delete(categoryForDeletion)
              }
            } catch {
              print("Error deleting the category: \(error)")
            }
    
          }
    
  }
  
  func saveCategory(category: Category) {
    
    do {
      try realm.write {
        realm.add(category)
      }
    }
    catch {
      print("Error saving category: \(error)")
    }
    self.tableView.reloadData()
    
  }
  
  
  func loadCategory()
  {
 
    categoryArray = realm.objects(Category.self)
    self.tableView.reloadData()
    
  }
  
}



