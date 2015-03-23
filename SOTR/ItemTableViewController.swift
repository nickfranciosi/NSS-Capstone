//
//  ItemTableViewController.swift
//  SOTR
//
//  Created by Nick Franciosi on 3/9/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import UIKit

class ItemTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {

    var cigars = [Cigar]()
    var filteredCigars = [Cigar]()
    var sectionHeaders = [String]()
    var tableData = [String : [String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cigars = [
            Cigar(category:"A", name:"Aspen Cigar"),
            Cigar(category:"A", name:"Arkham"),
            Cigar(category:"A", name:"Ass Guy Cigars"),
            Cigar(category:"B", name:"Bollipop"),
            Cigar(category:"D", name:"Digar cane"),
            Cigar(category:"D", name:"Daw breaker"),
            Cigar(category:"G", name:"Garamel"),
            Cigar(category:"G", name:"Gour chew"),
            Cigar(category:"G", name:"Gummi bear")
        ]
        
        tableData = buildTableData(cigars)
        
        // Reload the table
        self.tableView.reloadData()
        
        sectionHeaders = tableData.keys.array.sorted(<)
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
            return filteredCigars.count
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
            cigarName = filteredCigars[indexPath.row].name
        }else{
            cigarName = tableData[sectionHeaders[indexPath.section]]![indexPath.row]
        }
        
        
        cell.textLabel!.text = cigarName
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "itemDetail" {
            let itemDetailViewController = segue.destinationViewController as! UIViewController
            let indexPath = self.tableView.indexPathForSelectedRow()!
            let destinationTitle = tableData[sectionHeaders[indexPath.section]]![indexPath.row]
            itemDetailViewController.title = destinationTitle
        }
    }

    
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    
    func getUniqueCategories(items: [Cigar])-> [String]{
        
        var categories = [String]()
        for item in items {
            categories.append(item.category)
        }
        categories = distinct(categories)
        return categories
    }
    
    func filterContentForSearchText(searchString: String, scope: String = "All") {
        filteredCigars = cigars.filter({(cigar: Cigar) -> Bool in
            let categoryMatch = (scope == "All") || (cigar.category == scope)
            let stringMatch = cigar.name.rangeOfString(searchString)
            return stringMatch != nil
        })
    }
    
    func distinct<T: Equatable>(source: [T]) -> [T] {
        var unique = [T]()
        for item in source {
            if !contains(unique, item) {
                unique.append(item)
            }
        }
        return unique
    }
    
    func buildTableData(items: [Cigar]) -> [String: [String]]{
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
    
}
