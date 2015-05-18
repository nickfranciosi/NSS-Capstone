//
//  StogiesButton.swift
//  SOTR
//
//  Created by Nick Franciosi on 5/12/15.
//  Copyright (c) 2015 Nick Franciosi. All rights reserved.
//

import UIKit

class StogiesButton: UIButton {

    let stogiesYellow = UIColor(red: 252/255, green: 190/255, blue: 3/255, alpha: 1.0)
   
    // MARK: Public interface
    
    /// Corner radius of the background rectangle
    internal var roundRectCornerRadius: CGFloat = 2 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// Color of the background rectangle
    internal var roundRectColor: UIColor = UIColor(red: 252/255, green: 190/255, blue: 3/255, alpha: 1.0) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // MARK: Overrides
    
    override internal func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.clearColor()
        layoutRoundRectLayer()
    }
    
    // MARK: Private
    
    private var roundRectLayer: CAShapeLayer?
    
    private func layoutRoundRectLayer() {
        if let existingLayer = roundRectLayer {
            existingLayer.removeFromSuperlayer()
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: roundRectCornerRadius).CGPath
        
        if (self.enabled){
            self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            shapeLayer.fillColor = UIColor.grayColor().CGColor
        }else{
            self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            shapeLayer.fillColor = roundRectColor.CGColor
        }
       
        self.layer.insertSublayer(shapeLayer, atIndex: 0)
        self.roundRectLayer = shapeLayer
        
    }


}
