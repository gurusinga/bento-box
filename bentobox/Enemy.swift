//
//  Enemy.swift
//  bentobox
//
//  Created by Anugerah Pratama Perkasa Gurusinga on 20/12/14.
//  Copyright (c) 2014 Anugerah Pratama Perkasa Gurusinga. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy {
    var theEnemy:SKSpriteNode
    var speed:Float = 0.0
    var currentFrame = 0
    var randomFrame = 0
    var moving = false
    var angle = 0.0
    var range = 2.0
    var xPos = CGFloat()
    
    init(speed:Float, theEnemy:SKSpriteNode){
        self.speed = speed
        self.theEnemy = theEnemy
        self.setRandomFrame()
    }
    
    func setRandomFrame(){
        var range = UInt32(50)..<UInt32(200)
        self.randomFrame = Int(range.startIndex + arc4random_uniform(range.endIndex - range.startIndex))
        
    }
    
}