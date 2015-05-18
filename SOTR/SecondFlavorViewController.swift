//
//  SecondFlavorViewController.swift
//  SOTR
//
//  Created by Nick Franciosi on 5/12/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import UIKit

class SecondFlavorViewController: UIViewController {

    @IBOutlet weak var mildButton: StogiesButton!
    @IBOutlet weak var strongButton: StogiesButton!
    @IBOutlet weak var complimentButton: StogiesButton!
    @IBOutlet weak var contrastButton: StogiesButton!
    
    @IBOutlet weak var saltySlider: UISlider!
    @IBOutlet weak var sweetSlider: UISlider!
    @IBOutlet weak var bitterSlider: UISlider!
    @IBOutlet weak var spicySlider: UISlider!
    @IBOutlet weak var umamiSlider: UISlider!
    
    @IBOutlet weak var choiceDescription: UILabel!
    
    var typeChoice: ItemType!
    
    
    
    var pairing: Pairing?
    
    let cigar = Cigar(post_id: 2, name: "TestCigar", flavor: FlavorProfile(salty:2, sweet: 2, bitter: 4, spicy: 4, umami: 4), description: "just a description")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        choiceDescription.text! = cigar.getDescription()
        setInitialButtonState()
       
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
    
    
    @IBAction func mildSelected(sender: AnyObject) {
        saltySlider.value = 1.0 as Float
        updateSliderValues()
        handleButtonState(mildButton, enableThis: strongButton)
    }
    
    @IBAction func strongSelected(sender: AnyObject) {
        updateSliderValues()
        handleButtonState(strongButton, enableThis: mildButton)
    }

    @IBAction func complimentSelected(sender: AnyObject) {
        updateSliderValues()
        handleButtonState(complimentButton, enableThis: contrastButton)

    }
    @IBAction func contrastSelected(sender: AnyObject) {
        updateSliderValues()
        handleButtonState(contrastButton, enableThis: complimentButton)

    }
    
    
    func handleButtonState(disableThis: StogiesButton, enableThis: StogiesButton){
        disableThis.enabled = false
        enableThis.enabled = true
    }
    
    
    func setInitialButtonState(){
       var recommendation =  cigar.flavor.getRecommendation()
        
        if recommendation == "mild" {
            self.mildSelected(self)
            self.contrastSelected(self)
        }else{
            self.strongSelected(self)
            self.complimentSelected(self)
        }
        
    }
    
    func updateSliderValues(){
        saltySlider.value = 1.0 as Float
        sweetSlider.value = 1.0 as Float
        spicySlider.value = 1.0 as Float
        bitterSlider.value = 1.0 as Float
        umamiSlider.value = 1.0 as Float
    }
    
    @IBAction func showResultsClicked(sender: AnyObject) {
         performSegueWithIdentifier("itemListSegue", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var tableVC: ItemListViewController = segue.destinationViewController as! ItemListViewController
        
        
        
       tableVC.type = typeChoice
        tableVC.receivedPairing = pairing
        
    }

    
    
}
