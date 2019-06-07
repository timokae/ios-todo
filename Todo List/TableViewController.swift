//
//  TableViewController.swift
//  Todo List
//
//  Created by Timo on 01.06.19.
//  Copyright © 2019 Timo. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var toDos : [ToDo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDos = createToDos()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        let todo = toDos[indexPath.row]
        
        cell.textLabel?.text = String(repeating: "❗️", count: todo.priority) + " " + todo.name
        
        if let dueDate = todo.dueDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            cell.detailTextLabel?.text = dateFormatter.string(from: dueDate)
        } else {
            cell.detailTextLabel?.text = ""
        }
            
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ToDos"
    }
    
    func createToDos() -> [ToDo] {
        let eggs = ToDo(name: "Buy some eggs", priority: 2)
        let dog = ToDo(name: "Walk the dog")
        let cheese = ToDo(name: "Buy cheese")
        
        return [eggs, dog, cheese]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newVC = segue.destination as? ToDoViewController, let todo = sender as? ToDo {
            newVC.previuosVC = self
            newVC.todo = todo
        }
        
        if let newVC = segue.destination as? ToDoViewController {
            newVC.previuosVC = self
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = toDos[indexPath.row]
        performSegue(withIdentifier: "toDoForm", sender: todo)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let doneAction = UITableViewRowAction(style: .default, title: "Done") { (action, index) in
            // delete item at indexPath
            self.toDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        doneAction.backgroundColor = UIColor.green
        
        
        return [doneAction]
    }
}
