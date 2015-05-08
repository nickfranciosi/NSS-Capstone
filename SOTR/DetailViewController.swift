//
//  DetailViewController.swift
//  SOTR
//
//  Created by Nick Franciosi on 3/23/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import UIKit
import QuartzCore

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LineChartDelegate {
    
    var label = UILabel()
    var desc = UILabel()
    var lineChart: LineChart!
    var pairing: Pairing?
    var similarItems = [StogiesItem]()
    
    var stogiesOrange = UIColor(red: 252/255, green: 190/255, blue: 3/255, alpha: 1)
      
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var chartViewContainer: UIView!
    
    var flavors: FlavorProfile!
    var name: String!
    
    var currentItem: StogiesItem!
    var views: [String: AnyObject] = [:]
    @IBOutlet weak var similarTableView: UITableView!
    
    var grayColor: UIColor = UIColor(red: 76/255, green: 72/255, blue: 64/255, alpha: 1.0)
    var darkGrayColor: UIColor = UIColor(red: 48/255, green: 43/255, blue: 38/255, alpha: 1.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        similarTableView.dataSource = self
        similarTableView.delegate = self
        
        
        
        
        self.title = "\(currentItem.type!.rawValue.uppercaseString) REVIEW"
        
        
        
        label.text = "\(currentItem.name.uppercaseString)"
        label.font = UIFont(name: "Helvetica Neue", size: 12.0)
        label.textColor = stogiesOrange
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.textAlignment = NSTextAlignment.Center
        self.chartViewContainer.addSubview(label)
        views["label"] = label
        chartViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: nil, metrics: nil, views: views))
        chartViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[label]", options: nil, metrics: nil, views: views))
        
        
        
        // simple line with custom x axis labels
        var xLabels: [String] = ["Bitter", "Salty", "Sweet","Umami", "Spicy"]
        var yLabels: [String] = ["0", "1", "2","3", "4", "5"]
        
        lineChart = LineChart()
        
        lineChart.dots.visible = false
        lineChart.animation.enabled = false
        lineChart.area = true
        lineChart.colors = [UIColor.clearColor(),UIColor(red: 252/255, green: 190/255, blue: 3/255, alpha: 1), UIColor(red: 100/255, green: 85/255, blue: 63/255, alpha: 1)]
        lineChart.x.axis.visible = false
        lineChart.y.axis.visible = false
        lineChart.x.labels.visible = true
        lineChart.x.grid.visible = false
        lineChart.y.grid.visible = false
        lineChart.x.grid.count = 6
        lineChart.y.grid.count = 5
        lineChart.x.labels.values = xLabels
        lineChart.y.labels.values = yLabels
        lineChart.y.labels.visible = true
        updateItemData()
        

        if let selectedPairing = self.pairing?.hasFirstSelectionOnly() {
            self.selectButton.setTitle("See Your Pairing >", forState: UIControlState.Normal)
        }else{
            var oppositeItemType:String = {
                if self.currentItem.type! == .Cigar{
                    return "Spirits"
                }else{
                    return "Cigars"
                }
                
            }()
            
            self.selectButton.setTitle("Pair \(oppositeItemType) >", forState: UIControlState.Normal)
        }

    }
    
    
    func updateSimItems(){
        self.similarItems = []
        let network = Network()
        network.getSimilar(currentItem, completion: {
            results in
            
            var thisItem: StogiesItem!
            for anItem in results{
                self.similarItems.append(anItem)
            }
            
            self.similarTableView.reloadData()
            }
        )
        
        println("\(currentItem.postId!)")
    }
    
    func updateItemData(){
        // simple arrays
        updateSimItems()
        label.text = "\(currentItem.name.uppercaseString)"
        var data: [CGFloat] = [CGFloat(currentItem.flavor.bitter), CGFloat(currentItem.flavor.salty), CGFloat(currentItem.flavor.sweet), CGFloat(currentItem.flavor.umami), CGFloat(currentItem.flavor.spicy)]
        var maxXaxisSetter: [CGFloat] = [1,2,3,4,5]
        
        lineChart.addLine(maxXaxisSetter)
        lineChart.addLine(data)
        
        
        lineChart.setTranslatesAutoresizingMaskIntoConstraints(false)
        lineChart.delegate = self
        self.chartViewContainer.addSubview(lineChart)
        views["chart"] = lineChart
        chartViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: nil, metrics: nil, views: views))
        chartViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-5-[chart(==190)]", options: nil, metrics: nil, views: views))
        
        
        
        desc.text = "\(currentItem.description)"
        desc.font = UIFont(name: "Helvetica Neue", size: 8.0)
        desc.textColor = UIColor.grayColor()
        desc.setTranslatesAutoresizingMaskIntoConstraints(false)
        desc.textAlignment = NSTextAlignment.Center
        self.chartViewContainer.addSubview(desc)
        views["desc"] = desc
        chartViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[desc]-|", options: nil, metrics: nil, views: views))
        chartViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[chart]-10-[desc]", options: nil, metrics: nil, views: views))
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "flavorSlider"){
            if let setPairing = pairing{
                pairing = setPairing
            }else{
                 pairing = Pairing(item: currentItem)
            }
            
            var sliderVC: FlavorProfileSliderViewController = segue.destinationViewController as! FlavorProfileSliderViewController
            sliderVC.typeChoice = pairing!.getUnselectedType()
            sliderVC.pairing = pairing
        }else if(segue.identifier == "pairingView"){
            var pairingVC: PairingViewController = segue.destinationViewController as! PairingViewController
            pairingVC.pairing = pairing
        }
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func itemSelected(sender: AnyObject) {
        if let selectedPairing = pairing{
            if selectedPairing.hasFirstSelectionOnly() || selectedPairing.hasBothItemsSelected(){
              pairing!.addItem(currentItem)
              performSegueWithIdentifier("pairingView", sender: self)
            }
            
        }else{
            performSegueWithIdentifier("flavorSlider", sender: self)
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "SIMILAR ITEMS"
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.similarTableView.dequeueReusableCellWithIdentifier("simCell", forIndexPath: indexPath) as! UITableViewCell
        var item = similarItems[indexPath.row]
        var name = item.name!
        cell.textLabel!.textColor = grayColor
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return similarItems.count
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(similarItems[indexPath.row].name)
        self.currentItem = similarItems[indexPath.row]
        lineChart.clearAll()
        updateItemData()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var label : UILabel = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 12.0)
        label.text = "SIMILAR ITEMS"
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = grayColor
        return label
    }
    
    
    /**
    * Line chart delegate method.
    */
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        
    }
    
    
    
    /**
    * Redraw chart on device rotation.
    */
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
    
}
