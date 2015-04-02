//
//  FirstViewController.swift
//  SOTR
//
//  Created by Nick Franciosi on 12/16/14.
//  Copyright (c) 2014 Nick Franciosi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FirstViewController: UIViewController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationController!.navigationBar.barTintColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
         self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 15)!]
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let segueType = segue.identifier {
            var flavorProfileVC: FlavorProfileSliderViewController = segue.destinationViewController as! FlavorProfileSliderViewController
            if segueType == "cigarSegue"{
                flavorProfileVC.typeChoice = ItemType.Cigar
            }
            if segueType == "spiritSegue"{
                flavorProfileVC.typeChoice = ItemType.Spirit
            }
        }
       
        
    }
    


  
}

