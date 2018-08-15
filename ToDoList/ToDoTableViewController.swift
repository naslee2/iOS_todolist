//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Nathan on 3/16/18.
//  Copyright © 2018 Nathan. All rights reserved.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController, ToDoTableViewControllerDelegate {
    @IBOutlet var toDoTableView: UITableView!
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var items = [Model]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //segue to add item/task page
        if let indexPath = sender as? NSIndexPath {
            let navigationController = segue.destination as! UINavigationController
            let addcell = navigationController.topViewController as! ViewController
            addcell.delegate = self
            let item = items[indexPath.row]
            addcell.item_desc = item.itemDes!
            addcell.item_title = item.itemTitle!
            addcell.item_date = item.itemDate!
            addcell.indexPath = indexPath
        }
        if let _ = sender as? UIBarButtonItem {
            let navigationController = segue.destination as! UINavigationController
            let addcell = navigationController.topViewController as! ViewController
            addcell.delegate = self
        }
    }
    
    func newitemadd(by Controller: ViewController, with itemtitle: String, itemdescription: String, itemdate: Date, at indexPath: NSIndexPath?) { //delegate add function
        if let ip = indexPath {
            let item = items[ip.row]
            item.itemTitle = itemtitle
            item.itemDes = itemdescription
            item.itemDate = itemdate
        }
        else {
            let item = NSEntityDescription.insertNewObject(forEntityName: "Model", into: managedObjectContext) as! Model
            item.itemTitle = itemtitle
            item.itemDes = itemdescription
            item.itemDate = itemdate
            item.itemchecked = false
            items.append(item)
        }
        do{
            try managedObjectContext.save()
        }
        catch {
            print("\(error)")
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            
            let item = items[indexPath.row]
            
            item.itemchecked = !item.itemchecked
            cell.accessoryType = item.itemchecked ? .checkmark : .none
            
//            if cell.accessoryType == .checkmark {
//                cell.accessoryType = .none
//                items[indexPath.row].itemchecked = false
//            }
//            else {
//                cell.accessoryType = .checkmark
//                items[indexPath.row].itemchecked = true
//            }
            do{
                try managedObjectContext.save()
            }
            catch {
                print("\(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! CustomCell
        let dateformat = DateFormatter()
        dateformat.dateStyle = .medium
        dateformat.timeStyle = .none
        cell.titleLabel.text = items[indexPath.row].itemTitle
        cell.titleDesc.text = items[indexPath.row].itemDes
        cell.dateLabel.text = dateformat.string(from: items[indexPath.row].itemDate!)
        if items[indexPath.row].itemchecked == true {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
   override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            (action, indexPath) in
            let item = self.items[indexPath.row]
            self.managedObjectContext.delete(item)
            self.appDelegate.saveContext()
            self.items.remove(at: indexPath.row)
            tableView.reloadData()
        }
        let edit = UITableViewRowAction(style: .normal, title: "Edit") {
            (action, indexPath) in
            self.performSegue(withIdentifier: "editSegue", sender: indexPath)
        }
        return [delete, edit]
    }
    
    func fetchItems () {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Model")
        print("New item in db")
        print(items)
        do {
            let result = try managedObjectContext.fetch(request)
            items = result as! [Model]
        }
        catch {
            print("\(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 75
        fetchItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


