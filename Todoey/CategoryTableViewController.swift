//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by KAVIRAJ PANDEY on 16/07/19.
//  Copyright © 2019 KAVIRAJ PANDEY. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    //MARK- TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    

    //MARK- Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //what will happen once the user clicks the Add Items button on uialert
            //Future we can add some validation so we can prevent user to add empty sting
            let newCategory = Category(context: self.context)// item is nsmanaged object
            newCategory.name = textField.text!
           // newitem.done = false
            self.categoryArray.append(newCategory)
            //Save it on persistent container
            self.saveCategories()
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK- Model manupulation methods
    
    func saveCategories() {
        
        do {
            try context.save()
        }
        catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK - Read from core data
    
    //parameter call with loaditems is for searchbar item and without parameter is for all data fetch from database
    func loadItems() {
        //Requesting Item table to retrieve data
        let request: NSFetchRequest = Category.fetchRequest()
        do {
            //Data passed in itemArray to load, during viewDidLoad methods triggers
            categoryArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }


}
    


