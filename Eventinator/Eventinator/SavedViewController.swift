//
//  SavedViewController.swift
//  Eventinator
//
//  Created by Jon O'Keefe on 11/9/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import UIKit
import FoldingCell
import FSCalendar

class SavedViewController: UIViewController {
    
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    var events = [Event]()
    
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488
    let kRowsCount = 3
    var cellHeights = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        calendar.scope = .week
        calendar.select(Date())
        calendar.scopeGesture.isEnabled = true
        calendar.delegate = self
        calendar.dataSource = self
        
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        eventsTableView.estimatedRowHeight = 179
        eventsTableView.rowHeight = UITableViewAutomaticDimension
        eventsTableView.separatorColor = UIColor.clear
        
        setNavigationBarLogo()
        
        LineupClient.shared.eventsSavedForUser(failure: { error in
            print(error)
        }) { events in
            // if the user hasn't saved any events then just show the discover tab
            if events.count >= 0 {
                print("No saved events found for user. Defaulting to discover events")
                LineupClient.shared.events(failure: { error in
                    print(error)
                }) { events in
//                    print(events)
                    self.events = events
                    self.eventsTableView.reloadData()
                    self.createCellHeightsArray()
                }
            } else {
                print("Found and using saved events for user")
//                print(events)
                self.events = events
                self.eventsTableView.reloadData()
                self.createCellHeightsArray()
            }
        }
    }
    
    func createCellHeightsArray() {
        for _ in 0...events.count {
            cellHeights.append(kCloseCellHeight)
        }
    }
    
    private func setNavigationBarLogo() {
        let logo = UIImage(named: "lineup-logo.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
    }
}

extension SavedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
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
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else { // close cell
            cellHeights[indexPath.row] = kCloseCellHeight
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

extension SavedViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return formatter.date(from: "2016/01/01")!
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        // TODO @eveliotc Display events dots here
        let day: Int! = self.gregorian.component(.day, from: date)
        return day % 5 == 0 ? day/5 : 0;
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("change page to \(self.formatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        print("calendar did select date \(self.formatter.string(from: date))")
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
}
