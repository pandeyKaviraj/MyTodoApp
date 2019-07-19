//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by KAVIRAJ PANDEY on 19/07/19.
//  Copyright © 2019 KAVIRAJ PANDEY. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 75.0
    }
    
    
    //MARK- Table view delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
                cell.delegate = self
                return cell
    }
    
    
    //MARK- Swipe feature for delete the category cell
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at: indexPath)
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "Delete-icon")
        return [deleteAction]
    }
    
    
    // implemented the editActionsOptionsForRowAt method to customize the behavior of the swipe actions, this .destructive will remove the item from last, no need reload method
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border//second behaviour for swipe
        return options
    }
    
    
    func updateModel(at indexpath: IndexPath) {
        //update model
    }
    
}
