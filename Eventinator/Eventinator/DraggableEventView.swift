//
//  DraggableEventView.swift
//  Lineup
//
//  Created by Jon O'Keefe on 11/14/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import UIKit
import AFNetworking

@IBDesignable class DraggableEventView: UIView {
    
    var view: UIView!
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var event: Event! {
        didSet {
            if let eventImageUrl = event.imageUrl {
                eventImageView.setImageWith(eventImageUrl)
            }
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            dateLabel.text = formatter.string(from: event.start!)
            costLabel.text = "FREE"
            titleLabel.text = event.title
            locationLabel.text = event.locationId
            descriptionLabel.text = event.theDescription
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DraggableEventView", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        view.layer.cornerRadius = 5
        eventImageView.layer.cornerRadius = 5
    }

}
