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
        
        var data = Alamofire.request(.GET, "http://stogiesontherocks.com/api/v1/spirits").responseJSON { (request, response, data, error) in
            let spiritJson = JSON(data!)
            for (index: String, spirit: JSON) in spiritJson{
                println(spirit["name"])
            }
        }
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
}

