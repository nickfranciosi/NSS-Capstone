//
//  Cigar.swift
//  SOTR
//
//  Created by Nick Franciosi on 3/9/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import Foundation
import SwiftyJSON


enum ItemType: String {
    case Cigar = "cigars"
    case Spirit = "spirits"
}

struct FlavorProfile {
    var salty : Int
    var sweet : Int
    var bitter : Int
    var spicy : Int
    var umami : Int
   
    
    
    func getProminentFlavor() -> String{
        var flavorArray = [
            "salty" : salty,
            "sweet" : sweet,
            "bitter" : bitter,
            "spicy" : spicy,
            "umami" : umami,
        ]
        
        return getHighestValue(flavorArray)
        
    }
    
    func getRecommendation() -> String{
        
        var total = salty + sweet + spicy + bitter + umami
        
        return total > 10 ? "mild":"strong"
        
    }
    
    private func getHighestValue(items: [String: Int]) -> String{
    
        var associatedString: String!
        var largestValue = 0
        var ties: Int = 0
        for (name, value) in items{
            if value == largestValue{
                ties++
                if ties < 2 {
                    associatedString = "\(associatedString) and \(name)"
                }else{
                    associatedString = "full bodied"
                }
            }else if value > largestValue{
                ties = 0
                largestValue = Int(value)
                associatedString = name
            }
        }
        
        return associatedString
    }
    
     func getMildAndContrast()->FlavorProfile{
       var currentFlavor = FlavorProfile(salty: self.salty, sweet: self.sweet, bitter: self.bitter, spicy: self.spicy, umami: self.umami)
        var newFlavor = mild(currentFlavor)
        newFlavor = constrast(newFlavor)
        return newFlavor
    }
    
     func getMildAndCompliment()->FlavorProfile{
        var currentFlavor = FlavorProfile(salty: self.salty, sweet: self.sweet, bitter: self.bitter, spicy: self.spicy, umami: self.umami)
        var newFlavor = mild(currentFlavor)
        newFlavor = compliment(newFlavor)
        return newFlavor
    }

    func getStrongAndContrast()->FlavorProfile{
        var currentFlavor = FlavorProfile(salty: self.salty, sweet: self.sweet, bitter: self.bitter, spicy: self.spicy, umami: self.umami)
        var newFlavor = strong(currentFlavor)
        newFlavor = constrast(newFlavor)
        return newFlavor
    }
    
    func getStrongAndCompliment()->FlavorProfile{
        var currentFlavor = FlavorProfile(salty: self.salty, sweet: self.sweet, bitter: self.bitter, spicy: self.spicy, umami: self.umami)
        var newFlavor = strong(currentFlavor)
        newFlavor = compliment(newFlavor)
        return newFlavor
    }

     private func mild(flavorToChange: FlavorProfile)->FlavorProfile{
        var updatedFlavor = newFlavorIncrementedby(-1, flavorToChange: flavorToChange)
        println("mild flavor")
        return updatedFlavor
    }
    
    private func strong(flavorToChange: FlavorProfile)->FlavorProfile{
        var updatedFlavor = newFlavorIncrementedby(1, flavorToChange: flavorToChange)
        println("strong flavor")
        return updatedFlavor
    }
    
    private func constrast(flavorToChange: FlavorProfile)->FlavorProfile{
        var updatedFlavor = newFlavorIncrementedby(1, flavorToChange: flavorToChange)
        println("constrast flavor")
        return updatedFlavor
        
    }

    private func compliment(flavorToChange: FlavorProfile)->FlavorProfile{
        var updatedFlavor = newFlavorIncrementedby(3, flavorToChange: flavorToChange)
        println("compliment flavor")
        return updatedFlavor
        
    }
    
