//
//  Model.swift
//  ToDoList
//
//  Created by Ularbek Abdyrazakov on 29.01.2021.
//

import Foundation
//
//var ToDoItems:[[String:Any]] {
//    set{
//
//        UserDefaults.standard.set(newValue, forKey: "ToDoDataKey")
//        UserDefaults.standard.synchronize()
//    }
//    get{
//        if let array = UserDefaults.standard.array(forKey: "ToDoDataKey") as? [[String:Any]]{
//            return array
//        }
//        else{
//            return  []
//        }
//    }
//}
class Items: Codable{
    
    
    var name: String?
    var completed: Bool?
    
    init(name:String,completed:Bool){
        self.name = name
        self.completed = completed
        
    }
    
}

var toDoItems = [Items]()


func addItem(nameItem: String,isCompleted: Bool = false){
    toDoItems.append(Items(name: nameItem , completed: isCompleted))
   saveItem()
}

func removeItem(at index: Int){
    toDoItems.remove(at: index)
    saveItem()
  
}

//func changeState(at item: Int) -> Bool{
//
//    toDoItems[item]["isCompleted"] = !(toDoItems[item]["isCompleted"] as! Bool)
//
//
//    return toDoItems[item]["isCompleted"] as! Bool
//}
func moveItem(fromIndex: Int, toIndex: Int) {
    let from = toDoItems[fromIndex]
    toDoItems.remove(at: fromIndex)
    toDoItems.insert(from, at: toIndex)
    saveItem()
}

func changeState(at item: Int) -> Bool {
    toDoItems[item].completed = !(toDoItems[item].completed!)
    saveItem()
    return toDoItems[item].completed!
}

func saveItem(){
    
    UserDefaults.standard.set(try? PropertyListEncoder().encode(toDoItems), forKey: "toDo")
    
}


func loadData() {
    if let data = UserDefaults.standard.value(forKey: "toDo") as? Data {
        let item = try? PropertyListDecoder().decode(Array<Items>.self, from: data)
        toDoItems = item!
    }
}


//func moveItem(fromIndex: Int, toIndex: Int){
//
//    let from = toDoItems[fromIndex]
//    toDoItems.remove(at: fromIndex)
//    toDoItems.insert(from, at: toIndex)
//
//}
