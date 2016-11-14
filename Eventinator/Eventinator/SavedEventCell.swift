//
//  SavedEventCell.swift
//  Lineup
//
//  Created by Jon O'Keefe on 11/13/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import AFNetworking
import UIKit

class SavedEventCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    var event: Event! {
        didSet {
            titleLabel.text = event.title
            locationLabel.text = event.locationId
            costLabel.text = "FREE"
            if let eventImageUrl = event.imageUrl {
                eventImageView.setImageWith(eventImageUrl)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 5
        eventImageView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
