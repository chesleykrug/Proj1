//
//  FourthViewController.swift
//  Proj1
//
//  Created by Krug, Chesley Midn USN USNA Annapolis on 2/20/20.
//  Copyright © 2020 pdowd. All rights reserved.
//
//PROFILE INFO 

import UIKit

class FourthViewController: UIViewController {

    @IBOutlet weak var roomNum: UITextField!
    @IBOutlet weak var phoneNum: UITextField!
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
       
    

    
    @IBAction func saveButton(_ sender: Any) {
        
        UserDefaults.standard.set(roomNum.text, forKey: "RoomNum")
        UserDefaults.standard.set(phoneNum.text, forKey: "PhoneNum")
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "RoomNum")
        roomNum.text = ""
        UserDefaults.standard.removeObject(forKey: "PhoneNum")
        phoneNum.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UserDefaults.standard.dictionaryRepresentation())
        
        let savedName = UserDefaults.standard.object(forKey: "RoomNum")
        
        if let roomnumber = savedName as? String {
            roomNum.text = roomnumber
        }
        
        let savedName2 = UserDefaults.standard.object(forKey: "PhoneNum")
        
        if let phonenumber = savedName2 as? String {
            phoneNum.text = phonenumber
        }
        

    }
    
     
   
}


