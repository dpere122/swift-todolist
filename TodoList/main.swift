//
//  main.swift
//  TodoList
//
//  Created by Daniel Perez on 8/18/25.
//

import Foundation

struct todoItem {
    var taskName:String
    var taskDescription:String?
    var isCompleted:Bool
}

// Todo application will only run in the console.

//readline ?? "" -> to take input

var todoList: [todoItem] = []
var currentCommand:String?
print("""
    ======================
    Please enter a command:
    newTask
    showTasks
    completeTasks
    exit
    ======================
    """)
repeat {
    print("Please Enter a Command:")
    currentCommand = readLine()
    switch currentCommand {
        case "newTask":
            createNewTask()
        case "showTasks":
            showTasks()
        case "completeTasks":
            completeTasks()
        default:
        break
    }
} while currentCommand != "exit"


func createNewTask() -> Void{
    print("Enter a new task name: ")
    let taskName:String? = readLine()
    print("Enter a task description: ")
    let taskDescription:String? = readLine()
    let status = if taskDescription?.isEmpty == true{
        "No Description"
    }else{
        taskDescription
    }
    let item:todoItem = todoItem(taskName: taskName!, taskDescription: status, isCompleted: false)
    todoList.append(item)
    print("New task inserted!")
}

func showTasks() -> Void{
    print("Tasks:")
    var indexer = 0
    for todo in todoList{
        let status = if todo.isCompleted == true{
            "Completed"
        }else{
            "In Progress"
        }
        print("\(indexer) | \(todo.taskName) | \(todo.taskDescription ?? "No Description") -> \(status)")
        indexer += 1
    }
}

func completeTasks() -> Void {
    showTasks()
    print("Select which task you want to complete by entering its index number: ")
    if let indexString = readLine(){
        if let index = Int(indexString){
            if index < todoList.count {
                todoList[index].isCompleted = true
                print(todoList[index].taskName,"has been completed!")
            }else{
                print("Please enter a valid index.")
            }
        }else{
            print("Please enter a number!")
        }
    }
}



