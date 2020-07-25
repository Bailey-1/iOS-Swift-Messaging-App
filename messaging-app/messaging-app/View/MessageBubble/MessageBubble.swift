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
        viewBubble.layer.cornerRadius = viewBubble.frame.size.height / 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        // invoke superclass implementation
        super.prepareForReuse()
        
        // apparently this causes a performance issue. idk. it works tho
        self.nameLabel.text = ""
        self.textContent.text = ""
    }
    
}
