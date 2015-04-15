//
//  TopPairingViewController.swift
//  SOTR
//
//  Created by Nick Franciosi on 4/15/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import UIKit

class TopPairingViewController: UIViewController {
    
    var cigarToSend: Cigar?
    var spiritToSend: Spirit?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var pairing = Pairing(cigar: cigarToSend, spirit: spiritToSend)
        
        var pairVC: PairingViewController = segue.destinationViewController as! PairingViewController
        pairVC.pairing = pairing
    }
    

    @IBAction func firstTopPairingSelected(sender: AnyObject) {
        var cigarflavorProfile: FlavorProfile = FlavorProfile(salty:3, sweet: 5, bitter: 0, spicy: 4, umami: 4)
        var spiritflavorProfile: FlavorProfile = FlavorProfile(salty:0, sweet: 2, bitter: 1, spicy: 3, umami: 4)
        
        var JericoCigar = Cigar(post_id: 5570, name: "Jericho Hill by Crowned Heads", flavor: cigarflavorProfile, description: "A great cigar by crowned heads")
        var MakersSpirit = Spirit(post_id: 3105, name: "Makers Mark Bourbon", flavor: spiritflavorProfile, description: "A great bourbon by makers")
        
        self.cigarToSend = JericoCigar
        self.spiritToSend = MakersSpirit
        
        
        performSegueWithIdentifier("showPairingView", sender: self)
        
    }
    
    @IBAction func secondTopPairingSelected(sender: AnyObject) {
        var cigarflavorProfile: FlavorProfile = FlavorProfile(salty:3, sweet: 5, bitter: 0, spicy: 4, umami: 4)
        var spiritflavorProfile: FlavorProfile = FlavorProfile(salty:0, sweet: 2, bitter: 1, spicy: 3, umami: 4)
        
        var JericoCigar = Cigar(post_id: 5570, name: "Jericho Hill by Crowned Heads", flavor: cigarflavorProfile, description: "A great cigar by crowned heads")
        var MakersSpirit = Spirit(post_id: 3105, name: "Makers Mark Bourbon", flavor: spiritflavorProfile, description: "A great bourbon by makers")
        
        self.cigarToSend = JericoCigar
        self.spiritToSend = MakersSpirit
        
        
        performSegueWithIdentifier("showPairingView", sender: self)
        
    }
    @IBAction func thirdTopPairingSelected(sender: AnyObject) {
        var cigarflavorProfile: FlavorProfile = FlavorProfile(salty:0, sweet: 5, bitter: 0, spicy: 4, umami: 4)
        var spiritflavorProfile: FlavorProfile = FlavorProfile(salty:0, sweet: 4, bitter: 1, spicy: 2, umami: 0)
        
        var ArturoCigar = Cigar(post_id: 3456, name: "Arturo Fuente Anejo 48", flavor: cigarflavorProfile, description: "A great cigar by Arturo")
        var CrownSpirit = Spirit(post_id: 6465, name: "Crown Royal XO", flavor: spiritflavorProfile, description: "A great spirit by crown")
        
        self.cigarToSend = ArturoCigar
        self.spiritToSend = CrownSpirit
        
        
        performSegueWithIdentifier("showPairingView", sender: self)
    }
}
