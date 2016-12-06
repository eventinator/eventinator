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
    
    let DEGREE_TILT = Float(8)
    let SCALE_FACTOR = Float(2.5)
    
    var view: UIView!
    var parentView: UIView! {
        didSet {
            if !isDraggable! {
                showShadow()
            }
        }
    }
    var parentViewCenter: CGPoint!
    var lastX: CGFloat!
    var delegate: DraggableEventViewDelegate!
    var panGesture: UIPanGestureRecognizer!
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var passImageView: UIImageView!
    @IBOutlet weak var dateCostBarView: UIView!
    
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
            costLabel.text = event.tickets[0]?.price
            titleLabel.text = event.title
            locationLabel.text = event.location?.address
            descriptionLabel.text = event.theDescription
            
            likeImageView.alpha = 0
            passImageView.alpha = 0
            
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
        view.layer.cornerRadius = 3
        eventImageView.layer.cornerRadius = 3
//        dateCostBarView.layer.cornerRadius = 3
        likeImageView.alpha = 0
        passImageView.alpha = 0
    }
    
    func didPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            showShadow()
            parentViewCenter = parentView.center
            lastX = 0
        } else if sender.state == .changed {
            // Translate the parent card view
            // Rotate the inner content view
            let currentRadians = atan2f(Float(view.transform.b), Float(view.transform.a))
            let currentDegrees = currentRadians.radiansToDegrees
            
            if lastX < translation.x {
                if translation.x > 0 {
                    if currentDegrees < DEGREE_TILT {
                        view.transform = view.transform.rotated(by: CGFloat(1.degreesToRadians))
                        likeImageView.alpha = CGFloat(currentDegrees * (1 / DEGREE_TILT))
                        
                        let scaleA = likeImageView.transform.a
                        likeImageView.transform = CGAffineTransform(scaleX: CGFloat((SCALE_FACTOR / DEGREE_TILT).adding((Float)(scaleA))), y: CGFloat((SCALE_FACTOR / DEGREE_TILT).adding((Float)(scaleA))))
//                        print("scaleA: \(scaleA)")
                    }
                } else {
                    if currentDegrees < 0 {
                        view.transform = view.transform.rotated(by: CGFloat(1.degreesToRadians))
                        passImageView.alpha = CGFloat(currentDegrees * (-1 / DEGREE_TILT))

                        let scaleA = passImageView.transform.a
                        passImageView.transform = CGAffineTransform(scaleX: CGFloat((Float)(scaleA).subtracting((SCALE_FACTOR / DEGREE_TILT))), y: CGFloat((Float)(scaleA).subtracting((SCALE_FACTOR / DEGREE_TILT))))
//                        print("scaleA: \(scaleA)")
                    }
                }
            } else {
                if translation.x > 0 {
                    if currentDegrees > 0 {
                        view.transform = view.transform.rotated(by: CGFloat(-1.degreesToRadians))
                        likeImageView.alpha = CGFloat(currentDegrees * (1 / DEGREE_TILT))

                        let scaleA = likeImageView.transform.a
                        likeImageView.transform = CGAffineTransform(scaleX: CGFloat((Float)(scaleA).subtracting((SCALE_FACTOR / DEGREE_TILT))), y: CGFloat((Float)(scaleA).subtracting((SCALE_FACTOR / DEGREE_TILT))))
//                        print("scaleA: \(scaleA)")
                    }
                } else {
                    if currentDegrees > (DEGREE_TILT * -1) {
                        view.transform = view.transform.rotated(by: CGFloat(-1.degreesToRadians))
                        passImageView.alpha = CGFloat(currentDegrees * (-1 / DEGREE_TILT))

                        let scaleA = passImageView.transform.a
                        passImageView.transform = CGAffineTransform(scaleX: CGFloat((SCALE_FACTOR / DEGREE_TILT).adding((Float)(scaleA))), y: CGFloat((SCALE_FACTOR / DEGREE_TILT).adding((Float)(scaleA))))
//                        print("scaleA: \(scaleA)")
                    }
                }
            }
            if translation.x <= 0 || likeImageView.alpha < 0.2 {
                likeImageView.alpha = 0
                likeImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            if translation.x >= 0 || passImageView.alpha < 0.2 {
                passImageView.alpha = 0
                passImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            if currentDegrees >= DEGREE_TILT || likeImageView.transform.a < 0.1 {
                likeImageView.alpha = 1
            }
            if currentDegrees <= (DEGREE_TILT * -1) || passImageView.transform.a < 0.1 {
                passImageView.alpha = 1
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
            
            lastX = translation.x
            parentView.center = CGPoint(x: parentViewCenter.x + translation.x, y: parentViewCenter.y + translation.y)
        } else if sender.state == .ended {
            hideShadow()
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
                        self.likeImageView.alpha = 0
                        self.passImageView.alpha = 0
                        self.likeImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.passImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
            },
                completion: { (isFinished) in
                    if didSwipeRight {
                        self.delegate.draggableEventView(swiped: SwipeDirection.right)
                    } else if didSwipeLeft {
                        self.delegate.draggableEventView(swiped: SwipeDirection.left)
                    }
                    self.likeImageView.alpha = 0
                    self.passImageView.alpha = 0
                    self.likeImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.passImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    func showShadow() {
        parentView.layer.masksToBounds = false
        parentView.layer.shadowOffset = CGSize(width: 0, height: 3)
        parentView.layer.shadowRadius = 10
        parentView.layer.shadowOpacity = 0.1
    }
    
    func hideShadow() {
        parentView.layer.masksToBounds = true
        parentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        parentView.layer.shadowRadius = 0
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
