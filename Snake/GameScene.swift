//
//  GameScene.swift
//  Snake
//
//  Created by Виктория Чубукова on 28.01.2021.
//

import SpriteKit
import GameplayKit

struct CollisionCategories {
    static let Snake: UInt32 = 0x1 << 0
    static let SnakeHead: UInt32 = 0x1 << 1
    static let Apple: UInt32 = 0x1 << 2
    static let EdgeBody: UInt32 = 0x1 << 3
}

class GameScene: SKScene {
    
    var snake: Snake?
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.black
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody?.allowsRotation = false
        view.showsPhysics = true
    
        createButtonLeft()
        createButtonRight()
        createApple()
        createEdgeBody()
        
        snake = Snake(atPoint: CGPoint(x: view.scene!.frame.midX, y: view.scene!.frame.midY))
        self.addChild(snake!)
        
        self.physicsWorld.contactDelegate = self
        
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        self.physicsBody?.collisionBitMask = CollisionCategories.Snake | CollisionCategories.SnakeHead
        
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            guard let touchNode = self.atPoint(touchLocation) as? SKShapeNode, touchNode.name == "counterClockWiseButton" || touchNode.name == "clockWiseButton" else {
                return
            }
            touchNode.fillColor = .green
            
            if touchNode.name == "counterClockWiseButton"{
                snake!.moveCounterClockwise()
            } else if touchNode.name == "clockWiseButton" {
                snake!.moveClockwise()
                
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            guard let touchNode = self.atPoint(touchLocation) as? SKShapeNode, touchNode.name == "counterClockWiseButton" || touchNode.name == "clockWiseButton" else {
                return
            }
            touchNode.fillColor = .gray
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    override func update(_ currentTime: TimeInterval) {
        snake!.move()
        
    }
    
    func createButtonLeft() {
        let button = SKShapeNode()
        button.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
        button.position = CGPoint(x: view!.scene!.frame.minX + 30, y: view!.scene!.frame.minY + 30)
        button.fillColor = UIColor.gray
        button.strokeColor = UIColor.white
        button.lineWidth = 4
        button.name = "counterClockWiseButton"
        self.addChild(button)
    }
    
    func createButtonRight() {
        let button = SKShapeNode()
        button.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
        button.position = CGPoint(x: view!.scene!.frame.maxX - 75, y: view!.scene!.frame.minY + 30)
        button.fillColor = UIColor.gray
        button.strokeColor = UIColor.white
        button.lineWidth = 4
        button.name = "clockWiseButton"
        self.addChild(button)
    }
    
    func createApple() {
        let  randX = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX - 5)))
        let  randY = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY - 5)))
        
        let apple = Apple(position: CGPoint(x: randX, y: randY))
        self.addChild(apple)
    }
    
    func createEdgeBody() {
        let body = EdgeBody(maxX: Int(view!.scene!.frame.maxX), maxY: Int(view!.scene!.frame.maxY))
        self.addChild(body)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyes = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        let collisionObject = bodyes - CollisionCategories.SnakeHead
        
        switch  collisionObject {
        case CollisionCategories.Apple:
            let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node
            snake?.addBodyPart()
            apple?.removeFromParent()
            createApple()
        case CollisionCategories.EdgeBody:
            fatalError("Game over!")
        default:
            break
        }
    }
}
