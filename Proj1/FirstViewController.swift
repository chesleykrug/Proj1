//
//  FirstViewController.swift
//  Proj1
//
//  Created by user161140 on 2/5/20.
//  Copyright © 2020 pdowd. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CustomPointAnnotation: MKPointAnnotation{
    var customImage:String!
}

enum StringOrDouble{
    case string(String)
    case double(Double)
}

struct OuterLayer: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    //let data: [String: [[String: String]]]
    let data: [AngelLocations]

}

struct AngelLocations: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    
    let name: String
    let phone: String
    let lat: Double
    let long: Double
}
class FirstViewController: UIViewController {
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    
    }
    
        
    
    @IBOutlet weak var Map: MKMapView!
    var annotations: CustomPointAnnotation!
    var annotationsView:MKPinAnnotationView!
    var selectedAnnotation: MKPointAnnotation?
    private let reuseIdentifier = "MyIdentifier"
    var stat = "off"
    
  
    
    let manager = CLLocationManager()
    
    var locTimer:Timer?
    var locTimer2:Timer?
    
    override func viewDidLoad() {
        
        let allAnnotations = Map.annotations
        Map.removeAnnotations(allAnnotations)
        
        super.viewDidLoad()
        checkLocationServices()
        Map.register(myAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        getAngelsFromServer()
        
        locTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(getAngelsFromServer), userInfo: nil, repeats: true)
        
        locTimer2 = Timer.scheduledTimer(timeInterval: 7200, target: self, selector: #selector(checkStillOn), userInfo: nil, repeats: true)
        
       
        
    }
    
   
    
    @objc func checkStillOn()
    {
        if stat == "on"{
            let alertController = UIAlertController(title: "Please turn off your Guardian Angel Status if you are no longer active!", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true)
            
        }
    }
   
  
    
    @objc func getAngelsFromServer() {
        let allAnnotations = Map.annotations
        Map.removeAnnotations(allAnnotations)
        
        let usernameTemp = UserDefaults.standard.object(forKey: "Username")
        let username = usernameTemp as! String
        let json_stuff: [String: String] = [
            "username":username
            ]
        
        //JSON Stuff!
        guard let encoded = try? JSONEncoder().encode(json_stuff) else {
            print("Failed to encode")
            return
        }
        
        let url = URL(string: "http://35.225.105.9/angels.php?")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        
        let task = URLSession.shared.uploadTask(with: request, from: encoded){ data, response, error in
           guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
            else {
                print("error: not a valid http response")
                return
            }
            
            switch(httpResponse.statusCode) {
            case 200:
                //success response
                 print("Great Success!")
                let jsonData = String(data: receivedData, encoding: String.Encoding.utf8)
                 
                 print(jsonData!)
                 let innerLayer: OuterLayer = try! JSONDecoder().decode(OuterLayer.self, from: receivedData)
                 
                 var guardianAngel:[[String: Any]]=[]
                 for object in innerLayer.data{
                    print(object.name)
                    
                    
                    let obj: [String: Any] = ["title" : object.name, "latitude": object.lat, "longitude": object.long, "subtitle": object.phone]
                    guardianAngel.append(obj)
                    
                 }
                
                 self.createAnnotations(locations: guardianAngel)
                 
                break
            case 400:
                break
            default:
                break
            }
            
        }
        
        task.resume()
    }
    
     func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }
        else{
                // Show alert letting the user know they have to turn this on
        }
    }
    
    @IBAction func callUber() {
        UIApplication.shared.open(URL(string:"https://m.uber.com/ul/?action=setPickup&client_id=dcOXwQIJB7PF4S4QbqHR48YPskgs8ABr&pickup=my_location&dropoff[formatted_address]=Armel-Leftwich%20Visitor%20Center%2C%20King%20George%20Street%2C%20Annapolis%2C%20MD%2C%20USA&dropoff[latitude]=38.977683&dropoff[longitude]=-76.483300")! as URL, options: [:], completionHandler: nil)
        
         let json_stuff: [String: Bool] = [
                    "uber": true
                    ]
                
                //JSON Stuff!
                guard let encoded = try? JSONEncoder().encode(json_stuff) else {
                    print("Failed to encode")
                    return
                }
                
                let url = URL(string: "http://35.225.105.9/log.php?")!
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
    }
    
    @objc func updateLocation(){
        print("SENDING UPDATE")
        let username = UserDefaults.standard.object(forKey: "Username") as! String
        
        let messageDictionary = [
            "username": username,
            "lat": Map.userLocation.coordinate.latitude,
            "long": Map.userLocation.coordinate.longitude
            
            ] as [String : Any]

            let jsonData = try! JSONSerialization.data(withJSONObject: messageDictionary)
        
            
            let url = URL(string: "http://35.225.105.9/update.php?")!
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            
            let task2 = URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
               guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    print("error: not a valid http response")
                    return
                }
                
                switch(httpResponse.statusCode) {
                case 200:
                    //success response
                     print("Great Success!")
                     let jsonData = String(data: receivedData, encoding: String.Encoding.utf8)
                     let jsonString = jsonData!
                    
                     print(jsonString)
                    
                    
                case 300:
                    print("300")
                    break
                case 400:
                    print("400")
                    break
                default:
                    print("default")
                    break
                
                } // end of switch
                
                
            } //end of task bracket
        task2.resume()
    }
    
    
    @IBOutlet weak var status_label: UILabel!
    
    @IBAction func Status(_ sender: UISwitch) {
        var status = "off"
        
        func turnOff(){
            sender.setOn(false, animated: true)
            Map.tintColor = .systemBlue
               
        }
        
        func changeStatus(status: String) {
            print(status)
        
        let username = UserDefaults.standard.object(forKey: "Username") as! String
            
            
            if status == "on"
            {
                stat = status
                locTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)
                
                
            }
            
            
                   let json_stuff: [String: String] = [
                                      "username": username,
                                      "status": status]
                                  
                                  //JSON Stuff!
                                  guard let encoded = try? JSONEncoder().encode(json_stuff) else {
                                      print("Failed to encode")
                                      return
                                  }
                              
                                  
                                  let url = URL(string: "http://35.225.105.9/status.php?")!
                                  var request = URLRequest(url: url)
                                  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                  request.httpMethod = "POST"
                                  request.httpBody = encoded
                                  
                                  
                                  let task2 = URLSession.shared.uploadTask(with: request, from: encoded) { data, response, error in
                                     guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                                      else {
                                          print("error: not a valid http response")
                                          return
                                      }
                                      
                                      switch(httpResponse.statusCode) {
                                      case 200:
                                          //success response
                                           print("Great Success!")
                                           let jsonData = String(data: receivedData, encoding: String.Encoding.utf8)
                                           let jsonString = jsonData!
                                          
                                           print(jsonString)
                                          
                                          
                                      case 300:
                                          print("300")
                                          break
                                      case 400:
                                          print("400")
                                          break
                                      default:
                                          print("default")
                                          break
                                      
                                      } // end of switch
                                      
                                      
                                  } //end of task bracket
                              task2.resume()
        }
        
        if(sender.isOn == true){
            let alert = UIAlertController(title: "Confirm Angel Status", message: "Are you sure you want to become an Angel?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction!) in
                status = "on"
                self.status_label.text = "Status ON"
                
                changeStatus(status: status)
                self.statistics()
                
                
                
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: {(action:UIAlertAction!) in
                turnOff()
                status = "off"
                self.status_label.text = "Status OFF"
                changeStatus(status: status)
                
            })) //change nil to action!
            
            self.present(alert, animated: true, completion: nil)
            Map.tintColor = .green
            
            
        }
        else{
            turnOff()
            status = "off"
            self.status_label.text = "Status OFF"
            changeStatus(status: status)
            
        }
        
        
    }
    
    func statistics(){
        let usernameTemp = UserDefaults.standard.object(forKey: "Username")
        
        let username = usernameTemp as! String
        print(username)
        
        let json_stuff: [String: String] = [
            "username": username
            ]
        
        //JSON Stuff!
        guard let encoded = try? JSONEncoder().encode(json_stuff) else {
            print("Failed to encode")
            return
        }
        
        let url2 = URL(string: "http://35.225.105.9/log.php?")!
        var request = URLRequest(url: url2)
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
        
        
    }
    
    

}

