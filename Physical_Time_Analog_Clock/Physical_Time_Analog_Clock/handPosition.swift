//
//  handPosition.swift
//  Physical_Time_Analog_Clock
//
//  Created by George Somers on 2/18/18.
//  Copyright © 2018 Xi Stephen Ouyang. All rights reserved.
//

import Foundation


let NOON_MODE = 1
let DAWN_MODE = 2

class Hand_Positioner{
    var partsPerDay: Int
    var partsOnFace: Int
    var partRevsPerDay: Int
    var ticksPerPart: Int
    var tickRevsPerPart: Int
    var FaceResetOffset: Float //enter the angle away from TOP, so to reset at the right
                                //would be pi/2
    var TimeResetOffset: Int  //How many seconds away from noon we are starting the clock at
    var Clockmode: Int
    
    
    init(pPD: Int, pRPD: Int, tPP: Int, tRPP: Int, fRO:Float = 0, tRO: Int = 0, mode: Int = NOON_MODE){
        partsPerDay = pPD
        partsOnFace = pPD/pRPD
        partRevsPerDay = pRPD
        ticksPerPart = tPP
        tickRevsPerPart = tRPP
        FaceResetOffset = fRO
        TimeResetOffset = tRO
        Clockmode = mode
        
        
    }
    //Calcs where the arm is angled at given a start time.
    //Useful when initializing clock
    func partAngle (timeHour:Int, timeMin:Int, timeSec:Int)->Float{
        var totalTime :Int
        totalTime = timeSec + timeMin * 60 + timeHour * (60^2)
        totalTime = TimeResetOffset + totalTime + getModeOffset()
        let fullDay = getFullDay()
        let portionOfDay:Float = Float(totalTime)/Float(fullDay)
        return (2 * Float(Double.pi) * portionOfDay) * Float(partRevsPerDay) + FaceResetOffset
        
    }
    //Time it takes for a 360 degree turn of our clock's part hand, in seconds. Can be used to find
    //Animation speed
    func partDuration()->Int{
        return getFullDay() / partRevsPerDay
    }
    
    func tickAngle(timeHour:Int, timeMin:Int, timeSec:Int)->Float{
        var totalTime :Int
        totalTime = timeSec + timeMin * 60 + timeHour * (60^2) + TimeResetOffset + getModeOffset()
        let partTime : Int = (24*60*60/partsPerDay)
        totalTime %= partTime
        let portionOfPart:Float = Float(totalTime)/Float(partTime)
        return (2 * Float(Double.pi) * portionOfPart) * Float(tickRevsPerPart) + FaceResetOffset
    }
    func tickDuration()->Int{
        return getFullDay()/(partsPerDay * tickRevsPerPart)
    }
    
    func getModeOffset()->Int{
        var modeOffset = 0
        if(Clockmode == DAWN_MODE){
            modeOffset = -getDawn(date: 11)
        }
        return modeOffset
    }
    //TODO: Find how much time will be had by a dawn mode clock
    func getFullDay()->Int{
        if(Clockmode == DAWN_MODE){
            return 24*60*60 - (getDawn(date: 11)-getDawn(date: 12))
        }
        return 24*60*60
    }
    //TODO: Implement Cris' method for dawn finding
    func getDawn(date: Int)->Int{
        return 8 * 60 * 60
    }
    
    
}
