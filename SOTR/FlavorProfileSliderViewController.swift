//
//  FlavorProfileSliderViewController.swift
//  SOTR
//
//  Created by Nick Franciosi on 3/9/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class FlavorProfileSliderViewController: UIViewController {

    
    @IBOutlet weak var saltyValueLabel: UILabel!
    @IBOutlet weak var sweetValueLabel: UILabel!
    @IBOutlet weak var bitterValueLabel: UILabel!
    @IBOutlet weak var spicyValueLabel: UILabel!
    @IBOutlet weak var umamiValueLabel: UILabel!
    
    
    @IBOutlet weak var saltySlider: UISlider!
    @IBOutlet weak var sweetSlider: UISlider!
    @IBOutlet weak var bitterSlider: UISlider!
    @IBOutlet weak var spicySlider: UISlider!
    @IBOutlet weak var umamiSlider: UISlider!
    
    @IBOutlet weak var introText: UILabel!
    
    var stogiesItems = [StogiesItem]()
    var sliderValueMap:[UISlider:UILabel]!
    var flavorChoices: [String : Int]!
    var typeChoice: ItemType!

    
    
    var pairing: Pairing?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(typeChoice.rawValue.uppercaseString)"
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 17)!], forState: UIControlState.Normal)
        navigationItem.backBarButtonItem = backButton
        
        sliderValueMap  = [
            saltySlider : saltyValueLabel,
            sweetSlider : sweetValueLabel,
            bitterSlider : bitterValueLabel,
            spicySlider : spicyValueLabel,
            umamiSlider : umamiValueLabel
        ]
       
        for slider in sliderValueMap.keys{
            updateTextVauleWithSliderValue(slider)
        }
        

        

        introText.text! = "What \(typeChoice.rawValue.substringToIndex(typeChoice.rawValue.endIndex.predecessor())) flavor(s) are you looking for?"
       
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        flavorChoices = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    @IBAction func sliderValueChanged(sender: AnyObject) {
        var slider = sender as! UISlider
        updateTextVauleWithSliderValue(slider)
    }
    
    func updateTextVauleWithSliderValue(slider: UISlider) -> Void {
        var label = sliderValueMap[slider]
        var rating = Int(slider.value)
        
        label!.text = String(rating)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var tableVC: ItemListViewController = segue.destinationViewController as! ItemListViewController
        var filterTitle = sender?.titleLabel!!.text
        
        if (segue.identifier == "slideResultsSegue"){
            
            flavorChoices = [
                "salty" : Int(saltySlider.value),
                "sweet" : Int(sweetSlider.value),
                "bitter" : Int(bitterSlider.value),
                "spicy" : Int(spicySlider.value),
                "umami" : Int(umamiSlider.value)
            ]
        }
        
        tableVC.receivedString = filterTitle
        tableVC.receivedScores = flavorChoices
        tableVC.type = typeChoice
        if let oneSelectionPairing = pairing{
            tableVC.receivedPairing = oneSelectionPairing
        }
        tableVC.items = self.stogiesItems
        
        
    }
    
}
