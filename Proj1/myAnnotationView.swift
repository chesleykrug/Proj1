//
//  MyAnnotationView.swift
//  Proj1
//
//  Created by Krug, Chesley Midn USN USNA Annapolis on 3/2/20.
//  Copyright © 2020 pdowd. All rights reserved.
//

import Foundation
import MapKit

class myAnnotationView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation?
        {
        willSet
        {
            guard let _myAnnotation = newValue as? myAnnotation else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            let mapButton = UIButton(frame: CGRect(origin: CGPoint.zero, size:CGSize(width:30, height:30)))
            mapButton.addTarget(self, action:#selector(mapButtonPressed), for: .touchUpInside)
            mapButton.setBackgroundImage(UIImage(named:"phone"), for: UIControl.State())
//            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            rightCalloutAccessoryView = mapButton
            markerTintColor = _myAnnotation.markerTintColor
            
            if _myAnnotation.discipline == "GuardianAngel"{
                glyphText = String("Angel")
            }
            else{
                glyphText = String("Shipmate")
            }
             
            
        }
        
        
        
    }
    
    @objc func mapButtonPressed() {
        var phoneNumber:String!
        phoneNumber = self.annotation?.subtitle!
        print(phoneNumber!)

        let url: NSURL = URL(string: "tel://"+phoneNumber!)! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
}
