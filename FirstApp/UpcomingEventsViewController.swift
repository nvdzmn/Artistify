//
//  ViewController.swift
//  FirstApp
//
//  Created by Navid Zaman on 1/6/20.
//  Copyright © 2020 Navid Zaman. All rights reserved.
//

import UIKit

class UpcomingEventsViewController: UIViewController {

    @IBOutlet weak var forArtistLabel: UILabel!
    @IBOutlet weak var upcomingEventsTableView: UITableView!
    
    var artistName : String?
    
    private var myModel = EventModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myModel.getUpcomingEvents(artist: self.artistName!) { (upcomingEventArray) in
            self.myModel.events = upcomingEventArray
        }
        forArtistLabel.text = "For: \(artistName!)" //Already checked that the artist name isnt empty or nill
    }
    
    //Gets alphanumeric value of the month
    func getMonth(date: String) -> String{
        var formattedDate = ""
        let dateArray = date.components(separatedBy: "-")  //Separates numeric date into three parts(year, month, day)
        
        if(dateArray[1] == "01"){
            formattedDate += "Jan. "
        }
        else if(dateArray[1] == "02"){
            formattedDate += "Feb. "
        }
        else if(dateArray[1] == "03"){
            formattedDate += "Mar. "
        }
        else if(dateArray[1] == "04"){
            formattedDate += "Apr. "
        }
        else if(dateArray[1] == "05"){
            formattedDate += "May "
        }
        else if(dateArray[1] == "06"){
            formattedDate += "Jun. "
        }
        else if(dateArray[1] == "07"){
            formattedDate += "Jul. "
        }
        else if(dateArray[1] == "08"){
            formattedDate += "Aug. "
        }
        else if(dateArray[1] == "09"){
            formattedDate += "Sep. "
        }
        else if(dateArray[1] == "10"){
            formattedDate += "Oct. "
        }
        else if(dateArray[1] == "11"){
            formattedDate += "Nov. "
        }
        else if(dateArray[1] == "12"){
            formattedDate += "Dec. "
        }
        return formattedDate
    }
    
    //Gets day from full date
    func getDay(date: String) -> String{
        let dateArray = date.components(separatedBy: "-")
        return dateArray[2]
    }
    
    //Sends data to the details page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as? UINavigationController
        let targetVC = destinationViewController?.topViewController as? DetailsViewController
        if(segue.identifier == "upcomingSegue"){
            
            //Gets index for selected event
            let index = self.upcomingEventsTableView.indexPathForSelectedRow?.row
            let dateAndTime = myModel.events[index ?? 0].datetime
            let splitDateTime = dateAndTime.components(separatedBy: "T")
            
            //Set local variables of details view controller based on selected event
            targetVC?.eventTitle = myModel.events[index ?? 0].title
//            targetVC?.imageURL = myModel.events[index ?? 0].artist.image_url
//            targetVC?.artistName = myModel.events[index ?? 0].artist.name
            targetVC?.venueName = "Venue: \(myModel.events[index ?? 0].venue.name)"
            targetVC?.date = "Date: \(getMonth(date: splitDateTime[0]))" + " \(getDay(date: splitDateTime[0]))"
            targetVC?.time = "Time: \(splitDateTime[1])"
            targetVC?.descriptionStuff = "Description: \(myModel.events[index ?? 0].description)"
            
            //Sets the selected event in details view controller
            targetVC?.selectedEvent = myModel.events[index ?? 0]
        }
    }

}

extension UpcomingEventsViewController : UITableViewDataSource, UITableViewDelegate {
    //Sets number of sections for table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //Sets number of rows in the section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myModel.events.count
    }
    
    //Fills table view with proper data from model
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingEventCell") as! UpcomingEventTableViewCell
        let event = myModel.events[indexPath.row]
        
        let dateAndTime = event.datetime
        let splitDateTime = dateAndTime.components(separatedBy: "T")
        
        cell.monthLabel.text = getMonth(date: splitDateTime[0])
        cell.dayLabel.text = getDay(date: splitDateTime[0])
        cell.venueLabel.text = event.venue.name
        
        return cell
    }

}

