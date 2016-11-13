//
//  Event.swift
//  Lineup
//
//  Created by Evelio Tarazona on 11/12/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import Foundation

struct Event {
    let id: String
    let title: String
    let description: String
    let start: Date?
    let end: Date?
    let locationId: String?
    let url: URL?
    let imageUrl: URL?
    let categoryId: String?
    let guestCount: UInt?
    let source: Source
}
