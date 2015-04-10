//
//  Cigar.swift
//  SOTR
//
//  Created by Nick Franciosi on 3/9/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import Foundation





class StogiesItem {
    let name : String!
    let flavor: FlavorProfile!
    var type: ItemType?
    
    init(name: String, flavor: FlavorProfile){
        self.name = name
        self.flavor = flavor
    }
}

class Spirit: StogiesItem {
    override init(name: String, flavor: FlavorProfile){
        super.init(name: name, flavor: flavor)
        self.type = .Spirit
    }
    
}

class Cigar: StogiesItem {
    override init(name: String, flavor: FlavorProfile){
        super.init(name: name, flavor: flavor)
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

struct FlavorProfile {
    let salty : Int
    let sweet : Int
    let bitter : Int
    let spicy : Int
    let umami : Int
}