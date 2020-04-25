//
//  StartRegistrationViewController.swift
//  Proj1
//
//  Created by Krug, Chesley Midn USN USNA Annapolis on 3/3/20.
//  Copyright © 2020 pdowd. All rights reserved.
//

import UIKit

class StartRegistrationViewController: UIViewController {
    
    override func viewDidDisappear(_ animated: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkRegistrationStatus()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
       

    @IBAction func tappedRegisterButton(_ sender: Any) {
        
        if(email.text?.isEmpty ?? true){
                   print("Please Enter your Email!")
                   let alertController = UIAlertController(title: "Please enter your email!", message: nil, preferredStyle: .alert)
                   let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                   alertController.addAction(okAction)
                   
                   self.present(alertController, animated: true)
        }
        else {
                   
        let delimiter = "@"
        let emailText = email.text!
        let token =  emailText.components(separatedBy: delimiter)
        let username = token[0]
        let emailServer = token[1]
        print(emailServer)
        print(username)
        
        if emailServer == "usna.edu" {
            UserDefaults.standard.set(username, forKey: "Username")
            
            let json_stuff: [String: String] = [
                "email": email.text!]
            
            //JSON Stuff!
            guard let encoded = try? JSONEncoder().encode(json_stuff) else {
                print("Failed to encode")
                return
            }
            
            let url = URL(string: "http://35.225.105.9/create.php?")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = encoded
            
            
            let task = URLSession.shared.uploadTask(with: request, from: encoded){ data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, let _ = data
                else {
                    print("error: not a valid http response")
                    return
                }
                
                switch(httpResponse.statusCode) {
                case 200:
                    //success response
                     print("Great Success!")
                     
                    break
                case 400:
                    break
                default:
                    break
                }
                
            }
            
            task.resume()
            UserDefaults.standard.set(true, forKey: "registrationStarted")
            print("start registration was clicked")
            print("registration started now equals true")
            performSegue(withIdentifier: "goToCompleteRegistration", sender: self)
       
                
        }
        
        
        }
       
        
        
    }
    
    @IBAction func checkRegistrationStatus() {
        let registrationCompleted = UserDefaults.standard.bool(forKey: "registrationCompleted")
        print(registrationCompleted)
        if registrationCompleted {
            print("segue performed")
            //performSegue(withIdentifier: "fromRegistrationToMain", sender: nil)
        } else {
            let registrationStarted = UserDefaults.standard.bool(forKey: "registrationStarted")
            if registrationStarted {
                print("registration reported started")
                performSegue(withIdentifier: "goToCompleteRegistration", sender: self)
            }
    }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }*/
    

}
