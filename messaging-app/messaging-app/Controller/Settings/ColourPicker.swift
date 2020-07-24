//
//  GroupColour.swift
//  messaging-app
//
//  Created by Bailey Search on 22/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

protocol ColourPickerDelegate {
    func useColour(colour: String)
}

class ColourPicker: UIViewController {
        
    var delegate: ColourPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Reuseable function which returns the pressed colour button back to the delegate
    @IBAction func colourButtonPressed(_ sender: UIButton) {
        let newColour = sender.currentTitle
        if let safeNewColour = newColour {
            delegate?.useColour(colour: safeNewColour)
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
}

