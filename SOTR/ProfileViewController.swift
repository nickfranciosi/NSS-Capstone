//
//  ProfileViewController.swift
//  SOTR
//
//  Created by Nick Franciosi on 5/18/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var favoritesTable: UITableView!
    
    @IBOutlet weak var filterSegmentController: UISegmentedControl!
    

    var favoriteCigars = [StogiesItem]()
    var favoriteSpirits = [StogiesItem]()
    var favoritePairings = [Pairing]()
    
    var selectedSegment: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedSegment = filterSegmentController.selectedSegmentIndex
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 15)!]
        // Do any additional setup after loading the view.
        
        favoritesTable.delegate = self
        favoritesTable.dataSource = self
        favoritesTable.reloadData()
        
        filterSegmentController.addTarget(self, action: "updateTableData", forControlEvents: .ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         let cell = favoritesTable.dequeueReusableCellWithIdentifier("favoriteCell", forIndexPath: indexPath) as! UITableViewCell
        
        switch selectedSegment{
            case 0:
                cell.textLabel!.text = "Cool Cigar"
            case 1:
                cell.textLabel!.text = "Cool Spirit"
            case 2:
                cell.textLabel!.text = "Cool Pairing"
            default:
                println("This should never happen")
        }
        
        cell.textLabel!.textColor = grayColor
        
        return cell
    }
    
    func updateTableData(){
        selectedSegment = filterSegmentController.selectedSegmentIndex
        favoritesTable.reloadData()
    }
    
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
