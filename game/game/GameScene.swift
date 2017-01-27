//
//  GameScene.swift
//  game
//
//  Created by Xochitl Say on 7/21/16.
//  Copyright (c) 2016 Make School. All rights reserved.
//



import SpriteKit

enum GameSceneState {
    case Ready, Rotating, Changing, GameOver
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    var highscore: Int = 0
    //play button
    var playButton: MSButtonNode!

    var hand: SKReferenceNode!
    //var background: SKSpriteNode!
    var centerSprite: SKSpriteNode!
    var correctSprite: String!
    var scoreLabel: SKLabelNode!
    var highscoreLabel: SKLabelNode!
    var highestscore: Int = 0
    
    var points: Int = 0
    var clicked: Bool = false
    var sprite1: SKSpriteNode!
    var sprite2: SKSpriteNode!
    var sprite3: SKSpriteNode!
    var sprite4: SKSpriteNode!
    var sprite5: SKSpriteNode!
    var sprite6: SKSpriteNode!
    var sprite7: SKSpriteNode!
    var sprite8: SKSpriteNode!
    var gameOverText: SKLabelNode!
    
    var collision: Bool = false
    var duration: Double = 5.0
    
    
    var gameState: GameSceneState = .Rotating
    


    var ranRedNum: CGFloat = CGFloat(arc4random_uniform(256))
    var ranBlueNum: CGFloat = CGFloat(arc4random_uniform(250))
    var ranGreenNum: CGFloat = CGFloat(arc4random_uniform(240))
    
//    var red: CGFloat = 255.0
//    var green:CGFloat = 255.0
//    var blue: CGFloat = 255.0
    



    var sprites: [SKSpriteNode] = []
    
    
    override func didMoveToView(view: SKView) {
        
        
//        background = childNodeWithName("background") as! SKSpriteNode
//        background.color = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
//        
        playButton = self.childNodeWithName("playButton") as! MSButtonNode

     
        highscoreLabel = self.childNodeWithName("highscore") as! SKLabelNode

        
        /* Setup your scene here */
        sprite1 = childNodeWithName("sprite1") as! SKSpriteNode
        sprite2 = childNodeWithName("sprite2") as! SKSpriteNode
        sprite3 = childNodeWithName("sprite3") as! SKSpriteNode
        sprite4 = childNodeWithName("sprite4") as! SKSpriteNode
        sprite5 = childNodeWithName("sprite5") as! SKSpriteNode
        sprite6 = childNodeWithName("sprite6") as! SKSpriteNode
        sprite7 = childNodeWithName("sprite7") as! SKSpriteNode
        sprite8 = childNodeWithName("sprite8") as! SKSpriteNode
    
    
        
        sprites = [sprite1, sprite2, sprite3, sprite4, sprite5, sprite6, sprite7, sprite8]
    
        /* setting up selection handler*/
        playButton.selectedHandler = {
            self.gameState = .Ready
            self.playButton.hidden = true
            let rotate = SKAction.rotateByAngle(-CGFloat(M_PI), duration: self.duration)
            
            self.hand.runAction(SKAction.repeatActionForever(rotate))

            
        }
        
        centerSprite = childNodeWithName("colorDisplay") as! SKSpriteNode
        hand = childNodeWithName("hand") as! SKReferenceNode
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode


  
        
        
        /* Set physics contact delegate */
        physicsWorld.contactDelegate = self
        scoreLabel.text = String(points)
        
        highscoreLabel.text = String(highestscore)
        


        colorize()
        

        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        
        
        /* Called when a touch begins */
        hand.removeAllActions()

        if collision == true{
            points += 1
            scoreLabel.text = String(points)
            print(points)
            gameState = .Changing
            
        } else {
            print("game over")
            gameState = .GameOver
            //gameOverText.zPosition = 5
            centerSprite.zPosition = -2
            hand.zPosition =  -2
            for sprite in sprites{
                
                sprite.runAction(SKAction.rotateByAngle(CGFloat(-M_PI), duration:1))
                
            }
            playButton.hidden = false
            resetGame()
           

            
                    
        }
        if gameState == .Changing {
            colorize()
         
            if duration <= 5.0 && duration > 2.5{
                duration -= 0.45
                print ("duration: \(duration)")
            } else if duration <= 2.5 && duration > 1.0 {
                duration -= 0.05
                print("duration: \(duration)")
            } else if duration <= 1.0 {
                duration -= 0.001
            }
        
            
        let rotate = SKAction.rotateByAngle(-CGFloat(M_PI), duration:duration)
        hand.runAction(SKAction.repeatActionForever(rotate))
        
        
        
        gameState = .Rotating
        
        
        collision = false
        
        }
        
        

        
    }
   
    override func update(currentTime: CFTimeInterval) {
//        red -= 0.01
//        green -= 0.01
//        blue -= 0.01
//        background.color = UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
//
      
    }
    
   
    func didEndContact(contact: SKPhysicsContact) {
        
        if contact.bodyA.node!.name == correctSprite || contact.bodyB.node!.name == correctSprite{
            collision = false
            print("Out")
        }
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyA.node!.name == correctSprite || contact.bodyB.node!.name == correctSprite {
            
            collision = true
            print("In")

        
        }
        
    }
    func resetGame (){
        
        if points >=  highscore {
            highscore = points
            highestscore = points
            highscoreLabel.text = String(highestscore)
        }
        
        points = 0
        
        scoreLabel.text = String(points)
        
        centerSprite.zPosition = 2
        
        hand.zPosition = 1
        
        hand.zRotation = 0
        
        duration = 5.0

        colorize()
        print(highscore)
    }
    func colorize(){
        let randomSprite = Int(arc4random_uniform(7))
        
        for sprite in sprites{
            
            
            ranRedNum = CGFloat(arc4random_uniform(256))
            ranBlueNum = CGFloat(arc4random_uniform(240))
            ranGreenNum = CGFloat(arc4random_uniform(230))
        
            
            sprite.color = UIColor(red: ranRedNum/255.0, green: ranGreenNum/255.0, blue: ranBlueNum/255.0, alpha: 1.0)
            print(sprite.name)
            print("red: \(ranRedNum)")
            print("green:\(ranGreenNum)")
            print("blue: \(ranBlueNum)")
            
        }
        
        centerSprite.color = sprites[randomSprite].color
        correctSprite = sprites[randomSprite].name
    }



    
}
