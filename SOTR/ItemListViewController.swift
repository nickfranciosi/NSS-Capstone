//
//  ItemTableViewController.swift
//  SOTR
//
//  Created by Nick Franciosi on 3/9/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating{

    var items = [StogiesItem]()
    
    var sectionHeaders = [String]()
    var tableData = [String : [String]]()
    var filteredData:[String] = [String](){
        didSet  {self.tableView.reloadData()}
    }

    var grayColor: UIColor = UIColor(red: 76/255, green: 72/255, blue: 64/255, alpha: 1.0)
    var darkGrayColor: UIColor = UIColor(red: 48/255, green: 43/255, blue: 38/255, alpha: 1.0)
    
    var receivedString: String?
    var receivedScores: [String:Int]?
    var receivedPairing: Pairing?
  
    var type: ItemType!
    
    var itemSearchController =  UISearchController()
    var activityIndicator = UIActivityIndicatorView()
    
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "\(type.rawValue.uppercaseString)"
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 17)!], forState: UIControlState.Normal)
        navigationItem.backBarButtonItem = backButton
        
        self.tableView.backgroundColor = darkGrayColor
        self.tableView.tableFooterView = UIView(frame:CGRectZero)
        itemSearchController =  ({
            
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.hidesNavigationBarDuringPresentation = false
        controller.dimsBackgroundDuringPresentation = false
        controller.searchBar.searchBarStyle = UISearchBarStyle.Default
        controller.searchBar.sizeToFit()
        controller.searchBar.tintColor = self.darkGrayColor
            
        self.tableView.tableHeaderView = controller.searchBar
        
        return controller
        })()
        
        
        
        refreshTableData(items)
        var network = Network()
        if let flavorSliderSearchValues = receivedScores {
            network.getByFlavorProfile(flavorSliderSearchValues, type: type, completion: {
                results in
                if results.isEmpty{
                    println("no results found")
                }
                self.refreshTableData(results)
            })
        }else{
            network.getAllofType(type, completion: {
                results in
                self.refreshTableData(results)
            })
        }
        
       
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 300, height: 300)
         activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        itemSearchController.active = false
    }
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
       
        if (self.itemSearchController.active){
            return 1
        }else{
             return sectionHeaders.count
        }
       
        
        
    }
    
     func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (self.itemSearchController.active){
            return nil
        }
        var label : UILabel = UILabel()
        label.text = sectionHeaders[section]
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = grayColor
        return label
    }
    
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
       
        if (self.itemSearchController.active){
            return filteredData.count
        }else{
            return tableData[sectionHeaders[section]]!.count
        }
        
        
    }
  
    
     func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        if (self.itemSearchController.active){
            return nil
        }else{
            return sectionHeaders
        }
        
    }

     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! UITableViewCell
        
        let itemName : String!
        
        if (self.itemSearchController.active){
            itemName = filteredData[indexPath.row]
        }else{
            itemName = tableData[sectionHeaders[indexPath.section]]![indexPath.row]
        }
        
        
        cell.textLabel!.text = itemName
        cell.textLabel!.textColor = grayColor
        return cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text)
        var tableDataArray = flatten(self.tableData.values.array)
        tableDataArray = tableDataArray.sorted({$0 < $1})
        let array = (tableDataArray as NSArray).filteredArrayUsingPredicate(searchPredicate)
        if(searchController.searchBar.text.isEmpty){
           self.filteredData = tableDataArray
        }else{
            self.filteredData = array as! [String]
        }
        
    }
    
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "itemDetail" {
            let itemDetailViewController = segue.destinationViewController as! DetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()!
            let destinationTitle: String!
            if (self.itemSearchController.active){
                destinationTitle = filteredData[indexPath.row]
            }else{
                destinationTitle = tableData[sectionHeaders[indexPath.section]]![indexPath.row]
            }
            
            if let setPairing = receivedPairing {
                itemDetailViewController.pairing = setPairing
            }
            let chosenItem = filter(items) { $0.name == destinationTitle }[0]
            itemDetailViewController.title = destinationTitle
            itemDetailViewController.currentItem = chosenItem
            itemSearchController.active = false
        }
    }
    
    func refreshTableData(newItems: [StogiesItem]){
        items = newItems
        tableData = buildTableData(newItems)
        sectionHeaders = tableData.keys.array.sorted(<)
        sectionHeaders = findValueAndAddToEnd(needle: "#", haystack: self.sectionHeaders)
        // Reload the table
        self.tableView.reloadData()
        activityIndicator.stopAnimating()
    }

    
    
    func buildTableData(items: [StogiesItem]) -> [String: [String]]{
        var itemsWithSectionKeys = [String : [String]]()
        
        for item in items{
            var firstLetter = self.getFirstLetter(item.name)
            
            if (itemsWithSectionKeys[firstLetter] == nil){
                itemsWithSectionKeys[firstLetter] = [item.name]
            }else{
                itemsWithSectionKeys[firstLetter]?.append(item.name)
                itemsWithSectionKeys[firstLetter] = itemsWithSectionKeys[firstLetter]?.sorted({$0 < $1})
            }
        }
        
        return itemsWithSectionKeys
    }
    
    func getFirstLetter(word: String) -> String{
        
        var lettersArray = [String]()
        for letter in word {
            lettersArray.append(String(letter))
        }
        if ("0"..."9" ~=  lettersArray[0]) {
            lettersArray[0] = "#"
        }
        return lettersArray[0]
    }
    
    func findValueAndAddToEnd(#needle: String, haystack: [String]) -> [String] {
        
        var arrayCopy = haystack
        
        if var index = find(arrayCopy, needle){
            var foundItem = arrayCopy.removeAtIndex(index)
            arrayCopy.append(foundItem)
        }
        
        return arrayCopy
    }
    
    func flatten<T> (array: Array<[T]>) -> [T] {
        return array.reduce([T](), combine: +)
    }
    
}
