//
//  NewToDoViewController.swift
//  Todo List
//
//  Created by Timo on 02.06.19.
//  Copyright © 2019 Timo. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    
    var previuosVC = TableViewController()
    var todo: ToDo?

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var switchDate: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var prioritySelect: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.isEnabled = false
        
        if let t = todo {
            textFieldName.text = t.name
            if let date = t.dueDate {
                switchDate.isOn = true
                datePicker.date = date
            }
            prioritySelect.selectedSegmentIndex = t.priority
            print(t)
        }
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func showToast(controller: UIViewController, title: String?, message: String, seconds: Double) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default){ (action: UIAlertAction!) -> Void in
            alert.dismiss(animated: true)
        })
        
        controller.present(alert, animated: true)
        
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {        
        if let text = textFieldName.text, text.count > 0 {
            let toDo = ToDo(
                name: text,
                priority: prioritySelect.selectedSegmentIndex
            )
            
            if switchDate.isOn {
                toDo.dueDate = datePicker.date
            }
            
            previuosVC.toDos.append(toDo)
            previuosVC.tableView.reloadData()
            
            navigationController?.popViewController(animated: true)
        } else {
            showToast(controller: self,title: nil, message: "Please enter a name", seconds: 1.5)
        }
    }

    @IBAction func switchChanged(_ sender: Any) {
        datePicker.isEnabled = switchDate.isOn
    }

}
