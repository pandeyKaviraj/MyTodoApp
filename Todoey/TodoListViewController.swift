//
//  ViewController.swift
//  Todoey
//
//  Created by KAVIRAJ PANDEY on 07/07/19.
//  Copyright © 2019 KAVIRAJ PANDEY. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    //tapping in uiapplication, getting singleton object and tapping uiapplication delegate and casting and now acces to property persistentContainer and grabing view context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext//view context is temp area, our app takks it to
    
    var itemArray = [Item]()
    
    //Property observer
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Know you document directory, current app data to see
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") ?? "Unknown path")
        //Load data from database during viewDidLoad method triggers
        //loadItems()
    }
    
    //MARK - numberofrowsinsection methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    //MARK - Table view datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        //value = condition ? true : false
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView delegate methods, this works when a particular rows selected
    //tells the delegate(Current class) specified rows is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //MARK- Update and delete for core data
    
        //itemArray[indexPath.row].setValue("Completed", forKey: "title")
        //Item delete from database and table view
       // context.delete(itemArray[indexPath.row])
       // itemArray.remove(at: indexPath.row)
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
       //Currently selected cell index path cell to give it a checkmark and selected checkmark remove
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//
        //when item selected instantly graycolor disappears
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Storing a reference to that alertTextField inside local variable, so we can use anywhere inside scope
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Items button on uialert
            //Future we can add some validation so we can prevent user to add empty sting
            let newitem = Item(context: self.context)// item is nsmanaged object
            newitem.title = textField.text!
            newitem.done = false
            newitem.parentCategory = self.selectedCategory
            self.itemArray.append(newitem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK- Model manupulation methods
    
    func saveItems() {

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
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        //query to database for
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }
        
        //Requesting Item table to retrieve data
        //let request: NSFetchRequest = Item.fetchRequest()
        do {
            //Data passed in itemArray to load, during viewDidLoad methods triggers
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}







//MARK- Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    //Methods tells the todolistviewcontroller (delegate) searchbar has clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        //Item sorting
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //below modified request to load data on table view
        loadItems(with: request, predicate: predicate)
    }
    
    //MARK - After search and cancel clicked, load all items
    //This methods trigggered when user somethig type on screen and cancel click
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0
        {
            loadItems()
            //Clear keyboard and search bar cursor in foreground
            //resignFirstResponder puts object to first responder in its widows
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}



