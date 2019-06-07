//
//  TableViewController.swift
//  Todo List
//
//  Created by Timo on 01.06.19.
//  Copyright © 2019 Timo. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var todos : [ToDoCoreData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Set numbers of sections in table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // set numbers of elements in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    // set content for the table cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get current cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        // get todo to display
        let todo = todos[indexPath.row]
        
        // set cell content
        cell.textLabel?.text = String(repeating: "❗️", count: Int(todo.priority)) + " " + todo.name!
        
        if let dueDate = todo.dueDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            cell.detailTextLabel?.text = dateFormatter.string(from: dueDate)
        } else {
            cell.detailTextLabel?.text = ""
        }
            
        
        return cell
    }
    
    // set table title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ToDos"
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
    
    // refresh todos each time the view gets displayed
    override func viewWillAppear(_ animated: Bool) {
        self.todos = readTodos()
    }
    
    // callback function when table cell gets selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todoCore = todos[indexPath.row]
        let todo = ToDo(id: todoCore.id, name: todoCore.name!)
        todo.priority = Int(todoCore.priority)
        todo.dueDate = todoCore.dueDate
        
        performSegue(withIdentifier: "toDoForm", sender: todo)
    }
    
    // callback function for swipes on a table cell
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let doneAction = UITableViewRowAction(style: .default, title: "Done") { (action, index) in
            // delete item at indexPath
            let todoToDelete = self.todos[indexPath.row]
            if let id = todoToDelete.id {
                self.deleteTodo(id: id.uuidString)
            }
            
            
        }
        doneAction.backgroundColor = UIColor.green
        
        
        return [doneAction]
    }
    
    func updateTable() {
        self.todos = readTodos()
        tableView.reloadData()
    }
    
    func showToast(controller: UIViewController, title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default){ (action: UIAlertAction!) -> Void in
            alert.dismiss(animated: true)
        })
        
        controller.present(alert, animated: true)
        
    }
    
    // --- CRUD Methods ---
    func createTodo(todo: ToDo) {
        var created = false
        if let context = (UIApplication.shared.delegate as?  AppDelegate)?.persistentContainer.viewContext {
            
            let todoCore = ToDoCoreData(entity: ToDoCoreData.entity(), insertInto: context)
            
            todoCore.id = UUID()
            todoCore.name = todo.name
            todoCore.priority = Int16(todo.priority)
            todoCore.dueDate = todo.dueDate
            
            do {
                try context.save()
                self.updateTable()
                created = true
            } catch {
                print(error)
            }
        }
        
        if !created {
            self.showToast(controller: self, title: nil, message: "Todo could not be created")
        }
    }
    
    func updateTodo(todo: ToDo) {
        var updated = false
        let fetchRequest: NSFetchRequest<ToDoCoreData> = ToDoCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", todo.id!.uuidString)
        
        if let context = (UIApplication.shared.delegate as?  AppDelegate)?.persistentContainer.viewContext {
            if let coreDataTodos = try? context.fetch(fetchRequest), let todoToUpdate = coreDataTodos.first {
                todoToUpdate.name = todo.name
                todoToUpdate.priority = Int16(todo.priority)
                todoToUpdate.dueDate = todo.dueDate

                do {
                    try context.save()
                    self.updateTable()
                    updated = true
                } catch {
                    print(error)
                }
            }
        }
        
        if !updated {
            self.showToast(controller: self, title: nil, message: "Todo could not be saved!")
        }
    }
    
    func deleteTodo(id: String) {
        var deleted = false
        let fetchRequest: NSFetchRequest<ToDoCoreData> = ToDoCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        
        if let context = (UIApplication.shared.delegate as?  AppDelegate)?.persistentContainer.viewContext {
            if let coreDataTodos = try? context.fetch(fetchRequest), let todoToDelete = coreDataTodos.first {
                context.delete(todoToDelete)
                
                do {
                    try context.save()
                    self.updateTable()
                    deleted = true
                } catch {
                    print(error)
                }
            }
        }
        
        if !deleted {
            self.showToast(controller: self, title: nil, message: "Todo could not be deleted!")
        }
    }
    
    func readTodos() -> [ToDoCoreData] {
        if let context = (UIApplication.shared.delegate as?  AppDelegate)?.persistentContainer.viewContext {
            if let coreDataTodos = try? context.fetch(ToDoCoreData.fetchRequest()) as? [ToDoCoreData] {
                return coreDataTodos
            }
        }
        
        return []
    }

}
