//
//  DetailViewController.swift
//  SOTR
//
//  Created by Nick Franciosi on 3/23/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var bitterValue: UILabel!
    @IBOutlet weak var saltyValue: UILabel!
    @IBOutlet weak var sweetValue: UILabel!
    @IBOutlet weak var umamiValue: UILabel!
    @IBOutlet weak var spicyValue: UILabel!
    @IBOutlet weak var cigarName: UILabel!
    
    var flavors: FlavorProfile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFlavorValues()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        updateFlavorValues()
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateFlavorValues(){
        self.bitterValue.text! = "\(flavors.bitter)"
        self.saltyValue.text! = "\(flavors.salty)"
        self.sweetValue.text! = "\(flavors.sweet)"
        self.umamiValue.text! = "\(flavors.umami)"
        self.spicyValue.text! = "\(flavors.spicy)"
        self.cigarName.text! = "default"
    }
    
}
