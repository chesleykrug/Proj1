//
//  SecondViewController.swift
//  Proj1
//
//  Created by user161140 on 2/5/20.
//  Copyright © 2020 pdowd. All rights reserved.
//BAC Calculator

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var weight: UITextField!
    
    
    @IBOutlet weak var gender: UISegmentedControl!
    
    @IBOutlet weak var drinks: UITextField!
    
    
    @IBOutlet weak var time: UITextField!
    
   
    
    @IBOutlet weak var warning: UILabel!
    
    
    
    @IBAction func button(_ sender: AnyObject) {
        
         weight.resignFirstResponder()
         drinks.resignFirstResponder()
         time.resignFirstResponder()
        
        if(weight.text?.isEmpty ?? true){
            print("Please Enter your Weight!")
            let alertController = UIAlertController(title: "Must enter your weight!", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true)
            
        } else if(drinks.text?.isEmpty ?? true){
            print("Please Enter Number of Drinks!")
            let alertController = UIAlertController(title: "Must enter number of drinks!", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
        
            self.present(alertController, animated: true)
            
        } else if(time.text?.isEmpty ?? true){
            print("Please Enter Time since First Drink!")
            let alertController = UIAlertController(title: "Must enter time since first drink!", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
        
            self.present(alertController, animated: true)
            
        } else {
        
         let wt = Double(weight.text!)
         let gend = gender.titleForSegment(at: gender.selectedSegmentIndex)
         let dnks = Double(drinks.text!)
         let tm = Double(time.text!)
         var bac :Double
         if gend == "Female" {
            let n1 = 14.0 * dnks!
            let n2 = wt!/0.00220462
            let n3 = n2 * 0.55
            let n4 = n1/n3
            let n5 = n4 * 100.0
            let n6 = tm! * 0.015
            bac = n5 - n6
            
            if bac < 0.0 {
                bac = 0.0
            }
            
            
          }
          else{
             let n1 = 14.0 * dnks!
             let n2 = wt!/0.0022046
             let n3 = n2 * 0.68
             let n4 = n1/n3
             let n5 = n4 * 100.0
             let n6 = tm! * 0.015
             bac = n5 - n6
            
            if bac < 0.0 {
                bac = 0.0
            }

          }
        
        
        //display.text = String(bac)
        let round = NSString(format: "%.3f", bac).doubleValue
        
        sender.setTitle("Your BAC is: " + String(round), for: .normal)
            
            if bac == 0.0{
                warning.text = "You are sober!"
            }
            
            else if bac > 0.0 && bac <= 0.02 {
                warning.text = "Your BAC is 0.02% or below. This is the lowest level of intoxication with some measurable impact on the brain and body. You will feel relaxed, experience altered mood, feel a little warmer, and may make poor judgments."
                
                
            }
            else if bac > 0.02 && bac <= 0.05 {
                warning.text = "At this level of BAC, your behavior will become exaggerated. You may begin to lose control of small muscles, like the ability to focus your eyes, so vision will become blurry. Your judgment is impaired, and coordination is reduced. "
            }
            
            else if bac > 0.05 && bac < 0.08 {
                warning.text = "At this level, you will begin to lose more coordination, so your balance, speech, reaction times, and even hearing will get worse. Standing still, focusing on objects, and evading obstacles are all much harder. Reasoning, judgment, self-control, concentration, and memory will be impaired."

            }
            else if bac >= 0.08 && bac <= 0.10 {
                warning.text = "DO NOT DRIVE, YOU HAVE EXCEEDED THE LEGAL LIMIT. At this BAC, reaction time and control will be reduced, speech will be slurred, thinking and reasoning are slower, and the ability to coordinate your arms and legs is poor."
            }
            else if bac > 0.10 && bac <= 0.20 {
                warning.text = "Your BAC is beginning to get very high. You will have much less control over your balance and voluntary muscles, so walking and talking are difficult. You may fall and hurt yourself. Vomiting may begin."
            }
            else if bac > 0.20 && bac <= 0.29 {
                warning.text = "Stupor, confusion, feeling dazed, and disorientation are common. Nausea and vomiting are likely to occur, and the gag reflex will be impaired, which could cause choking or aspirating on vomit. Blackouts begin at this BAC, so you may participate in events that you don’t remember."
                
            }
            else if bac > 0.29 && bac <= 0.40 {
                warning.text = "At this point, you may be unconscious and your potential for death increases. Along with a loss of understanding, at this BAC you’ll also experience severe increases in your heart rate, irregular breathing and may have a loss of bladder control."
            }
            else {
                warning.text = "This level may put you in a coma or cause sudden death because your heart or breathing will suddenly stop."
            }
             
               
        }
        
       
        
    }
           
    
           
           
    override func viewDidLoad() {
        
        super.viewDidLoad()
               
        weight.delegate = self
        weight.keyboardType = .numberPad
               
        drinks.delegate = self
        drinks.keyboardType = .numberPad
               
        time.delegate = self
        time.keyboardType = .decimalPad
        
    
               

               // Do any additional setup after loading the view.
    }

    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
       
    


