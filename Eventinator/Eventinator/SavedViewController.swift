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
import JHSpinner

class SavedViewController: UIViewController, LoadableController {
    
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    let headerFormatter: DateFormatter = {
        let headerFormatter = DateFormatter()
        headerFormatter.dateFormat = "EEEE, MMM d"
        return headerFormatter
    }()
    var eventsByDate = [String:[Event]]()
    var events = [Event]()
    
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 900
    var openCells = [IndexPath]()
    
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
        
        setNavigationBarLogo()
        
        loadIfNeeded()
    }
    
    func loadIfNeeded() {
        guard CacheManager.shared.invalidateSaved else {
            return
        }
        let spinner = JHSpinnerView.showOnView(view, spinnerColor:Colors.hexStringToUIColor(hex: "F0592A"), overlay: .roundedSquare, overlayColor:UIColor.black.withAlphaComponent(0.6))
        view.addSubview(spinner)
        
        let eventsCompletion: (([Event])->()) = { events in
            CacheManager.shared.invalidateSaved = false
            self.events = events
            self.updateDateDictionary()
            self.eventsTableView.reloadData()
            spinner.dismiss()
        }
        
        LineupClient.shared.eventsSavedForUser(failure: { error in
            print(error)
        }) { events in
            
            // if the user hasn't saved any events then just show the discover tab
            if events.isEmpty {
                print("No saved events found for user. Defaulting to discover events")
                LineupClient.shared.events(failure: { error in
                    print(error)
                }, success: eventsCompletion)
            } else {
                print("Found and using saved events for user")
                eventsCompletion(events)
            }
            
        }
    }
    
    func keyFor(_ date: Date) -> String {
        return formatter.string(from:date)
    }

    func updateDateDictionary() {
        for event in events {
            let date = event.start ?? Date()
            let key = keyFor(date)
            var dic = eventsByDate[key] ?? [Event]()
            dic.append(event)
            eventsByDate[key] = dic
        }
    }

    private func setNavigationBarLogo() {
        let logo = UIImage(named: "lineup-logo.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
    }
    
    func scrollTo(_ index: DictionaryIndex<String, [Event]>) {
        
        for section in 0...eventsByDate.keys.count {
            if index == eventsByDate.index(eventsByDate.startIndex, offsetBy: section) {
                eventsTableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
                return
            }
        }

    }
}

extension SavedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsByDate[eventsByDate.index(eventsByDate.startIndex, offsetBy: section)].value.count 
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = eventsByDate[eventsByDate.index(eventsByDate.startIndex, offsetBy: section)].key
        let date = formatter.date(from: key)!
        return headerFormatter.string(from: date)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventsByDate.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: "SavedEventCell", for: indexPath) as! SavedEventCell
        cell.event = eventsByDate[eventsByDate.index(eventsByDate.startIndex, offsetBy: indexPath.section)].value[indexPath.row]
        return cell
    }
}

extension SavedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return openCells.contains(indexPath) ? kOpenCellHeight : kCloseCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        if openCells.contains(indexPath) { // close cell
            openCells.remove(at: openCells.index(of: indexPath)!)
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 1.1
        } else { // open cell
            openCells.append(indexPath)
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
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
        cell.selectedAnimation(openCells.contains(indexPath), animated: false, completion:nil)
    }
}

extension SavedViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return formatter.date(from: "2016/01/01")!
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let events = eventsByDate[keyFor(date)]
        print("\(date): \(events)")
        return events?.count ?? 0
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("change page to \(self.formatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        print("calendar did select date \(self.formatter.string(from: date))")
        
        let key = keyFor(date)
        guard let index = eventsByDate.index(forKey: key) else {
            return
        }
        
        calendar.setScope(.week, animated: true)
        scrollTo(index)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
}
