//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Pradeep Chandrasekaran on 26/12/17.
//  Copyright © 2017 Pradeep Chandrasekaran. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

  
  var categoryArray = [Category]()
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      loadCategory()
  
    }
  
  //MARK:-  TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return categoryArray.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
    
    let category = categoryArray[indexPath.row]
    
    cell.textLabel?.text = category.name!
    
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
    destionationVC.selectedCategory = categoryArray[indexPath.row]
     
    }
    
  }
  
  
  //MARK:- Action Methods

  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var newCategoryTextField = UITextField()
    
    let alertController = UIAlertController(title: "Category", message: "Add new category", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
      
      //TODO:- Save items to the coredata
      
      let newCategory = Category(context: self.context)
      newCategory.name = newCategoryTextField.text!
      self.categoryArray.append(newCategory)
      self.saveCategory()
      
     
      
      
    }
    
    alertController.addTextField { (categoryTextField) in
      
      categoryTextField.placeholder = "New Category"
      newCategoryTextField = categoryTextField
      
    }
    
    alertController.addAction(action)
    present(alertController, animated: true, completion: nil)
    
  }
  
  //MARK:- Model Manipulation Methods
  
  func saveCategory() {
    
    do {
      try context.save()
    }
    catch {
      print("Error saving category: \(error)")
    }
    self.tableView.reloadData()
    
  }
  
  
  func loadCategory()
  {
    let request:NSFetchRequest<Category> = Category.fetchRequest()
    do {
      categoryArray = try context.fetch(request)
    }
    catch {
      print("Error loading category- \(error)")
    }
    self.tableView.reloadData()
    
  }
  
}
