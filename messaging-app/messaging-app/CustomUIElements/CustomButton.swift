//
//  CustomButton.swift
//  messaging-app
//
//  Created by Bailey Search on 25/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit

@IBDesignable class CustomButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()

        updateCornerRadius()
    }

    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }

    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 5 : 0
    }
}
