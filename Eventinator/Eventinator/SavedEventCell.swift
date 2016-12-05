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
//    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    let formatter = DateFormatter()
    
    var event: Event! {
        didSet {
            //            nameLabel.text = event.id
//            nameLabel.text = "212121"
            
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
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
//        containerView.layer.cornerRadius = 5
        eventImageView.layer.cornerRadius = 5
        
        let location = CLLocation(latitude: 37.7833, longitude: -122.4167)
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
     
//        let eventLat = event.location?.lat
//        let eventLong = event.location?.lng
//        let location2D = CLLocationCoordinate2D(latitude: eventLat!, longitude: eventLong!)
        
        let location2D = CLLocationCoordinate2D(latitude: 37.7833, longitude: -122.4167)
        addAnnotationAtCoordinate(coordinate: location2D, withTitle: "Event Location")
    }

    private func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, withTitle title: String?) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2, 0.2, 0.2]
//        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }

}
