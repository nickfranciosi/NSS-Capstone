//
//  ItemTableViewController.swift
//  SOTR
//
//  Created by Nick Franciosi on 3/9/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import UIKit

class ItemTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    var items = [StogiesItem]()
    var filteredItems = [StogiesItem]()
    var sectionHeaders = [String]()
    var tableData = [String : [String]]()
    var defaultFlavorProfile = FlavorProfile(salty: 0, sweet: 2, bitter: 0, spicy: 3, umami: 1);
    var spicyFlavorProfile = FlavorProfile(salty: 1, sweet: 0, bitter: 0, spicy: 5, umami: 1);
    
    var receivedString: String?
    var receivedScores: [String:Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableData = buildTableData(items)
        
        // Reload the table
        self.tableView.reloadData()
        
        sectionHeaders = tableData.keys.array.sorted(<)
        sectionHeaders = findValueAndAddToEnd(needle: "#", haystack: self.sectionHeaders)
        
        if let filter = self.receivedScores {
            println("\(filter)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return sectionHeaders.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeaders[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if tableView == self.searchDisplayController!.searchResultsTableView{
            return filteredItems.count
        }else {
            return tableData[sectionHeaders[section]]!.count
        }
        
    }
  
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return sectionHeaders
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! UITableViewCell
        
        let cigarName : String!
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            cigarName = filteredItems[indexPath.row].name
        }else{
            cigarName = tableData[sectionHeaders[indexPath.section]]![indexPath.row]
        }
        
        
        cell.textLabel!.text = cigarName
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "itemDetail" {
            let itemDetailViewController = segue.destinationViewController as! DetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow()!
            let destinationTitle = tableData[sectionHeaders[indexPath.section]]![indexPath.row]
            let chosenItem = filter(items) { $0.name == destinationTitle }[0]
            itemDetailViewController.title = destinationTitle
            itemDetailViewController.currentItem = chosenItem
        }
    }

    
    
//    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
//        filterContentForSearchText(searchString)
//        return true
//    }
//    
//    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
//        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
//        return true
//    }
//    

    
//    func filterContentForSearchText(searchString: String, scope: String = "All") {
//        filteredCigars = cigars.filter({(cigar: Cigar) -> Bool in
//            let categoryMatch = (scope == "All") || (cigar.category == scope)
//            let stringMatch = cigar.name.rangeOfString(searchString)
//            return stringMatch != nil
//        })
//    }
    
    
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
    
}
