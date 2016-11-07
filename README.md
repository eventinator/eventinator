# Eventinator

The best Event app ever created.

## Description

The purpose of the app is to help users find and discover new events around them. The key differentiating aspect of the app is that it makes event discovery painless and enjoyable by surfacing events you care about first and clearing away discarded ones to keep the discovery process smooth and uncluttered. The app will feature a side-swipe styled UI that makes it easy for users to discover and like events relevant to their interests and to clear away others.

After a user has liked an event, it will appear in her Events tab where she can view it alongside her other events in either a list or calendar view. The user can drill down into each event to see all of its relevant information.
The app will feature the use of real-time location, maps, notifications, and a beautiful and playful UI.

## User Stories

 - When the user first logs in to the app, she is presented with an app intro that has a walkthrough of the app features. The user will login with her Facebook credentials. There will a follow up screen that asks the user for her interests in event categories.
 - The bottom of the app will feature a Tab bar navigation with the following tabs:
   - Discover
     - Swipe left and right to view one event at a time. Events tailored to the user’s specific interests will be surfaced first
     - Each event is a view which can unfold and expand with touch and show more details related to the event including a map view
     - User can “like” the event to add it to her list of events to be viewed later. 
     - User can “pass” on the event to remove it from the discovery deck
   - My Events
     - Presents a list view highlighting liked events. Each event is a view which can unfold and expand with touch and show more details related to the event including a map view
     - Presents a calendar view highlighting liked events. The user can drill down into individual days and to the events to see an event detail page
   - Profile
     - View shows a grid view of event categories with which the user can reconfigure her category interests
     - User can configure app settings
 - The following user stories are optional: (high, med, and low refer to the effort to implement the feature, with high being the most work and low being the least)
   - Event Detail
     - Optional: Account and liked Events server side persistence to allow user to re-login after clearing app data (med)
     - Optional: Integration with Facebook events (high)
     - Optional: Facebook friends who have also “liked” an event will show up on the event card and detail page (med)
     - Optional: Facebook friends who are listed in Facebook as “Attending” or “Interested” in the event will show up on the event card and detail page (high)
     - Optional: Integration with Meetup events (high)
     - Optional: Meetup group members RSVPed as attending avents will show up on the event card and detail page (high)
     - Optional: Allow users to upload images to the event detail page to be viewed by other users. (high)
     - Optional: Create real-time chat channels(high)
     - Optional: Create a comment thread system for each event to allow users to ask questions or post general comments regarding the event. (high)
     - Optional: Pull instagram photos for the event given location/time/name/hashtags (high)
     - Optional: User can invite Facebook and Address book friends to any event. (med)
     - Optional: Invited friends appear on event (med)
     - Optional: User can request a Lyft to the event location (med)
     - Optional: Stream of tweets around the event (med)
     - Optional: User can skip registration (low)
     - Optional: Behavior learning to better surface even more relevant events (high)

## License

    Copyright 2016 eventinator

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
