//
//  Cigar.swift
//  SOTR
//
//  Created by Nick Franciosi on 3/9/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import Foundation



struct Cigar {
    let name : String
    let flavor: FlavorProfile
}


struct FlavorProfile {
    let salty : Int
    let sweet : Int
    let bitter : Int
    let spicy : Int
    let umami : Int
}