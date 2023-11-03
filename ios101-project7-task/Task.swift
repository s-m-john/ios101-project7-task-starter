//
//  Task.swift
//

import Foundation

// The Task model
struct Task: Codable {
    var title: String
    var note: String?
    var dueDate: Date

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {
        didSet {
            if isComplete {
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    private(set) var completedDate: Date?
    
    // The date the task was created
    let createdDate: Date

    // An id (Universal Unique Identifier) used to identify a task.
    let id: String

    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
        self.createdDate = Date()
        self.id = UUID().uuidString
    }
}

// MARK: - Task + UserDefaults
extension Task {
    static func save(_ tasks: [Task]) {
        do {
            let encoder = JSONEncoder()
            let encodedTasks = try encoder.encode(tasks)
            UserDefaults.standard.set(encodedTasks, forKey: "tasksKey")
        } catch {
            print("Error encoding tasks: \(error)")
        }
    }

    static func getTasks() -> [Task] {
        if let tasksData = UserDefaults.standard.data(forKey: "tasksKey") {
            do {
                let decoder = JSONDecoder()
                let decodedTasks = try decoder.decode([Task].self, from: tasksData)
                return decodedTasks
            } catch {
                print("Error decoding tasks: \(error)")
            }
        }
        return []
    }
    
    
    static func clearTasks() {
            UserDefaults.standard.removeObject(forKey: "tasksKey")
        }

    
    func save() {
        var tasks = Task.getTasks()

        if let index = tasks.firstIndex(where: { $0.id == self.id }) {
            tasks[index] = self
        } else {
            tasks.append(self)
        }

        Task.save(tasks)
    }
    
}

