//
//  FifthViewController.swift
//  Proj1
//
//  Created by Krug, Chesley Midn USN USNA Annapolis on 2/21/20.
//  Copyright © 2020 pdowd. All rights reserved.
//

import UIKit

class FifthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sub_ab(_ sender: UIButton) {
        let url: NSURL = URL(string: "tel://18006624357")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func main_o(_ sender: Any) {
        let url2: NSURL = URL(string: "tel://4102935001")! as NSURL
        UIApplication.shared.open(url2 as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func shipmate(_ sender: Any) {
        let url3: NSURL = URL(string: "tel://4103205961")! as NSURL
        UIApplication.shared.open(url3 as URL, options: [:], completionHandler: nil)
    }
}

