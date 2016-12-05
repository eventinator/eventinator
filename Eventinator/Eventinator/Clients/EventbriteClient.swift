//
//  EventbriteClient.swift
//  Lineup
//
//  Created by Evelio Tarazona on 11/12/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import Foundation
import Alamofire

fileprivate let kBaseURL = "https://www.eventbriteapi.com/v3"
fileprivate let kAnonymousToken = "DKJOJJZ3BUTNOJNWMQOL"
fileprivate let kRequestTimeout = 12.0
fileprivate let kValidMIMETypes = ["application/json"]
fileprivate let kEventbriteSource = "eventbrite"

public class EventbriteClient {
    
    static let shared = EventbriteClient()
    
    func events(categories: [Category]? = nil,failure: ((Error) -> ())? = nil, success: @escaping ([Event]) -> ()) {
        var parameters: Parameters = [
            "token": kAnonymousToken,
            "sort_by": "best",
            "location.within": "100mi",
            "location.latitude": "37.7749",
            "location.longitude": "-122.4194",
            "expand": "venue,ticket_classes",
            ]
        if categories != nil {
            let ids = categories!.flatMap{ $0.id }
            parameters["categories"] = ids.joined(separator:",")
        }
        Alamofire.request(kBaseURL + "/events/search/", method: .get, parameters: parameters)
            .validate(contentType: kValidMIMETypes)
            .validate(statusCode: 200 ..< 300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    var events: [Event] = []
                    if let json = response.result.value as? NSDictionary {
                        events = Event.fromEventbrite(json)
                    }
                    success(events)
                case .failure(let error):
                    failure?(error)
                }
        }
    }
    
    func categories(failure: ((Error) -> ())? = nil, success: @escaping ([Category]) -> ()) {
        let categories = [Category(id: "103", name: "Music"),
                          Category(id: "101", name: "Business & Professional"),
                          Category(id: "110", name: "Food & Drink"),
                          Category(id: "113", name: "Community & Culture"),
                          Category(id: "105", name: "Performing & Visual Arts"),
                          Category(id: "104", name: "Film, Media & Entertainment"),
                          Category(id: "108", name: "Sports & Fitness"),
                          Category(id: "107", name: "Health & Wellness"),
                          Category(id: "102", name: "Science & Technology"),
                          Category(id: "109", name: "Travel & Outdoor"),
                          Category(id: "111", name: "Charity & Causes"),
                          Category(id: "114", name: "Religion & Spirituality"),
                          Category(id: "115", name: "Family & Education"),
                          Category(id: "116", name: "Seasonal & Holiday"),
                          Category(id: "112", name: "Government & Politics"),
                          Category(id: "106", name: "Fashion & Beauty"),
                          Category(id: "117", name: "Home & Lifestyle"),
                          Category(id: "118", name: "Auto, Boat & Air"),
                          Category(id: "119", name: "Hobbies & Special Interest"),
                          Category(id: "199", name: "Other")]
        success(categories)
    }
}

fileprivate let dateFormatter = { () -> DateFormatter in
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return df
}()

extension Event {
    static func fromEventbrite(_ json: NSDictionary) -> [Event] {
        var events = [Event]()
        let eventbriteEvents = json["events"] as! [NSDictionary]
        for eventbriteEvent in eventbriteEvents {
            events.append(Event.fromEventbrite(eventbriteEvent))
        }
        return events
    }
    
    static func fromEventbrite(_ json: NSDictionary) -> Event {
        let sourceId = json["id"] as! String
        return Event(
            id: sourceId,
            title: json.value(forKeyPath: "name.text") as? String ?? "",
            theDescription: json.value(forKeyPath: "description.text") as? String ?? "",
            start: dateFormatter.date(from: json.value(forKeyPath: "start.utc") as! String),
            end: dateFormatter.date(from: json.value(forKeyPath: "end.utc") as! String),
            locationId: json["venue_id"] as? String,
            url: URL(string: json["url"] as? String ?? ""),
            imageUrl: URL(string: json.value(forKeyPath: "logo.original.url") as? String ?? ""),
            categoryId: json["category_id"] as? String,
            guestCount: json["capacity"] as? UInt,
            source: Source(eventId: sourceId, sourceId: sourceId, source: kEventbriteSource),
            location: Location.fromEventbrite(json["venue"] as? NSDictionary),
            tickets: Ticket.fromEventbrite(json)
        )
    }
}

extension Location {
    static func fromEventbrite(_ json: NSDictionary?) -> Location? {
        guard json != nil else {
            return nil
        }
        let json = json!
        let latStr = json["latitude"] as? NSString
        let lngStr = json["longitude"] as? NSString
        return Location(
            id: json["id"] as! String,
            lat: latStr?.doubleValue ?? nil,
            lng: lngStr?.doubleValue ?? nil,
            name: json["name"] as? String,
            address: json.value(forKeyPath: "address.localized_address_display") as? String
        )
    }
}

extension Ticket {
    static func fromEventbrite(_ json: NSDictionary) -> [Ticket] {
        var tickets = [Ticket]()
        let eventbriteTickets = json["ticket_classes"] as? [NSDictionary]
        guard eventbriteTickets != nil else {
            return tickets
        }
        for eventbriteTicket in eventbriteTickets! {
            tickets.append(Ticket.fromEventbrite(eventbriteTicket))
        }
        return tickets
    }
    
    static func fromEventbrite(_ json: NSDictionary) -> Ticket {
        let sourceId = json["id"] as! String
        let free = json["free"] as? Bool ?? false
        let price = free ? "FREE" : json.value(forKeyPath: "cost.display") as? String ?? ""
        return Ticket(
            id: sourceId,
            eventId: json["event_id"] as? String,
            price: price,
            name: json["name"] as? String,
            tier: 0)
    }
}
