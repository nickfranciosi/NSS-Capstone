//
//  Network.swift
//  SOTR
//
//  Created by Nick Franciosi on 4/13/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Network {
    
    let baseUrl = "http://stogiesontherocks.com/api/v1/"
    
   
    func getAllofType(type: ItemType, completion: (response: [StogiesItem]) -> ()){
        apiCall(type, completion: completion)
    }
    
//    func getByFlavorProfile(flavors: [String: Int], type: ItemType,  completion: (response: [StogiesItem]) -> ()){
//        apiCall(type, withParameters: flavors, completion: completion)
//    
//    }
    
    
    private func apiCall(type: ItemType, withParameters parameters: [String: Int]? = nil, completion: (response: [StogiesItem]) -> ()){
        var returnSet = [StogiesItem]()
        Alamofire.request(.GET, baseUrl + type.rawValue, parameters: parameters).responseJSON { (request, response, data, error) in
            let itemJson = JSON(data!)
            for (index: String, item: JSON) in itemJson{
                var thisItem: StogiesItem!
                
                var itemName = item["name"].stringValue
                var itemFlavorProfile = FlavorProfile(salty: item["salty"].intValue, sweet: item["sweet"].intValue,bitter: item["bitter"].intValue,spicy: item["spicy"].intValue,umami: item["umami"].intValue)
                
                if type == ItemType.Cigar{
                    thisItem = Cigar(name: itemName, flavor: itemFlavorProfile)
                }else{
                    thisItem = Spirit(name: itemName, flavor: itemFlavorProfile)
                }
                returnSet.append(thisItem)
            }
            completion(response: returnSet)
        }
        
    }
    
}