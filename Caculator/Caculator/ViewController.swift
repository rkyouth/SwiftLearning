//
//  ViewController.swift
//  Caculator
//
//  Created by ChardLl on 16/9/7.
//  Copyright © 2016年 com.chard.richman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var isMiddleOftyping = false
    
    @IBAction func touchDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if(isMiddleOftyping){
            let inputDigit = display.text!
            display.text = inputDigit + digit
        }else{
            display.text = digit
        }
        
        isMiddleOftyping = true
    }

    var displayValue : Double {
        
        get{
            return Double(display.text!)!
        }
        
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain = CaculatorBrain()
    
    var saveProgram : CaculatorBrain.Propertylist?
    
    @IBAction func save(sender: UIButton) {
        
        saveProgram = brain.program
    }
    
    @IBAction func restore(sender: UIButton) {
        if saveProgram != nil {
            brain.program = saveProgram!
            displayValue = brain.result
        }
    }
    
    @IBAction func performOpration(sender: UIButton) {
        
        if isMiddleOftyping {
            brain.setOprator(displayValue)
            isMiddleOftyping = false
        }
        
        if let mathSymbol = sender.currentTitle{
            
            brain.performOpration(mathSymbol)
            
            displayValue = brain.result
            
        }
    }
}

