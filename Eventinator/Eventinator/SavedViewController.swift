//
//  SavedViewController.swift
//  Eventinator
//
//  Created by Jon O'Keefe on 11/9/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import UIKit
import FoldingCell

class SavedViewController: UIViewController {
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    var events = [Event]()
    
    
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488
    let kRowsCount = 3
    var cellHeights = [CGFloat]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        eventsTableView.estimatedRowHeight = 100
        eventsTableView.rowHeight = UITableViewAutomaticDimension
        eventsTableView.separatorColor = UIColor.clear
        
        setNavigationBarLogo()
        
        createCellHeightsArray()
        
        LineupClient.shared.events(failure: { error in
            print(error)
        }) { events in
            print(events)
            self.events = events
            self.eventsTableView.reloadData()
        }
    }
    
    func createCellHeightsArray() {
        for _ in 0...kRowsCount {
            cellHeights.append(kCloseCellHeight)
        }
    }
    
    func fetchUserSavedEvents() {
        Event.fetchPersistedEvents(failure: { (error: Error) in
            print(error)
        }, success: { (fetchedEvents: [Event]) in
            for event in fetchedEvents {
                print(event)
            }
        })
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


extension SavedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return events.count
        return kRowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: "SavedEventCell", for: indexPath) as! SavedEventCell
        
        if indexPath.row < events.count {
            cell.event = events[indexPath.row]
        }
        return cell
    }
}

extension SavedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[(indexPath as NSIndexPath).row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[(indexPath as NSIndexPath).row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 1.1
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as SavedEventCell = cell else {
            return
        }
        
        cell.backgroundColor = UIColor.white
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.selectedAnimation(false, animated: false, completion:nil)
        } else {
            cell.selectedAnimation(true, animated: false, completion: nil)
        }
        
        //cell.number = indexPath.row
    }
}
