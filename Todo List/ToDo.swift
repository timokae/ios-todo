//
//  ToDo.swift
//  Todo List
//
//  Created by Timo on 01.06.19.
//  Copyright © 2019 Timo. All rights reserved.
//

import Foundation

class ToDo {
    var id: UUID?
    var name = ""
    var priority: Int
    var dueDate: Date?
    
    init(id: UUID?, name: String, priority: Int = 0, dueDate: Date? = nil) {
        self.id = id
        self.name = name
        self.priority = priority
        self.dueDate = dueDate
    }
}
