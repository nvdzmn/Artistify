//
//  DetailsViewController.swift
//  FirstApp
//
//  Created by Navid Zaman on 4/16/20.
//  Copyright © 2020 Navid Zaman. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class DetailsViewController: UIViewController {
    
    //Static information outlets about event
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var eventTitle : String?
    var imageURL : String?
    var artistName : String?
    var venueName: String?
    var date : String?
    var time : String?
    var descriptionStuff : String?
    
    //The selected event upon which details will be shown
    var selectedEvent : Event!
    var calendars : [EKCalendar]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting appropriate labels
        eventTitleLabel.text = eventTitle
        artistNameLabel.text = artistName
        venueLabel.text = venueName
        dateLabel.text = date
        timeLabel.text = time
        descriptionLabel.text = descriptionStuff
        
        //Setting artist image
        let urlString = imageURL
        guard let url = URL(string: urlString ?? "") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed fetching image:", error!)
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Not a proper HTTPURLResponse or statusCode")
                return
            }

            DispatchQueue.main.async {
                self.artistImage.image = UIImage(data: data!)
            }
        }.resume()
    }
    
    //Segues to MapViewController
    @IBAction func mapViewButtonPressed(_ sender: UIButton) {
        
    }
    
    //Brings user to safari inputting link to ticket sale website
    @IBAction func buyTicketsButtonPressed(_ sender: UIButton) {
        if let url = URL(string: selectedEvent.offers[0].url){
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func saveTheDatePressed(_ sender: Any) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if(granted && error == nil){
                
                //Sets event details and updates apple calendar
                let event = EKEvent(eventStore: eventStore)
                event.title = self.eventTitleLabel.text
                let dateAndTime = self.selectedEvent.datetime
                let splitDateTime = dateAndTime.components(separatedBy: "T")
                
                event.startDate = self.formattedDate(date: splitDateTime[0]) //Formats date into date object
                event.notes = self.descriptionLabel.text
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                //Error Handling
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                print("Saved Event")
            }
            else{
                print("failed to save event with error : \(String(describing: error)) or access not granted")
            }
        })
    }
    
    
    
    func formattedDate(date : String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let updatedDate = dateFormatter.date(from: date)
        return updatedDate!
    }
    
}
