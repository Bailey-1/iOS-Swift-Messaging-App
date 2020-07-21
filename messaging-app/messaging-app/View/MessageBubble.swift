//
//  Message-Bubble.swift
//  messaging-app
//
//  Created by Bailey Search on 21/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit

class MessageBubble: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textContent: UILabel!
    @IBOutlet weak var viewBubble: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBubble.layer.cornerRadius = viewBubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
