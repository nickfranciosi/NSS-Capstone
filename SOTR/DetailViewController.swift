//
//  DetailViewController.swift
//  SOTR
//
//  Created by Nick Franciosi on 3/23/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import UIKit
import QuartzCore

class DetailViewController: UIViewController, LineChartDelegate {
    
    var label = UILabel()
    var lineChart: LineChart!
    
    @IBOutlet weak var bitterValue: UILabel!
    @IBOutlet weak var saltyValue: UILabel!
    @IBOutlet weak var sweetValue: UILabel!
    @IBOutlet weak var umamiValue: UILabel!
    @IBOutlet weak var spicyValue: UILabel!
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var flavors: FlavorProfile!
    var name: String!
    
    var currentItem: StogiesItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var views: [String: AnyObject] = [:]
        
        label.text = "\(currentItem.name)"
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        views["label"] = label
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: nil, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[label]", options: nil, metrics: nil, views: views))
        
        // simple arrays
        var data: [CGFloat] = [CGFloat(currentItem.flavor.bitter), CGFloat(currentItem.flavor.salty), CGFloat(currentItem.flavor.sweet), CGFloat(currentItem.flavor.umami), CGFloat(currentItem.flavor.spicy)]
        var data2: [CGFloat] = [1, 0, 3, 3, 0]
        var maxXaxisSetter: [CGFloat] = [1,2,3,4,5]
        
        // simple line with custom x axis labels
        var xLabels: [String] = ["Bitter", "Salty", "Sweet","Umami", "Spicy"]
        var yLabels: [String] = ["0", "1", "2","3", "4", "5"]
        
        lineChart = LineChart()
        lineChart.dots.visible = false
        lineChart.animation.enabled = false
        lineChart.area = true
        lineChart.colors = [UIColor.clearColor(),UIColor(red: 252/255, green: 190/255, blue: 3/255, alpha: 0.5), UIColor(red: 100/255, green: 85/255, blue: 63/255, alpha: 0.5)]
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
        
        
        lineChart.setTranslatesAutoresizingMaskIntoConstraints(false)
        lineChart.delegate = self
        self.view.addSubview(lineChart)
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: nil, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==200)]", options: nil, metrics: nil, views: views))
        

    }
    
    override func viewWillAppear(animated: Bool) {
       
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
