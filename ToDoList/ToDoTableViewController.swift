//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Denis Bystruev on 22/10/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//

import RealmSwift
import UIKit

class ToDoTableViewController: UITableViewController {
    
    var todos = [ToDo]() {
        didSet {
            // Persist the data
            try! ToDo.realm.write {
                ToDo.realm.add(todos)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedToDos = ToDo.loadToDos() {
            todos = savedToDos
        } else {
            todos = ToDo.loadSampleToDos()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        navigationItem.leftBarButtonItem = editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier") else {
            fatalError("\(#function) at \(#line): dequeueReusableCell(withIdentifier:) error")
        }
        
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.title
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! ToDo.realm.write {
                ToDo.realm.delete(todos[indexPath.row])
            }
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
//        else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        
        guard let toDoViewController = segue.source as? ToDoViewController else { return }
        
        guard let todo = toDoViewController.todo else { return }
        
        let indexPath = IndexPath(row: todos.count, section: 0)
        todos.append(todo)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

}
