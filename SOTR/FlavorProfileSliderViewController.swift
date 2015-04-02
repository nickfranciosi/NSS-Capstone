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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var stogiesItems = [StogiesItem]()
    var sliderValueMap:[UISlider:UILabel]!
    var flavorChoices: [String : Int]!
    var typeChoice: ItemType!
    var defaultFlavorProfile = FlavorProfile(salty: 0, sweet: 2, bitter: 0, spicy: 3, umami: 1);
    var spicyFlavorProfile = FlavorProfile(salty: 1, sweet: 0, bitter: 0, spicy: 5, umami: 1);

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        Alamofire.request(.GET, "http://stogiesontherocks.com/api/v1/" + typeChoice.rawValue).responseJSON { (request, response, data, error) in
            let itemJson = JSON(data!)
            for (index: String, item: JSON) in itemJson{
                var itemName = item["name"].stringValue
                var thisItem: StogiesItem!
                var itemFlavorProfile = FlavorProfile(salty: item["salty"].intValue, sweet: item["sweet"].intValue,bitter: item["bitter"].intValue,spicy: item["spicy"].intValue,umami: item["umami"].intValue)
                if self.typeChoice == ItemType.Cigar{
                    thisItem = Cigar(name: itemName, flavor: itemFlavorProfile)
                }else{
                    thisItem = Spirit(name: itemName, flavor: itemFlavorProfile)
                }
                self.stogiesItems.append(thisItem)
            }
        }

        introText.text! = "What \(typeChoice.rawValue) flavor(s) are you looking for?"
        searchBar.placeholder! = "Search \(typeChoice.rawValue.capitalizedString)"
        
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

    @IBAction func allFilterTap(sender: AnyObject) {
        performSegueWithIdentifier("listViewSegue", sender: sender)
    }
    @IBAction func favoriteFilterTap(sender: AnyObject) {
         performSegueWithIdentifier("listViewSegue", sender: sender)
    }
    @IBAction func recommendedFilterTap(sender: AnyObject) {
         performSegueWithIdentifier("listViewSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var tableVC: ItemTableViewController = segue.destinationViewController as! ItemTableViewController
        var filterTitle = sender?.titleLabel!!.text
        flavorChoices = [
            "salty" : Int(saltySlider.value),
            "sweet" : Int(sweetSlider.value),
            "bitter" : Int(bitterSlider.value),
            "spicy" : Int(spicySlider.value),
            "umami" : Int(umamiSlider.value)
        ]
        tableVC.receivedString = filterTitle
        tableVC.receivedScores = flavorChoices
        tableVC.items = self.stogiesItems
        
        
    }
    
}
