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

var todoList: [todoItem] = []
var inputString:String?
var currentCommand:Substring
printHelp()
repeat {
    print("Please Enter a Command:")
    //Optional chaining is 🔥
    inputString = if let val = readLine() {
        if(val.isEmpty){
            "help"
        }else{
            val
        }
    }else{
        "exit"
    }
    currentCommand = parseCommand(command: inputString!)
    switch currentCommand {
        case "newTask":
            createNewTask(taskData:parseCommand(command:inputString!,requiredCount:1,optionalCount:1))
        case "showTasks":
            showTasks()
        case "completeTasks":
            completeTasks()
        case "help":
            printHelp()
        default:
        break
    }
} while currentCommand != "exit"
/**
 Prints command list.
 */
func printHelp(){
    print("""
        ========================================================================================
        Command List:
        newTask <Task Name> --desc <Task Description> -> Creates a new task.
        showTasks -> Prints current tasks.
        completeTask -> Wizard function.
        help -> Prints command list.
        exit -> Exits application
        ========================================================================================
        """)
}
/**
 Parses the first command of the input string
 - Parameters:
    - command: Input String.
 - Returns: Substring containing the base command.
 */
func parseCommand(command:String) -> Substring{
    return command.split(separator: " ",maxSplits: 1)[0]
}

/**
 Parses an input string into slices with optional commands
 - Parameters:
    - command: Input string to parse.
    - requiredCount: Required number of inputs if commands are nested.
    - optionalCount: Number of optional values to check.
 - Returns: A tuple containing command data necessary for function call.
 */
func parseCommand(command:String,requiredCount:Int,optionalCount:Int = 0) -> (req:ArraySlice<Substring>,opts:[Substring:Substring]){
    let reqs = command.split(separator: " ",maxSplits: requiredCount)[0..<requiredCount+1]
    //parse out the optionals from the last index
    var finalReq:ArraySlice<Substring> = []
    for index in 0..<reqs.count{
        if(index == reqs.count-1){
            finalReq.append(reqs[index].split(separator: "--")[0])
        }else{
            finalReq.append(reqs[index])
        }
    }
    //create a loop that will seperate each optional command into it's own seperate dictionary
    //parse only needs to seperate by '--' because a command will always follow it and the rest of the text can be included until another '--'
    var optionalDict:[Substring:Substring] = [:]
    if(command.contains("--")){
        let optionals = command.split(separator: "--",maxSplits:optionalCount)[1..<optionalCount+1]
        for commandElement in optionals{
            let item = commandElement.split(separator: " ",maxSplits: 1)
            optionalDict[item[0]] = item[1]
        }
    }
    return (finalReq,optionalDict)
    
}

/**
Function will create a new task item.
 - Parameters:
    - taskData: Tuple containing data about the task.
*/
@MainActor
func createNewTask(taskData:(req:ArraySlice<Substring>,opts:[Substring:Substring])) -> Void{
    let item:todoItem = todoItem(taskName: String(taskData.req[1]),
                                 taskDescription: String(taskData.opts["desc"] ?? "No Description"),
                                 isCompleted: false)
    todoList.append(item)
    print("New task inserted!")
}

/**
 Shows a formatted list of current tasks
 */
@MainActor
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

/**
 Starts the wizard to complete a certain task.
 */
@MainActor
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



