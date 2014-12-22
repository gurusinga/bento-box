//
//  Player.swift
//  bentobox
//
//  Created by Anugerah Pratama Perkasa Gurusinga on 20/12/14.
//  Copyright (c) 2014 Anugerah Pratama Perkasa Gurusinga. All rights reserved.
//

import Foundation
import SpriteKit

class Player {
    var thePlayer:SKSpriteNode
    var speed = 0.1
    var emit = false
    var emitFrameCount = 0
    var maxEmitFrameCount = 30
    var particles:SKEmitterNode
    
    init(thePlayer:SKSpriteNode, particles:SKEmitterNode){
        self.thePlayer = thePlayer
        self.particles = particles
    }
}