    private func newFlavorIncrementedby(amount: Int, flavorToChange: FlavorProfile) -> FlavorProfile{
        var updatedFlavor = FlavorProfile(salty: flavorToChange.salty.advancedBy(amount), sweet: flavorToChange.sweet.advancedBy(amount), bitter: flavorToChange.bitter.advancedBy(amount), spicy:  flavorToChange.spicy.advancedBy(amount), umami: flavorToChange.umami.advancedBy(amount))
        return updatedFlavor

    }
}

class StogiesItem {
    let postId: Int!
    let name : String!
    let flavor: FlavorProfile!
    let description : String!
    var type: ItemType?
    
    init(post_id: Int, name: String, flavor: FlavorProfile, description: String){
        self.postId = post_id
        self.name = name
        self.flavor = flavor
        self.description = description
    }
    
    convenience init(item: JSON){
        var itemName = item["name"].stringValue
        var itemFlavorProfile = FlavorProfile(salty: item["salty"].intValue, sweet: item["sweet"].intValue,bitter: item["bitter"].intValue,spicy: item["spicy"].intValue,umami: item["umami"].intValue)
        var postId = item["post_id"].intValue
        var desc = item["description"].stringValue
        
        var pairLink = item["links"]["pairings"].stringValue
        var simLink = item["links"]["similar"].stringValue
        self.init(post_id: postId, name: itemName, flavor: itemFlavorProfile, description: desc)
    }
    
    func getStrongestFlavor() -> String{
        
        return self.flavor.getProminentFlavor()
    }
    
    func getDescription() -> String{
    
        println("Looks like you are fond of a good \(self.getStrongestFlavor()) \(self.getSingularType()). We recommend the following pairing flavor.")
        return "Looks like you are fond of a good \(self.getStrongestFlavor()) \(self.getSingularType()). We recommend the following pairing flavor."
    }
    
    func getSingularType() -> String{
       return  self.type!.rawValue.substringToIndex(self.type!.rawValue.endIndex.predecessor())
    }
}

class Spirit: StogiesItem {
    override init(post_id: Int, name: String, flavor: FlavorProfile, description: String){
        super.init(post_id: post_id, name: name, flavor: flavor, description: description)
        self.type = .Spirit
    }
    
}

class Cigar: StogiesItem {
    override init(post_id: Int, name: String, flavor: FlavorProfile, description: String){
        super.init(post_id: post_id,name: name, flavor: flavor, description: description)
        self.type = .Cigar
    }
}


class Pairing {
    var cigar = Cigar?()
    var spirit = Spirit?()
    
    init (){
        self.cigar = nil
        self.spirit = nil
    }
    
    init(item: StogiesItem){
        addItem(item)
    }
    
    
    init (cigar: Cigar?, spirit: Spirit?){
        self.cigar = cigar
        self.spirit = spirit
    }
    
    func hasFirstSelectionOnly()-> Bool{
        if((cigar == nil && spirit != nil) || (spirit == nil && cigar != nil)){
            return true
        }
        
        return false
    }
    
    func hasBothItemsSelected()-> Bool{
        if(cigar != nil && spirit != nil){
            return true
        }
        
        return false
    }
    
    func addItem(item: StogiesItem) -> Void{
        if (item.type == .Cigar){
            cigar = item as? Cigar
        }
        
        if (item.type == .Spirit){
            spirit = item as? Spirit
        }
    }
    
    func getUnselectedType() -> ItemType{
        if (cigar == nil && self.hasFirstSelectionOnly()){
            return ItemType.Cigar
        }else{
            return ItemType.Spirit
        }
    }
    
    func getDescription() -> String{
        var cigarStrongFlavor = cigar!.getStrongestFlavor()
        var spiritStrongFlavor = spirit!.getStrongestFlavor()
        return "This pairing features a \(cigarStrongFlavor) cigar with a \(spiritStrongFlavor) spirit. "
    }
    
    private func getStrongestFlavorOfItem(item: StogiesItem) -> String{
    
        return item.flavor.getProminentFlavor()
    }
}



