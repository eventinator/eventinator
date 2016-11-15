//
//  DiscoverViewController.swift
//  Eventinator
//
//  Created by Jon O'Keefe on 11/9/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    @IBOutlet weak var draggableEventView: DraggableEventView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarLogo()
        
        draggableEventView.isHidden = true
        
        LineupClient.shared.events(failure: { error in
            print(error)
        }) { events in
            print(events)
            self.draggableEventView.event = events[0]
            self.draggableEventView.isHidden = false
        }
    }
    
    private func setNavigationBarLogo() {
        let logo = UIImage(named: "lineup-logo.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        draggableEventView.layer.cornerRadius = 5
    }

    func markEventAsSavedForUser(event: Event) {
        Event.persistEvent(event: event)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