extension FirstViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegion.init(center: myLocation, span: span)
        Map.setRegion(region, animated: true)
        self.Map.showsUserLocation = true
        centerViewOnUserLocation()
            
    }
    
    
    @IBAction func closestAngel(_ sender: Any) {
        let currentLocation = Map.userLocation.location!
        let pins = Map.annotations 
        var distance = CLLocationDistance(5000000)
        var pn:String!
        var loc:CLLocation
        
        if pins.isEmpty{
            let alertController = UIAlertController(title: "No Active Guardian Angels!", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
            
                self.present(alertController, animated: true)
            
        }
        else{
        
            var name: String?
        for p in pins {
            loc = CLLocation(latitude: p.coordinate.latitude, longitude: p.coordinate.longitude)
            if(currentLocation.distance(from: loc) < distance && currentLocation.distance(from: loc) != 0.0){
                distance = currentLocation.distance(from: loc)
                pn = p.subtitle!
                name = p.title!
                
            }
        }
             let alertController = UIAlertController(title: "The name of the closest angel is " + name!, message: nil, preferredStyle: .alert)
                     self.present(alertController, animated: true)
            let when = DispatchTime.now() + 5
            DispatchQueue.main.asyncAfter(deadline: when){
                alertController.dismiss(animated: true, completion: nil)
            }
            
                 
             
             let url: NSURL = URL(string: "tel://"+pn!)! as NSURL
             UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        
        
        let json_stuff: [String: Bool] = [
            "call": true
            ]
        
        //JSON Stuff!
        guard let encoded = try? JSONEncoder().encode(json_stuff) else {
            print("Failed to encode")
            return
        }
        
        let url2 = URL(string: "http://35.225.105.9/log.php?")!
        var request = URLRequest(url: url2)
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
            
     }
            
    }
        
        
        
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        self.Map.showsUserLocation = true
        self.centerViewOnUserLocation()
    }
        
        
    func setupLocationManager(){
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation(){
        if let location = manager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1800, longitudinalMeters: 1800)
            Map.setRegion(region, animated: true)
        }
    }
       
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            Map.showsUserLocation = true
            centerViewOnUserLocation()
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()

            break
        case .restricted:
            manager.requestWhenInUseAuthorization()

            break
        case .denied:
            manager.requestWhenInUseAuthorization()

            break
       case .authorizedAlways:
            break
    
        }
    }
    
        
        func createAnnotations(locations: [[String : Any]]) {
            
            
            for location in locations {
                
                if location["title"] as! String == "shipmate" {
                    print("yes, shipmate!")
                    let annotations = myAnnotation(title: location["title"] as! String, phoneNumber: location["subtitle"] as! String, discipline: "Shipmate", coordinate: CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees))
                    
                    Map.addAnnotation(annotations)
                    
                }
                
                let annotations = myAnnotation(title: location["title"] as! String, phoneNumber: location["subtitle"] as! String, discipline: "GuardianAngel", coordinate: CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees))
                
               
                Map.addAnnotation(annotations)

                
        }

        
        }
    
        
    
        func Map(_ Map: MKMapView, didSelect view: MKAnnotationView) {
            print("hi")
        
    }
   
    
}


