//
//  GameScene.swift
//  ReactorSimulator
//
//  Created by Christian Burkhart on 7/5/16.
//  Copyright (c) 2016 Christian Burkhart. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var reactorPositionLabel:SKLabelNode!
    var primaryFlowLabel:SKLabelNode!
    var secondaryFlowLabel:SKLabelNode!
    var reactorTempLabel:SKLabelNode!
    var primaryTempLabel:SKLabelNode!
    var secondaryTempLabel:SKLabelNode!
    var turbineRpmLabel:SKLabelNode!
    var reactorDecrease:SKSpriteNode!
    var reactorIncrease:SKSpriteNode!
    var priFlowIncrease:SKSpriteNode!
    var priFlowDecrease:SKSpriteNode!
    var secFlowIncrease:SKSpriteNode!
    var secFlowDecrease:SKSpriteNode!
    var reactorPosition:Float = 0
    var primaryFlow:Float = 0
    var secondaryFlow:Float = 0
    var reactTemp:Int = 500
    var reactMax:Int = 1200
    var reactTarget:Float = 0.0
    var reactTempRate:Float = 0.0
    var priTempRate:Float = 0.0
    var secTempRate:Float = 0.0
    var turbineRate:Float = 0.0
    var priTemp:Int = 0
    var heatExc:Int = 50
    var priTarget:Float = 0.0
    var priMax:Int = 250
    var secTemp:Int = 0
    var coolTwr:Int = 50
    var secMax:Int = 250
    var secTarget:Float = 0.0
    var turbineSpin:Int = 0
    var fuelAvailable:Float = 1.00
    var fuelCount:Int = 0
    var tempCount:Int = 3
    
    override func didMove(to view: SKView) {
        reactorPositionLabel = self.childNode(withName: "Reactor_Position") as! SKLabelNode
        reactorPositionLabel.text = (String(Int(reactorPosition))) + "%"
        primaryFlowLabel = self.childNode(withName: "Primary_Flow") as! SKLabelNode
        primaryFlowLabel.text = (String(Int(primaryFlow))) + "%"
        secondaryFlowLabel = self.childNode(withName: "Secondary_Flow") as! SKLabelNode
        secondaryFlowLabel.text = (String(Int(secondaryFlow))) + "%"
        reactorTempLabel = self.childNode(withName: "reactor_Temp") as! SKLabelNode
        reactorTempLabel.text = (String(reactTemp)) + "\u{00B0}" + "C"
        primaryTempLabel = self.childNode(withName: "primary_Temp") as! SKLabelNode
        primaryTempLabel.text = (String(heatExc)) + "\u{00B0}" + "C"
        secondaryTempLabel = self.childNode(withName: "secondary_Temp") as! SKLabelNode
        secondaryTempLabel.text = (String(coolTwr)) + "\u{00B0}" + "C"
        turbineRpmLabel = self.childNode(withName: "turbine_Rpm") as! SKLabelNode
        turbineRpmLabel.text = (String(turbineSpin)) + "RPM"
        reactorDecrease = self.childNode(withName: "reactorDecrease") as! SKSpriteNode
        reactorIncrease = self.childNode(withName: "reactorIncrease") as! SKSpriteNode
        priFlowDecrease = self.childNode(withName: "priFlowDecrease") as! SKSpriteNode
        priFlowIncrease = self.childNode(withName: "priFlowIncrease") as! SKSpriteNode
        secFlowDecrease = self.childNode(withName: "secFlowDecrease") as! SKSpriteNode
        secFlowIncrease = self.childNode(withName: "secFlowIncrease") as! SKSpriteNode
        
        let action = SKAction.sequence([SKAction.run(tempMatch), SKAction.wait(forDuration: 1.0)])
        run(SKAction.repeatForever(action))
    }
    
    func tempMatch(){
        reactorRate()
        priCoolantRate()
        heatExchRate()
        secCoolantRate()
        coolTwrRate()
        turbineSpinRate()
        fuelTempAdjust()
    }
    
    func reactorRate(){
        if(reactorPosition == 0.0){
            reactTempRate = 10
            reactTemp -= Int(reactTempRate)
            if reactTemp < 500 {
                reactTemp = 500
            }
        }
        if(primaryFlow != 0){
            reactTarget = (reactorPosition*(1000/primaryFlow)) + 500
            reactTarget *= fuelAvailable
        }
        if reactTarget > Float(reactTemp) {
            reactTempRate = ((reactTarget - Float(reactTemp))/50) + 1
            if reactTempRate > 20 {
                reactTempRate = 20
            }
            reactTemp += Int(reactTempRate)
        }
        if reactTarget < Float(reactTemp) {
            reactTempRate = ((reactTarget - Float(reactTemp))/50) + 1
            if reactTempRate > 20 {
                reactTempRate = 20
            }
            reactTemp -= Int(reactTempRate)
        }
    }
    
    func priCoolantRate(){
        priTarget = (primaryFlow * (Float(priMax)/100))
        if Int(priTarget) > priTemp {
            priTempRate = ((priTarget - Float(priTemp))/25)+1
            priTemp += Int(priTempRate)
        }
        if Int(priTarget) < priTemp {
            priTempRate = ((Float(priTemp) - priTarget)/25)+1
            priTemp -= Int(priTempRate)
        }
    }
    
    func heatExchRate(){
        heatExc = Int((0.5 * Double(reactTemp-500))) + Int((1.5 * Double(primaryFlow)))
        if heatExc < 50 {
            heatExc = 50
        }
    }
    
    func secCoolantRate(){
        secTarget = (secondaryFlow * (Float(secMax)/100))
        if Int(secTarget) > secTemp {
            secTempRate = ((secTarget - Float(secTemp))/25)+1
            secTemp += Int(secTempRate)
        }
        if Int(secTarget) < secTemp {
            secTempRate = ((Float(secTemp) - secTarget)/25)+1
            secTemp -= Int(secTempRate)
        }
    }
    
    func coolTwrRate(){
            coolTwr = Int((0.1 * Double(heatExc)) + (0.2 * Double(secondaryFlow)))
        if coolTwr < 50 {
            coolTwr = 50
        }
    }
    
    func turbineSpinRate(){
        if heatExc > 100 {
            turbineRate = Float(heatExc - 100) * 3
            turbineSpin += Int(turbineRate)
        }
        else{
            turbineRate = 10
            turbineRate -= turbineRate
            if turbineSpin < 0 {
                turbineSpin = 0
            }
        }
    }
    
    func fuelTempAdjust(){
        if fuelCount == 3{
            fuelAvailable -= 0.01
            fuelCount = 0
        }
        else{
            fuelCount += 1
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        var touchLocation:CGPoint!
        let touch:UITouch = touches.first!
        touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if let name = touchedNode.name
        {
            if(name == "reactorDecrease"){
                if reactorPosition > 0 {
                    reactorPosition = reactorPosition - 1
                    tempCount = 3
                }
            }
            if(name == "reactorIncrease"){
                if reactorPosition < 100 {
                    reactorPosition = reactorPosition + 1
                    tempCount = 3
                }
            }
            if(name == "priFlowDecrease"){
                if primaryFlow > 0 {
                    primaryFlow = primaryFlow - 1
                    tempCount = 3
                }
            }
            if(name == "priFlowIncrease"){
                if primaryFlow < 100 {
                    primaryFlow = primaryFlow + 1
                    tempCount = 3
                }
            }
            if(name == "secFlowDecrease"){
                if secondaryFlow > 0 {
                    secondaryFlow = secondaryFlow - 1
                    tempCount = 3
                }
            }
            if(name == "secFlowIncrease"){
                if secondaryFlow < 100 {
                    secondaryFlow = secondaryFlow + 1
                    tempCount = 3
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        reactorPositionLabel.text = (String(Int(reactorPosition))) + "%"
        primaryFlowLabel.text = (String(Int(primaryFlow))) + "%"
        secondaryFlowLabel.text = (String(Int(secondaryFlow))) + "%"
        reactorTempLabel.text = (String(reactTemp)) + "\u{00B0}" + "C"
        primaryTempLabel.text = (String(heatExc)) + "\u{00B0}" + "C"
        secondaryTempLabel.text = (String(coolTwr)) + "\u{00B0}" + "C"
        turbineRpmLabel.text = (String(turbineSpin)) + " RPM"
    }
}
