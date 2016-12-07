//
//  SavedEventCell.swift
//  Lineup
//
//  Created by Jon O'Keefe on 11/13/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import AFNetworking
import UIKit
import FoldingCell
import MapKit

class SavedEventCell: FoldingCell {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var cellForegroundView: RotatedView!
    @IBOutlet weak var cellContainerView: UIView!
    
    let formatter = DateFormatter()
    
    var event: Event! {
        didSet {
            titleLabel.text = event.title
            locationLabel.text = event.location?.address
            if let tickets = event?.tickets {
                if tickets.count > 0 {
                    costLabel.text = event.tickets[0]?.price
                }
            }
            if let eventImageUrl = event.imageUrl {
                eventImageView.setImageWith(eventImageUrl)
            }
            
            formatter.dateFormat = "E MMM d h:mm a"
            startDateLabel.text = formatter.string(from: event.start!)
            endDateLabel.text = formatter.string(from: event.end!)
            
            descriptionLabel.text = event.theDescription
            
            let eventLat = event.location?.lat!
            let eventLong = event.location?.lng!
            
            let location = CLLocation(latitude: eventLat!, longitude: eventLong!)
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
            
            let location2D = CLLocationCoordinate2D(latitude: eventLat!, longitude: eventLong!)
            
            addAnnotationAtCoordinate(coordinate: location2D, withTitle: "Event Location")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eventImageView.layer.cornerRadius = 5
        mapView.layer.cornerRadius = 5
        cellForegroundView.layer.cornerRadius = 5
        cellContainerView.layer.cornerRadius = 5
    }
    
    private func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, withTitle title: String?) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2, 0.2, 0.2]
        //        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}
