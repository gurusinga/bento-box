//
//  GameScene.swift
//  bentobox
//
//  Created by Anugerah Pratama Perkasa Gurusinga on 18/12/14.
//  Copyright (c) 2014 Anugerah Pratama Perkasa Gurusinga. All rights reserved.
//

import SpriteKit



class GameScene: SKScene, SKPhysicsContactDelegate{
    //Game Property
    var player:Player!
    var touchLocation = CGFloat()
    var gameOver = false
    var theEnemies:[Enemy]  = []
    //Screen
    var endOfScreenTop = CGFloat()
    var endOfScreenBottom = CGFloat()
    //Score Display
    var caughtSushi = 0
    var scoreText = SKLabelNode()
    var caughtSushiLabel = SKLabelNode()
    var convertCaughtSushiToMoney = 0
    var convertCaughtSushiToMoneyLabel = SKLabelNode()
    //Reset Timer
    var timer = NSTimer()
    var refresh = SKSpriteNode(imageNamed: "refresh")
    var countDownText = SKLabelNode(text: "5")
    var countDown = 5

    
    
    
    
    enum ColliderType:UInt32 {
        case Player  = 1
        case Enemy = 2
    }
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        endOfScreenBottom = (self.size.height / 2) * CGFloat(-1)
        endOfScreenTop  = (self.size.height  / 2)
        addBG()
        addChopstick()
        addEnemies()
        
        scoreText = SKLabelNode(text:"Sushi")
        scoreText.position.x = CGFloat(self.size.height / -4)
        scoreText.position.y = CGFloat(self.size.width / 2.4)
        scoreText.fontSize = 12
        scoreText.fontName = "HelveticaNeue"
        addChild(scoreText)
        
        caughtSushiLabel = SKLabelNode(text:"0")
        caughtSushiLabel.position.x = CGFloat(self.size.height / -4.5)
        caughtSushiLabel.position.y = CGFloat(self.size.width / 2)
        caughtSushiLabel.fontName = "HelveticaNeue"
        addChild(caughtSushiLabel)
        
        scoreText = SKLabelNode(text: "Yen")
        scoreText.position.x = CGFloat(self.size.height / 4)
        scoreText.position.y = CGFloat(self.size.width / 2.4)
        scoreText.fontSize = 12
        scoreText.fontName = "HelveticaNeue"
        addChild(scoreText)
        
        convertCaughtSushiToMoneyLabel = SKLabelNode(text:"0")
        convertCaughtSushiToMoneyLabel.position.x =  CGFloat(self.size.height / 4.5)
        convertCaughtSushiToMoneyLabel.position.y = CGFloat(self.size.width / 2)
        convertCaughtSushiToMoneyLabel.fontName = "HelveticaNeue"
        addChild(convertCaughtSushiToMoneyLabel)
        
