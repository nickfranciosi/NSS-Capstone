//
//  FlavorProfileSliderViewController.swift
//  SOTR
//
//  Created by Nick Franciosi on 3/9/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import UIKit

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
    
    var sliderValueMap:[UISlider:UILabel]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderValueMap  = [
            saltySlider : saltyValueLabel,
            sweetSlider : sweetValueLabel,
            bitterSlider : bitterValueLabel,
            spicySlider : spicyValueLabel,
            umamiSlider : umamiValueLabel
        ]
       
        //initial value of labels is set to the slider value
        for slider in sliderValueMap.keys{
            updateTextVauleWithSliderValue(slider)
        }
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

}
