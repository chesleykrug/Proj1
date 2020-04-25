//
//  RegisterViewController.swift
//  Proj1
//
//  Created by Krug, Chesley Midn USN USNA Annapolis on 3/3/20.
//  Copyright © 2020 pdowd. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
   
    
    
    override func viewDidLoad() {

        // Do any additional setup after loading the view.
        
        UserDefaults.standard.set(false, forKey: "registrationCompleted")
        super.viewDidLoad()
        checkRegistrationStatus()
        
      


    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkRegistrationStatus()
    }
    
    func checkRegistrationStatus() {
        let registrationCompleted = UserDefaults.standard.bool(forKey: "registrationCompleted")
        if registrationCompleted {
            //performSegue(withIdentifier: "goToMain", sender: self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
    @IBOutlet weak var accessCode: UITextField!
    
    var i = false
    @IBAction func button3(_ sender: Any) {
        
        if(accessCode.text?.isEmpty ?? true){
                   print("Please Enter your Access Code!")
                   let alertController = UIAlertController(title: "Please enter your Access Code!", message: nil, preferredStyle: .alert)
                   let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                   alertController.addAction(okAction)
                   
                   self.present(alertController, animated: true)
        }
        else{
                   
      
        var isSuccessful = false
        
        print("got it!")
        let usernameTemp = UserDefaults.standard.object(forKey: "Username")
                
                let username = usernameTemp as! String
                print(username)
                let accessCodeText = accessCode.text!
                
                print(accessCodeText)
                
                
            
                let json_stuff: [String: String] = [
                    "username": username,
                    "code": accessCodeText]
                
                //JSON Stuff!
                guard let encoded = try? JSONEncoder().encode(json_stuff) else {
                    print("Failed to encode")
                    return
                }
            
                print("triedToEncode")
                let url = URL(string: "http://35.225.105.9/verify.php?")!
                var request = URLRequest(url: url)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                request.httpBody = encoded
                print("right before task 2 ")
                
                let task2 = URLSession.shared.uploadTask(with: request, from: encoded) { data, response, error in
                   guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                    else {
                        print("error: not a valid http response")
                        return
                    }
                    print("right before switch statement")
                    switch(httpResponse.statusCode) {
                    case 200:
                        //success response
                         print("Great Success!")
                         let jsonData = String(data: receivedData, encoding: String.Encoding.utf8)
                         var jsonString = jsonData!
                         jsonString.remove(at: jsonString.startIndex)
                         jsonString.remove(at: jsonString.index(before: jsonString.endIndex))
                         print(jsonString)
                         var delimiter = ":"
                         let token =  jsonString.components(separatedBy: delimiter)
                         delimiter = ","
                         
                         if token[1] == "false" {
                            
                            print("In false!")
                            
            
                            
                            
                            
                         } else {
                             UserDefaults.standard.set(true, forKey: "registrationCompleted")
                             self.i = UserDefaults.standard.bool(forKey: "registrationCompleted")
                             print("i is now: " + String(self.i))
                            
                            let token2 = token[1].components(separatedBy: delimiter)
                            let token3 = token[3].components(separatedBy: delimiter)
                            
                            
                             var name = token2[0]
                             var phoneNumber = token3[0]
                             
                             name.remove(at: name.startIndex)
                             name.remove(at: name.index(before: name.endIndex))
                             phoneNumber.remove(at: phoneNumber.startIndex)
                             phoneNumber.remove(at: phoneNumber.index(before: phoneNumber.endIndex))

                             print(name)
                             print(phoneNumber)
                             UserDefaults.standard.set(name, forKey: "Name")
                             UserDefaults.standard.set(phoneNumber, forKey: "PhoneNumber")
                             isSuccessful = true
                             print(isSuccessful)
                             print("completeRegistration was clicked")
                             print("registration completed now equals true")
                             UserDefaults.standard.set(true, forKey: "registrationCompleted")
                            //performSegue(withIdentifier: "goToMain", sender: self._ sen)

                         }
                         
                        
                    case 300:
                        print("300")
                        break
                    case 400:
                        print("400")
                        break
                    default:
                        print("default")
                        break
                    
                    }
                    
                    
                } //end of task bracket
            task2.resume()
            //let registrationtest = UserDefaults.standard.bool(forKey: "registrationCompleted")
        do {
            sleep(1)
        }
            print("registration test is")
            print(UserDefaults.standard.bool(forKey: "registrationCompleted"))
            if UserDefaults.standard.bool(forKey: "registrationCompleted") == true {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyboard.instantiateViewController(identifier: "myTabBar")
                
                newViewController.modalPresentationStyle = .fullScreen
                present(newViewController, animated: true, completion: nil)
                
            
            }
               
        }
        
               
            }
}



           
        
        
    
    
    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */

//}
