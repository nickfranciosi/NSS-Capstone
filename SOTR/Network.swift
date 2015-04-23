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
    
    let baseUrl = "http://stogiesontherocks.com/api2/public/"
    
   
    func getAllofType(type: ItemType, completion: (response: [StogiesItem]) -> ()){
        apiCall(type, completion: completion)
    }
    
    func getByFlavorProfile(flavors: [String: Int], type: ItemType,  completion: (response: [StogiesItem]) -> ()){
        println(flavors)
        apiCall(type, withParameters: flavors, completion: completion)
    
    }
    
    func getByPostId(id: String, type: ItemType, completion: (response: [StogiesItem]) -> ()){
    
        apiCall(type, withPath: "/"+id, completion: completion)
    }
    
    
    private func apiCall(type: ItemType, withPath path: String = "", withParameters parameters: [String: Int]? = nil, completion: (response: [StogiesItem]) -> ()){
        var returnSet = [StogiesItem]()
        println(baseUrl + type.rawValue + path)
        Alamofire.request(.GET, baseUrl + type.rawValue + path, parameters: parameters).responseJSON { (request, response, data, error) in
            let itemJson = JSON(data!)
            for (index: String, item: JSON) in itemJson["data"]{
                var thisItem: StogiesItem!
                
                var itemName = item["name"].stringValue
                var itemFlavorProfile = FlavorProfile(salty: item["salty"].intValue, sweet: item["sweet"].intValue,bitter: item["bitter"].intValue,spicy: item["spicy"].intValue,umami: item["umami"].intValue)
                var postId = item["post_id"].intValue
                var desc = item["description"].stringValue
                
                var pairLink = item["links"]["pairings"].stringValue
                var simLink = item["links"]["similar"].stringValue
                
                if type == ItemType.Cigar{
                    thisItem = Cigar(post_id: postId, name: itemName, flavor: itemFlavorProfile, description: desc)
                }else{
                    thisItem = Spirit(post_id: postId,name: itemName, flavor: itemFlavorProfile, description: desc)
                }
                returnSet.append(thisItem)
            }
            completion(response: returnSet)
        }
        
    }
    
}