        addChild(refresh)
        addChild(countDownText)
        countDownText.hidden = true
        refresh.name = "refresh"
        refresh.hidden = true
        
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        //gameOver = true
        refresh.hidden = true
        updatecaughtSushi()
        updateconvertCaughtSushiToMoney()
        addNice()
    }
    
    
    func addYen(){
        let yen = SKSpriteNode(imageNamed: "yen")
        
        yen.anchorPoint = CGPoint(x:0.5,y:0.5)
        yen.position = CGPoint(x:CGFloat(self.size.height / 100),y:self.size.width / 25)
        addChild(yen)
        
        var actions = Array<SKAction>();
        actions.append(SKAction.fadeInWithDuration(0.2));
        actions.append(SKAction.moveTo(CGPoint(x:10,y:170), duration: 0.3));
        
        actions.append(SKAction.moveBy(CGVector(dx: 100,dy: 0), duration: 0.3));
        actions.append(SKAction.rotateByAngle(90, duration: 0.3));
        actions.append(SKAction.scaleTo(2, duration: 0.2))
        actions.append(SKAction.fadeOutWithDuration(0.2));
        actions.append(SKAction.removeFromParent());
        let sequence = SKAction.sequence(actions)
        yen.runAction(sequence);
        
    }
    
    func addNice(){
        let nice = SKSpriteNode(imageNamed: "nice")
        nice.xScale = 0.01
        nice.yScale = 0.01
        nice.anchorPoint = CGPoint(x:0.5,y:0.5)
        nice.position = CGPoint(x:CGFloat(self.size.height / 100),y:self.size.width / 25)
        addChild(nice)
        
        var actions = Array<SKAction>();
        actions.append(SKAction.scaleTo(1, duration: 0.2))
        actions.append(SKAction.fadeOutWithDuration(0.2));
        actions.append(SKAction.removeFromParent());
        let sequence = SKAction.sequence(actions)
        nice.runAction(sequence);
        
    }
    
    func addBG() {
        
        let bg = SKSpriteNode(imageNamed: "bg")
        addChild(bg)
    }
    
    func reloadGame(){
        countDownText.hidden = false
        player.thePlayer.position.x = 0
        player.thePlayer.position.y = 0
        refresh.hidden = true
        caughtSushi = 0
        caughtSushiLabel.text = "0"
        convertCaughtSushiToMoney = 0
        convertCaughtSushiToMoneyLabel.text = "0"
        for enemy in theEnemies {
            resetEnemy(enemy.theEnemy, xPos: enemy.xPos)
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        
    }
    
    func updateTimer() {
        if countDown > 0 {
            countDown--
            countDownText.text = String(countDown)
            
        } else {
            countDown = 5
            countDownText.text = String(countDown)
            countDownText.hidden = true
            gameOver = false
            timer.invalidate()
        }
    }
    
    func addChopstick() {
        let chopstick = SKSpriteNode(imageNamed: "chopstick")
        chopstick.position.x = CGFloat (self.size.height / 100)
        chopstick.position.y = CGFloat (self.size.width / -2)
        chopstick.physicsBody = SKPhysicsBody(circleOfRadius: chopstick.size.height/2)
        chopstick.physicsBody!.affectedByGravity = false
        chopstick.physicsBody!.mass = 999
        chopstick.physicsBody!.dynamic = true
        chopstick.physicsBody!.categoryBitMask = ColliderType.Player.rawValue
        chopstick.physicsBody!.contactTestBitMask = ColliderType.Enemy.rawValue
        chopstick.physicsBody!.collisionBitMask = ColliderType.Enemy.rawValue
        let playerParticles = SKEmitterNode(fileNamed: "HitParticle.sks")
        playerParticles.hidden = true
        player = Player(thePlayer : chopstick, particles: playerParticles)
        chopstick.addChild(playerParticles)
        addChild(chopstick)
    }
    
    func addEnemies() {
        addEnemy(named: "sushi-1", speed: 1.9, xPos: CGFloat(self.size.width / 5))
        addEnemy(named: "sushi-2", speed: 2.3, xPos: CGFloat(0))
        addEnemy(named: "sushi-3", speed: 3.5, xPos: CGFloat(-(self.size.width / 5)))
        
    }
    
    func addEnemy(#named:String, speed:Float, xPos:CGFloat) {
        var enemyNode = SKSpriteNode(imageNamed: named)
        
        enemyNode.physicsBody = SKPhysicsBody(circleOfRadius: enemyNode.size.height/2)
        enemyNode.physicsBody!.affectedByGravity = false
        enemyNode.physicsBody!.mass = 0
        enemyNode.physicsBody!.categoryBitMask = ColliderType.Enemy.rawValue
        enemyNode.physicsBody!.contactTestBitMask = ColliderType.Player.rawValue
        enemyNode.physicsBody!.collisionBitMask = ColliderType.Player.rawValue
        
        var enemy = Enemy(speed: speed, theEnemy: enemyNode)
        theEnemies.append(enemy)
        resetEnemy(enemyNode, xPos: xPos)
        enemy.xPos = enemyNode.position.x
        addChild(enemyNode)
    }
    
    func resetEnemy(enemyNode:SKSpriteNode, xPos:CGFloat){
        enemyNode.position.y = endOfScreenTop
        enemyNode.position.x = xPos
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            if !gameOver {
                touchLocation = (touch.locationInView(self.view!).x * -1) + (self.size.width/2)
            } else {
                let location = touch.locationInNode(self)
                var sprites = nodesAtPoint(location)
                for sprite in sprites {
                    if let spriteNode = sprite as? SKSpriteNode {
                        if spriteNode.name != nil {
                            if spriteNode.name == "refresh" {
                                reloadGame()
                            }
                        }
                    }
                }
            }
        }
        
        let moveAction = SKAction.moveToX(touchLocation, duration: 0.5)
        moveAction.timingMode = SKActionTimingMode.EaseInEaseOut
        player.thePlayer.runAction(moveAction)
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if !gameOver {
            updateEnemiesPosition()
        }
        updatePlayerEmitter()
    }
    
    func updatePlayerEmitter() {
        if player.emit && player.emitFrameCount < player.maxEmitFrameCount {
            player.emitFrameCount++
            player.particles.hidden = false
        } else {
            player.emit = false
            player.particles.hidden = true
            player.emitFrameCount = 0
        }
    }
    
    func updateEnemiesPosition(){
        for enemy in theEnemies {
            if !enemy.moving {
                enemy.currentFrame++
                if enemy.currentFrame > enemy.randomFrame {
                    enemy.moving = true
                }
                
            } else {
                enemy.theEnemy.position.x = CGFloat(Double(enemy.theEnemy.position.x) + cos(enemy.angle) * enemy.range/3 )
                enemy.angle += player.speed
                if enemy.theEnemy.position.y > endOfScreenBottom {
                    enemy.theEnemy.position.y -= CGFloat(enemy.speed)
                    if enemy.theEnemy.position.y < endOfScreenBottom {
                        enemy.theEnemy.hidden = true
                    } else {
                        enemy.theEnemy.hidden = false
                    }
                    
                } else {
                    enemy.theEnemy.position.y = endOfScreenTop
                    enemy.currentFrame = 0
                    enemy.setRandomFrame()
                    enemy.moving = false
                    enemy.range += 0.1
                }
            }
        }
    }
    
    
    func updatecaughtSushi() {
        caughtSushi++
        caughtSushiLabel.text = String(caughtSushi)
    }
    
    func lostSushi(enemyNode:SKSpriteNode, chopstick:SKSpriteNode) {
        if enemyNode.position.y > endOfScreenBottom && enemyNode.position.x != chopstick.position.x {
            convertCaughtSushiToMoney -= 300
        }
    }
    
    func updateconvertCaughtSushiToMoney() {
        if caughtSushi == 3 {
            player.emit = false
            convertCaughtSushiToMoney += 1100
            caughtSushi = 0
            caughtSushiLabel.text = "0"
            addYen()
        }
        convertCaughtSushiToMoneyLabel.text = String(convertCaughtSushiToMoney)
    }
}
