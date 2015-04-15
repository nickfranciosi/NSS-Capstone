//
//  Cigar.swift
//  SOTR
//
//  Created by Nick Franciosi on 3/9/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import Foundation



enum ItemType: String {
    case Cigar = "cigars"
    case Spirit = "spirits"
}

struct FlavorProfile {
    let salty : Int
    let sweet : Int
    let bitter : Int
    let spicy : Int
    let umami : Int
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
        self.description = name
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
}

