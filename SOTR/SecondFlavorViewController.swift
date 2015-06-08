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
    
    @IBOutlet weak var choiceDescription: UILabel!
    
    var typeChoice: ItemType!
    var recievedItem: StogiesItem!
    
    var sliderValueMap:[UISlider:UILabel]!
    
    var pairing: Pairing?
    
    var flavorChoices: [String : Int]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        choiceDescription.text! = recievedItem.getDescription()
        
        
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

      
        setInitialButtonState()
    }
    
    override func viewDidAppear(animated: Bool) {
        flavorChoices = nil
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
    
        handleButtonState(mildButton, enableThis: strongButton)
        var newFlavor = getFlavorProfileUpates()
        updateSliderValues(newFlavor)
        println("mild selected")
    }
    
    @IBAction func strongSelected(sender: AnyObject) {
        
        handleButtonState(strongButton, enableThis: mildButton)
        var newFlavor = getFlavorProfileUpates()
        updateSliderValues(newFlavor)
         println("strong selected")
    }

    @IBAction func complimentSelected(sender: AnyObject) {
        handleButtonState(complimentButton, enableThis: contrastButton)
        var newFlavor = getFlavorProfileUpates()
        updateSliderValues(newFlavor)
        println("compliment selected")

    }
    @IBAction func contrastSelected(sender: AnyObject) {
        handleButtonState(contrastButton, enableThis: complimentButton)
        var newFlavor = getFlavorProfileUpates()
        updateSliderValues(newFlavor)
        println("contrast selected")
    }
    
    
    func handleButtonState(disableThis: StogiesButton, enableThis: StogiesButton){
        disableThis.enabled = false
        enableThis.enabled = true
    }
    
    func getFlavorProfileUpates()->FlavorProfile{
        if(!mildButton.enabled && !contrastButton.enabled){
            return recievedItem.flavor.getMildAndContrast()
        }
        if(!mildButton.enabled && !complimentButton.enabled){
           return recievedItem.flavor.getMildAndCompliment()
        }
        if(!strongButton.enabled && !contrastButton.enabled){
            return recievedItem.flavor.getStrongAndContrast()
        }
        if(!strongButton.enabled && !complimentButton.enabled){
            return recievedItem.flavor.getStrongAndCompliment()
        }
        
        return recievedItem.flavor.getMildAndContrast()
    }
    
    
    func setInitialButtonState(){
       var recommendation =  recievedItem.flavor.getRecommendation()
        
        if recommendation == "mild" {
            self.mildSelected(self)
            self.contrastSelected(self)
        }else{
            self.strongSelected(self)
            self.complimentSelected(self)
        }
        
    }
    
    func updateSliderValues(flavor: FlavorProfile){
        saltySlider.setValue(Float(flavor.salty), animated: true)
        sweetSlider.setValue(Float(flavor.sweet), animated: true)
        spicySlider.setValue(Float(flavor.spicy), animated: true)
        bitterSlider.setValue(Float(flavor.bitter), animated: true)
        umamiSlider.setValue(Float(flavor.umami), animated: true)
        
        for slider in sliderValueMap.keys{
            updateTextVauleWithSliderValue(slider)
        }
    }
    
    @IBAction func showResultsClicked(sender: AnyObject) {
         performSegueWithIdentifier("itemListSegue", sender: self)
    }
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        var slider = sender as! UISlider
        updateTextVauleWithSliderValue(slider)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var tableVC: ItemListViewController = segue.destinationViewController as! ItemListViewController
        
        flavorChoices = [
            "salty" : Int(saltySlider.value),
            "sweet" : Int(sweetSlider.value),
            "bitter" : Int(bitterSlider.value),
            "spicy" : Int(spicySlider.value),
            "umami" : Int(umamiSlider.value)
        ]
        
        tableVC.receivedScores = flavorChoices
        
        tableVC.type = typeChoice
        tableVC.receivedPairing = pairing
        
    }
    
    func updateTextVauleWithSliderValue(slider: UISlider) -> Void {
        var label = sliderValueMap[slider]
        var rating = Int(slider.value)
        
        label!.text = String(rating)
    }

   
    func makeFlavorProfileStong(flavor: FlavorProfile){
        var highest = flavor.getProminentFlavor()
    }
    
}
