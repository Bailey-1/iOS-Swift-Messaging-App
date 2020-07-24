//
//  ViewController.swift
//  messaging-app
//
//  Created by Bailey Search on 20/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        backgroundView.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: backgroundView.frame, andColors: [#colorLiteral(red: 0.7242990732, green: 0.7850584388, blue: 0.9598841071, alpha: 1), #colorLiteral(red: 0.2389388382, green: 0.5892125368, blue: 0.8818323016, alpha: 1), #colorLiteral(red: 0.2265214622, green: 0.2928299606, blue: 0.5221264958, alpha: 1)])
        
        backgroundView.backgroundColor = UIColor(gradientStyle: .diagonal, withFrame: backgroundView.frame, andColors: K.colours.startUpMenu)
    }


}

