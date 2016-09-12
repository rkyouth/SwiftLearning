//
//  CaculatorBrain.swift
//  Caculator
//
//  Created by ChardLl on 16/9/8.
//  Copyright © 2016年 com.chard.richman. All rights reserved.
//

import Foundation

class CaculatorBrain
{
    enum Opration {
        case Constant(Double)
        case UnaryOpration((Double) -> Double)
        case BinaryOpration((Double,Double) -> Double)
        case Equel
    }
    
    struct pendingOpration {
        var pendingFunc : (Double,Double) -> Double
        var firstBinary : Double
    }
    
    var pending : pendingOpration?
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    func setOprator(oprand: Double) {
        accumulator = oprand
        internalProgram.append(oprand)
    }
    
    private var oprations: Dictionary<String,Opration> = [
        "π"  : Opration.Constant(M_PI),
        "e"  : Opration.Constant(M_E),
        "⎷" : Opration.UnaryOpration(sqrt),
        "cos" : Opration.UnaryOpration(cos),
        "x"  : Opration.BinaryOpration({$0 * $1}),
        "÷"  : Opration.BinaryOpration({$0 / $1}),
        "+"  : Opration.BinaryOpration({$0 + $1}),
        "-"  : Opration.BinaryOpration({$0 - $1}),
        "="  : Opration.Equel
    ]
    
    func performOpration(mathsymbol: String) {
        internalProgram.append(mathsymbol)
        if let constant = oprations[mathsymbol]{
            switch constant {
                
            case .Constant(let value):
                accumulator = value
            case .UnaryOpration(let function):
                accumulator = function(accumulator)
            case .BinaryOpration(let function):
                excutePendingOpration()
                pending = pendingOpration(pendingFunc: function, firstBinary: accumulator)
            case .Equel:
                excutePendingOpration()
                
            }
        }
        
    }
    
    private func excutePendingOpration(){
        if pending != nil{
            accumulator = pending!.pendingFunc(pending!.firstBinary, accumulator)
            pending = nil
        }
    }
    
    typealias Propertylist = AnyObject
    
    var program :Propertylist {
        
        get{
            return internalProgram
        }
        
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject]{
                
                for op in arrayOfOps{
                    
                    if let oprand = op as? Double{
                        setOprator(oprand)
                    }else if let opration = op as? String {
                        performOpration(opration)
                    }
                 }
            }
        }
    }
    
    private func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result :Double{
        get{
            return accumulator
        }
        
    }
}