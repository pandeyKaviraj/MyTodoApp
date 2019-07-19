//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by KAVIRAJ PANDEY on 16/07/19.
//  Copyright © 2019 KAVIRAJ PANDEY. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: SwipeTableViewController{
    //Instance of realm
    let realm = try! Realm()
    //categoryArray is a type of results and return results object
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK- TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        return cell
    }
    
    
    //MARK- Add New Categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what will happen once the user clicks the Add Items button on uialert
            //Future we can add some validation so we can prevent user to add empty sting
            let newCategory = Category()
            newCategory.name = textField.text!
            // newitem.done = false
            // self.categoryArray.append(newCategory)
            //Save it on persistent container
            self.save(category: newCategory)
        }
        
        alert.addTextField { (field) in
            field.placeholder = "Add new Categories"
            textField = field
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK- TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        //This code triggers when a row is selected in categoryviewControllera and if let is for indexpath should not be nil
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    //MARK- Model manupulation methods
    
    func save(category: Category) {
        
        do {
            //Try to write on database and add category object
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK - Read from realm database data
    
    func loadCategories() {
        //Result type object passed to category array, it's auto updating
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    //Swipe delete methods
    
    override func updateModel(at indexpath: IndexPath) {
        // handle action by updating model with deletion, click on delete button while swipeing from right
        if let categoryForDeletion = categoryArray?[indexpath.row]
                    {
                        do {
                            try self.realm.write {
                                self.realm.delete(categoryForDeletion)
                            }
                        }
                        catch {
                            print("Error deleting categories \(error)")
                        }
                        //tableView.reloadData()
                    }
    }
}
