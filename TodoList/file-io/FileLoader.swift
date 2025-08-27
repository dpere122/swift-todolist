
import Foundation
class FileLoader{
    
    let configPath:URL
    let fileManager:FileManager
    let configurationFileName:String = "config.json"
    
    init(){
        // Set the application directory as our configuration path directory
        fileManager = FileManager()
        configPath = fileManager.homeDirectoryForCurrentUser.appending(path: "Library/com.dpdev.todoapp/")
        // Check if configuration file exists.
        checkConfigurationStatus()
    }
    func checkConfigurationStatus(){
        if(!fileManager.fileExists(atPath:configPath.path())){
            do{
                try fileManager.createDirectory(atPath: configPath.path(), withIntermediateDirectories: false)
            }catch{
                print("There was an error creating the confiuration directory.")
            }
        }
        else if(!fileManager.fileExists(atPath:configPath.path().appending(configurationFileName))){
            // Create the file and fill it with a basic JSON structure.
            fileManager.createFile(atPath: configPath.path().appending(configurationFileName),contents: nil)
            print("Configuration File was sucessfully created.")
        }
        else{
            // retrieve configuration
        }
    }
    
}
