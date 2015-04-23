//
//  PairingViewController.swift
//  SOTR
//
//  Created by Nick Franciosi on 4/13/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import UIKit
import QuartzCore
import FontAwesomeKit

class PairingViewController: UIViewController , LineChartDelegate {
    
    var label = UILabel()
    var desc = UILabel()
    var lineChart: LineChart!
    var pairing: Pairing?
    var typeToPass: ItemType?
    var stogiesItems = [StogiesItem]()

    @IBOutlet weak var cigarName: UILabel!
    @IBOutlet weak var spiritName: UILabel!
    
    @IBOutlet weak var chartViewContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "YOUR PAIRING"
        
        let editIcon = FAKIonIcons.editIconWithSize(5)
        
        var views: [String: AnyObject] = [:]
        
        cigarName.text! = pairing!.cigar!.name!.uppercaseString
        spiritName.text! = pairing!.spirit!.name!.uppercaseString
       
        // simple arrays
        var data: [CGFloat] = [CGFloat(pairing!.cigar!.flavor.bitter), CGFloat(pairing!.cigar!.flavor.salty), CGFloat(pairing!.cigar!.flavor.sweet), CGFloat(pairing!.cigar!.flavor.umami), CGFloat(pairing!.cigar!.flavor.spicy)]
         var data2: [CGFloat] = [CGFloat(pairing!.spirit!.flavor.bitter), CGFloat(pairing!.spirit!.flavor.salty), CGFloat(pairing!.spirit!.flavor.sweet), CGFloat(pairing!.spirit!.flavor.umami), CGFloat(pairing!.spirit!.flavor.spicy)]
        var maxXaxisSetter: [CGFloat] = [1,2,3,4,5]
        
        // simple line with custom x axis labels
        var xLabels: [String] = ["Bitter", "Salty", "Sweet","Umami", "Spicy"]
        var yLabels: [String] = ["0", "1", "2","3", "4", "5"]
        
        lineChart = LineChart()
        lineChart.dots.visible = false
        lineChart.animation.enabled = false
        lineChart.area = true
        lineChart.colors = [UIColor.clearColor(),UIColor(red: 252/255, green: 190/255, blue: 3/255, alpha: 1), UIColor(red: 100/255, green: 85/255, blue: 63/255, alpha: 0.5)]
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
        lineChart.addLine(maxXaxisSetter)
        lineChart.addLine(data)
        lineChart.addLine(data2)
        
        
        lineChart.setTranslatesAutoresizingMaskIntoConstraints(false)
        lineChart.delegate = self
        self.chartViewContainer.addSubview(lineChart)
        views["chart"] = lineChart
        chartViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: nil, metrics: nil, views: views))
        chartViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[chart(==190)]", options: nil, metrics: nil, views: views))
        
        
        desc.text = "\(pairing!.getDescription())"
        desc.font = UIFont(name: "Helvetica Neue", size: 8.0)
        desc.textColor = UIColor.grayColor()
        desc.setTranslatesAutoresizingMaskIntoConstraints(false)
        desc.textAlignment = NSTextAlignment.Center
        self.chartViewContainer.addSubview(desc)
        views["desc"] = desc
        chartViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[desc]-|", options: nil, metrics: nil, views: views))
        chartViewContainer.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[chart]-10-[desc]", options: nil, metrics: nil, views: views))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var tableVC: ItemListViewController = segue.destinationViewController as! ItemListViewController
        tableVC.type = typeToPass
        tableVC.receivedPairing = pairing
    }
    @IBAction func changeCigarClicked(sender: AnyObject) {
        self.typeToPass = .Cigar
        self.performSegueWithIdentifier("changeItemSegue", sender: nil)
    }

    @IBAction func changeSpiritClicked(sender: AnyObject) {
        self.typeToPass = .Spirit
        self.performSegueWithIdentifier("changeItemSegue", sender: nil)
    }
}
