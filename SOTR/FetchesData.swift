//
//  FetchesData.swift
//  SOTR
//
//  Created by Nick Franciosi on 4/1/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


enum ItemType: String {
    case Cigar = "cigars"
    case Spirit = "spirits"
}

class FetchesData {

    let apiBase = "http://stogiesontherocks.com/api/v1/"
    var type: ItemType
    let itemJson: JSON = []
    var returnSet = [StogiesItem]()
    
    
    init(type: ItemType){
        self.type = type
    }
    
    func buildData() {
        var call = self.apiBase + type.rawValue
        println(call)
        var data = Alamofire.request(.GET, call).responseJSON { (request, response, data, error) in
            let itemJson = JSON(data!)
            for (index: String, cigar: JSON) in itemJson{
                var itemName = cigar["name"].stringValue
                
                var itemFlavorProfile = FlavorProfile(salty: cigar["salty"].intValue, sweet: cigar["sweet"].intValue,bitter: cigar["bitter"].intValue,spicy: cigar["spicy"].intValue,umami: cigar["umami"].intValue)
                
                var thisCigar = Cigar(name: itemName, flavor: itemFlavorProfile)
                self.returnSet += [thisCigar]
                println( "\(thisCigar.name)")
            }

        }
        
    }
    
    func getData() -> [StogiesItem]{
        println( "\(self.returnSet.count)")
        return self.returnSet
    }

}