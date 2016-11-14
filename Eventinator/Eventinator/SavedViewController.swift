//
//  SavedViewController.swift
//  Eventinator
//
//  Created by Jon O'Keefe on 11/9/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    var events = [Event]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        eventsTableView.estimatedRowHeight = 100
        eventsTableView.rowHeight = UITableViewAutomaticDimension
        eventsTableView.separatorColor = UIColor.clear

        setNavigationBarLogo()
        
        LineupClient.shared.events(failure: { error in
            print(error)
        }) { events in
            print(events)
            self.events = events
            self.eventsTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: "SavedEventCell", for: indexPath) as! SavedEventCell
        cell.event = events[indexPath.row]
        return cell
    }
    
    private func setNavigationBarLogo() {
        let logo = UIImage(named: "lineup-logo.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
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
