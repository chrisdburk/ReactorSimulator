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
    var reactTempRate:Float = 0.0
    var priTempRate:Float = 0.0
    var secTempRate:Float = 0.0
    var turbineRate:Float = 0.0
    var priTemp:Int = 200
    var secTemp:Int = 200
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
        primaryTempLabel.text = (String(priTemp)) + "\u{00B0}" + "C"
        secondaryTempLabel = self.childNode(withName: "secondary_Temp") as! SKLabelNode
        secondaryTempLabel.text = (String(secTemp)) + "\u{00B0}" + "C"
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
        reactTemp += (Int(reactorRate()))/tempCount
        priTemp += (Int(priCoolantRate()))/tempCount
        secTemp += (Int(secCoolantRate()))/tempCount
        turbineSpin += (Int(turbineSpinRate()))
        fuelTempAdjust()
    }
    
    func reactorRate() -> Float{
        reactTempRate = (5 * reactorPosition * fuelAvailable) - primaryFlow
        
        if reactTempRate > 20 {
            reactTempRate = 20
        }
        return reactTempRate
    }
    
    func priCoolantRate() -> Float{
        if primaryFlow > (5 * reactorPosition * fuelAvailable) {
            priTempRate = reactTempRate
        }
        else{
            priTempRate = primaryFlow - (secondaryFlow/2)
        }
        return priTempRate
    }
    
    func secCoolantRate() -> Float{
        if((secondaryFlow/2) > primaryFlow){
            secTempRate = priTempRate
        }
        else{
            secTempRate = secondaryFlow
        }
        return secTempRate
    }
    
    func turbineSpinRate() -> Float {
        if priTemp > 220 {
            return Float(priTemp-220)
        }
        else{
            return 0.0
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
        if tempCount > 1{
            tempCount -= 1
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
        primaryTempLabel.text = (String(priTemp)) + "\u{00B0}" + "C"
        secondaryTempLabel.text = (String(secTemp)) + "\u{00B0}" + "C"
        turbineRpmLabel.text = (String(turbineSpin)) + "RPM"
    }
}
