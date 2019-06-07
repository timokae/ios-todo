//
//  ToDo.swift
//  Todo List
//
//  Created by Timo on 01.06.19.
//  Copyright © 2019 Timo. All rights reserved.
//

import Foundation

class ToDo {
    var name = ""
    var priority: Int
    var dueDate: Date?
    
    init(name: String, priority: Int = 0, dueDate: Date? = nil) {
        self.name = name
        self.priority = priority
        self.dueDate = dueDate
    }
}
