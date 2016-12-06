//
//  DiscoverViewController.swift
//  Eventinator
//
//  Created by Jon O'Keefe on 11/9/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import UIKit
import JHSpinner

class DiscoverViewController: UIViewController, DraggableEventViewDelegate {
    
    @IBOutlet weak var bottomEventView: DraggableEventView!
    @IBOutlet weak var topEventView: DraggableEventView!
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarLogo()
        
        topEventView.delegate = self
        topEventView.isDraggable = true
        topEventView.isHidden = true
        topEventView.parentView = topEventView
        bottomEventView.delegate = self
        bottomEventView.isHidden = true
        bottomEventView.parentView = bottomEventView
        
        let spinner = JHSpinnerView.showOnView(view, spinnerColor:Colors.hexStringToUIColor(hex: "F0592A"), overlay: .roundedSquare, overlayColor:UIColor.black.withAlphaComponent(0.6))
        view.addSubview(spinner)
        
        LineupClient.shared.events(failure: { error in
            print(error)
        }) { events in
            self.events = events
            self.topEventView.event = self.events[0]
            self.topEventView.isHidden = false
            self.bottomEventView.event = self.events[1]
            self.bottomEventView.isHidden = false
            spinner.dismiss()
        }
    }
    
    func draggableEventView(swiped direction: SwipeDirection) {
        if direction == .right {
            let swipedEvent = topEventView.event
            Event.persistEvent(event: swipedEvent!)
        }
        
        events.remove(at: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            if self.events.count > 0 {
                self.topEventView.event = self.events[0]
            } else {
                self.topEventView.isHidden = true
                self.bottomEventView.isHidden = true
            }
            if self.events.count > 1 {
                self.bottomEventView.event = self.events[1]
            } else {
                self.bottomEventView.isHidden = true
            }
        })
    }
    
    private func setNavigationBarLogo() {
        let logo = UIImage(named: "lineup-logo.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        topEventView.layer.cornerRadius = 3
        bottomEventView.layer.cornerRadius = 3
    }
}
