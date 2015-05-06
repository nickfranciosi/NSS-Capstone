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
    
    let baseUrl = "http://stogiesontherocks.com/api3/public/"
    
   
    func getAllofType(type: ItemType, completion: (response: JSON) -> ()){
        apiCall(type, completion: completion)
    }
    
    func getByFlavorProfile(flavors: [String: Int], type: ItemType,  completion: (response: JSON) -> ()){
        println(flavors)
        apiCall(type, withParameters: flavors, completion: completion)
    
    }
    
    func getByPostId(id: String, type: ItemType, completion: (response: JSON) -> ()){
    
        apiCall(type, withPath: "/"+id, completion: completion)
    }
    
    func getVoteCount(pairing: Pairing, completion: (repsonse: Int) -> ()){

        
        var cigarId = pairing.cigar?.postId!
        var spiritId = pairing.spirit?.postId!
        
        var givenParameters = [
            "cigar" : cigarId!,
            "spirit": spiritId!
        ]
        
        println("cigar id \(cigarId!)")
    
        Alamofire.request(.GET, baseUrl + "pairings", parameters: givenParameters).responseJSON { (request, response, data, error) in
            let itemJson = JSON(data!)
        
            var votes = itemJson["data"]["votes"].intValue
           
            completion(repsonse: votes)
        }

    }
    
    func upVote(pairing: Pairing){
        var cigarId = pairing.cigar?.postId!
        var spiritId = pairing.spirit?.postId!
        
        
        Alamofire.request(.PUT, baseUrl + "pairings?cigar=\(cigarId!)&spirit=\(spiritId!)").responseJSON { (request, response, data, error) in
          
        }
    }
    
    func getSimilar(item: StogiesItem, completion: (response: [StogiesItem]) -> ())->(){
        
        let stringId = String(item.postId)
        let itemType: ItemType = item.type!
        var returnSet = [StogiesItem]()
        Alamofire.request(.GET, baseUrl + item.type!.rawValue + "/" + stringId).responseJSON { (request, response, data, error) in
           let itemJson = JSON(data!)
            
           
            for (index: String, item: JSON) in itemJson["similar"]{
                var thisItem: StogiesItem =  self.buildStogiesItem(item["item"], type: itemType)
                returnSet.append(thisItem)
            }
            
            var slice: Array<StogiesItem>  = Array(returnSet[0..<5])
            completion(response: slice)
        }
    }
    
    
    private func apiCall(type: ItemType, withPath path: String = "", withParameters parameters: [String: Int]? = nil, completion: (response: JSON) -> ()){
        var exactMatches = [StogiesItem]()
        var similarMatches = [StogiesItem]()
        Alamofire.request(.GET, baseUrl + type.rawValue + path, parameters: parameters).responseJSON { (request, response, data, error) in
            let itemJson = JSON(data!)
//            for (index: String, item: JSON) in itemJson["data"]{
//                var thisItem: StogiesItem =  self.buildStogiesItem(item, type: type)
//                exactMatches.append(thisItem)
//            }
            completion(response: itemJson)
        }
        
    }
    
    private func buildStogiesItem(item: JSON, type: ItemType) ->StogiesItem{
        
        var itemName = item["name"].stringValue
        var itemFlavorProfile = FlavorProfile(salty: item["salty"].intValue, sweet: item["sweet"].intValue,bitter: item["bitter"].intValue,spicy: item["spicy"].intValue,umami: item["umami"].intValue)
        var postId = item["post_id"].intValue
        var desc = item["description"].stringValue
        
        var pairLink = item["links"]["pairings"].stringValue
        var simLink = item["links"]["similar"].stringValue
        
        if type == ItemType.Cigar{
           return Cigar(post_id: postId, name: itemName, flavor: itemFlavorProfile, description: desc)
        }else{
           return Spirit(post_id: postId,name: itemName, flavor: itemFlavorProfile, description: desc)
        }
    }
    
}