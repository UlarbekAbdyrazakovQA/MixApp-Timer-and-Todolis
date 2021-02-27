//
//  TableViewController.swift
//  ToDoList
//
//  Created by Ularbek Abdyrazakov on 29.01.2021.
//

import UIKit

class TableViewController: UITableViewController,UISearchBarDelegate {
    
    @IBOutlet weak var menuBar: UIBarButtonItem!
    
    // Here i am creating empty array of type "Items" for getting into himself sorted elements of toDoItems array elements
    var filteredToDoItems = [Items]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //for SideMenu
    func menubar(){
        
        if revealViewController() != nil {
                    
                    menuBar.target = revealViewController()
                    menuBar.action = #selector(SWRevealViewController.revealToggle(_:))
                    revealViewController()?.rearViewRevealWidth = 300
                    
                    view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
                }
        
    }
    
    @IBAction func pushEditAction(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.tableView.reloadData()
            saveItem()

        }
        
    }
    
    //adding todo's
    @IBAction func pushAddAction(_ sender: Any) {
       let alertController =  UIAlertController(title: "Creat new item", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "New item name"
        }
        
        let alertAction2 = UIAlertAction(title: "create", style: .cancel) { (alert) in
            let newItem = alertController.textFields![0].text
             
            if newItem != "" {
                addItem(nameItem: newItem!)
                self.tableView.reloadData()
            }
            
        }
        let alertAction1 = UIAlertAction(title: "cancel", style: .default) { (alert) in
           
            
        }
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Candies"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        menubar()
        loadData()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.systemOrange
       
    }
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    
    override func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
      if isFiltering {
        return filteredToDoItems.count
      }
        
      return toDoItems.count
    }

    

    
    
   override func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      let currentItem: Items
      if isFiltering {
        currentItem = filteredToDoItems[indexPath.row]
      } else {
        currentItem = toDoItems[indexPath.row]
      }
      cell.textLabel?.text = currentItem.name
    
    if (currentItem.completed) == true {
               cell.imageView?.image = #imageLiteral(resourceName: "check")
               }
           else{
               cell.imageView?.image = #imageLiteral(resourceName: "iconfinder_uncheck_4473001")
           }
   
   
           if tableView.isEditing{
               cell.textLabel?.alpha = 0.4
               cell.imageView?.alpha = 0.4
   
           }else{
               cell.textLabel?.alpha = 1
               cell.imageView?.alpha = 1
           }
      
      return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
           
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let index : Int
                
        if isFiltering {
                    let currentItems = filteredToDoItems[indexPath.row]
                    let currentIndex = toDoItems.firstIndex(where: {$0 === currentItems})
                    index = currentIndex!
                } else {
                    index = indexPath.row
                }
        
        if changeState(at: index) {
            tableView.cellForRow(at: indexPath)?.imageView?.image = #imageLiteral(resourceName: "check")
        }
        else{
            tableView.cellForRow(at: indexPath)?.imageView?.image = #imageLiteral(resourceName: "iconfinder_uncheck_4473001")

        }
        
        
    }

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        moveItem(fromIndex: fromIndexPath.row, toIndex: to.row)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing{
            return .none
        }
        else{
            return .delete
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

   
    
    // MARK: - Searching
   

    
    func filterContentForSearchText(_ searchText: String) {
      filteredToDoItems = toDoItems.filter { (item: Items) -> Bool in
        return item.name!.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
}
    

extension TableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}
