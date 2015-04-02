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
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var flavors: FlavorProfile!
    var name: String!
    
    var currentItem: StogiesItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFlavorValues()
        updateName()
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
        self.bitterValue.text! = "\(currentItem.flavor.bitter)"
        self.saltyValue.text! = "\(currentItem.flavor.salty)"
        self.sweetValue.text! = "\(currentItem.flavor.sweet)"
        self.umamiValue.text! = "\(currentItem.flavor.umami)"
        self.spicyValue.text! = "\(currentItem.flavor.spicy)"

        println(currentItem)
    }
    
    func updateName(){
        self.nameLabel.text! = "\(currentItem.type!.rawValue.capitalizedString) name:"
        self.itemName.text! = "\(currentItem.name)"
        
    }
    
}
