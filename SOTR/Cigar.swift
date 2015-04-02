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

struct FlavorProfile {
    let salty : Int
    let sweet : Int
    let bitter : Int
    let spicy : Int
    let umami : Int
}