//
//  Area.swift
//  Snake
//
//  Created by Виктория Чубукова on 28.01.2021.
//

import UIKit
import SpriteKit

class EdgeBody: SKShapeNode {
    
    convenience init(maxX: Int, maxY: Int) {
        self.init()
        
        path = UIBezierPath(rect: CGRect(x: 0,y: 0, width: maxX, height: maxY - 100)).cgPath
        strokeColor = UIColor.red
        
        self.position = CGPoint(x: 0,y: 100)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: path!)
        
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        
    }
}
