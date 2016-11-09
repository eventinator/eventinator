Event
  - id: String
  - title: String
  - description: String
  - start: Date
  - end: Date
  - location_id: String
  - url: String
  - image_url: String
  - category_id: String
  - guest_count: Number

User
  - id: String
  - first_name: String
  - last_name: String
  - facebook_id: String

Category
 - id: String
 - name: String

Album:
  - event_id: String
  - photos: [String]

Ticket:
  - id: String
  - event_id: String
  - price: String
  - name: String
  - tier: Number

Location
  - id: String
  - lat: float
  - lng: float
  - name: String
  - address: String
Source
  - event_id: String
  - source_id: String
  - source: String
