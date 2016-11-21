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
    
    func events(failure: ((Error) -> ())? = nil, success: @escaping ([Event]) -> ()) {
        let parameters: Parameters = [
            "token": kAnonymousToken,
            "sort_by": "best",
            "location.within": "100mi",
            "location.latitude": "37.7749",
            "location.longitude": "-122.4194",
            "expand": "venue,ticket_classes",
            ]
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
