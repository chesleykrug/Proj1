//
//  myAnnotation.swift
//  Proj1
//
//  Created by Krug, Chesley Midn USN USNA Annapolis on 3/2/20.
//  Copyright © 2020 pdowd. All rights reserved.
//

import Foundation
import MapKit
class myAnnotation: NSObject, MKAnnotation{
    let title: String?
    let phoneNumber: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, phoneNumber: String, discipline: String, coordinate: CLLocationCoordinate2D){
        self.title=title
        self.phoneNumber = phoneNumber
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return phoneNumber
    }

    var markerTintColor: UIColor {
        switch discipline
        {
        case "Shipmate":
            
            return .red
        case "GuardianAngel":
            
            return .black
        default:
            
            return .blue
        }
    }
    
}
