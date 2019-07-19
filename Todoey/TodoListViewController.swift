//
//  ViewController.swift
//  Todoey
//
//  Created by KAVIRAJ PANDEY on 07/07/19.
//  Copyright © 2019 KAVIRAJ PANDEY. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    //tapping in uiapplication, getting singleton object and tapping uiapplication delegate and casting and now acces to property persistentContainer and grabing view context
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
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
        return todoItems?.count ?? 1
    }
    
    
    //MARK - Table view datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            //Ternary operator ==>
            //value = condition ? true : false
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No Itms Added"
        }
        return cell
    }
    
    //MARK - TableView delegate methods, this works when a particular rows selected
    //tells the delegate(Current class) specified rows is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //MARK- Update Item in realm
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(item)
                    item.done = !item.done
                }
            }
            catch {
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Storing a reference to that alertTextField inside local variable, so we can use anywhere inside scope
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //            //what will happen once the user clicks the Add Items button on uialert
            //            //Future we can add some validation so we can prevent user to add empty sting
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let newitem = Item()
                        newitem.title = textField.text!
                        newitem.dateCreated = Date()
                        currentCategory.items.append(newitem)
                    }
                }
                catch {
                    print("Error saving new Items \(error)")
                }
            }
            self.tableView.reloadData()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK- Model manupulation methods
    
    
    //MARK - Read from realm database
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexpath: IndexPath) {
        if let TododelteItem = todoItems?[indexpath.row] {
            do {
                try realm.write {
                    realm.delete(TododelteItem)
                }
            }
            catch {
                print("Error in Todo item deletion \(error)")
            }
        }
    }
}


//MARK- Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    //Methods tells the todolistviewcontroller (delegate) searchbar has clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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



