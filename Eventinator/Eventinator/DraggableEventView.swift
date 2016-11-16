//
//  DraggableEventView.swift
//  Lineup
//
//  Created by Jon O'Keefe on 11/14/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import UIKit
import AFNetworking

enum SwipeDirection {
    case left
    case right
}

protocol DraggableEventViewDelegate {
    func draggableEventView(swiped direction: SwipeDirection)
}

@IBDesignable class DraggableEventView: UIView {
    
    var view: UIView!
    var parentView: UIView!
    var parentViewCenter: CGPoint!
    var delegate: DraggableEventViewDelegate!
    var panGesture: UIPanGestureRecognizer!
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var isDraggable: Bool! {
        didSet {
            if isDraggable! {
                panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
                addGestureRecognizer(panGesture)
            } else {
                if panGesture != nil {
                    removeGestureRecognizer(panGesture)
                }
            }
        }
    }
    
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
            
            // Reset view to the center
            self.parentView.center = self.parentViewCenter
            self.view.transform = CGAffineTransform.identity
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        parentViewCenter = view.center
        isDraggable = false
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
    
    func didPan(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
//        let velocity = sender.velocity(in: localView)
        let translation = sender.translation(in: view)
        //        let rotation = sender.rotation(in: localView)
        
        if sender.state == .began {
            parentViewCenter = parentView.center
        } else if sender.state == .changed {
            
            // Translate the parent card view
            // Rotate the inner content view
            let currentRadians = atan2f(Float(view.transform.b), Float(view.transform.a))
            let currentDegrees = currentRadians.radiansToDegrees
            if translation.x > 0 {
                if currentDegrees < 15 {
                    view.transform = view.transform.rotated(by: CGFloat(1.degreesToRadians))
                }
            } else if translation.x < 0 {
                if currentDegrees > -15 {
                    view.transform = view.transform.rotated(by: CGFloat(-1.degreesToRadians))
                }
            }
            //            let midY = localView.bounds.midY
            //            let maxRotation = CGFloat(15.0)
            //            var rad = min(translation.x.degreesToRadians, maxRotation.degreesToRadians)
            //
            //            if translation.x > 0 { // to the right
            //                print("rotate clockwise")
            //                rad = location.y < midY ? rad : -rad
            //
            //            } else if translation.x < 0 { // to the left
            //                print("rotate counter-clockwise")
            //                rad = location.y > midY ? -rad : rad
            //            }
            
            //localView.transform = CGAffineTransform(rotationAngle: rad)
            
            parentView.center = CGPoint(x: parentViewCenter.x + translation.x, y: parentViewCenter.y + translation.y)
        } else if sender.state == .ended {
            let didSwipeRight = translation.x > 100
            let didSwipeLeft = translation.x < -100
            UIView.animate(withDuration: 0.2,
                animations: {
                    if didSwipeRight {
                        self.parentView.center.x = 1000
                    } else if didSwipeLeft {
                        self.parentView.center.x = -1000
                    } else {
                        self.parentView.center = self.parentViewCenter
                        self.view.transform = CGAffineTransform.identity
                    }
            },
                completion: { (isFinished) in
                    if didSwipeRight {
                        self.delegate.draggableEventView(swiped: SwipeDirection.right)
                    } else if didSwipeLeft {
                        self.delegate.draggableEventView(swiped: SwipeDirection.left)
                    }
            })
        }
    }

}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / .pi }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
