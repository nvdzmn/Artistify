//
//  Top10ViewController.swift
//  FirstApp
//
//  Created by Navid Zaman on 4/20/20.
//  Copyright © 2020 Navid Zaman. All rights reserved.
//

import Foundation
import UIKit

class Top10ViewController: UIViewController{
    private var myModel = EventModel.sharedInstance
    
    @IBOutlet weak var topTenTableView: UITableView!
    func loadTop10Artists(){
        myModel.getTop10 { (true) in
            print("Got here")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTop10Artists()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as? UINavigationController
        let targetVC = destinationViewController?.topViewController as? DetailsViewController
        if(segue.identifier == "top10segue"){
            
            //Gets index for selected event
            let index = self.topTenTableView.indexPathForSelectedRow?.row
            let dateAndTime = myModel.firstEvents[index ?? 0].datetime
            let splitDateTime = dateAndTime.components(separatedBy: "T")
            
            //Set local variables of details view controller based on selected event
            targetVC?.eventTitle = myModel.firstEvents[index ?? 0].title
//            targetVC?.imageURL = myModel.firstEvents[index ?? 0].artist.image_url
//            targetVC?.artistName = myModel.firstEvents[index ?? 0].artist.name
            targetVC?.venueName = "Venue: \(myModel.firstEvents[index ?? 0].venue.name)"
            targetVC?.date = "Date: \(getDate(date: splitDateTime[0]))"
            targetVC?.time = "Time: \(splitDateTime[1])"
            targetVC?.descriptionStuff = "Description: \(myModel.firstEvents[index ?? 0].description)"
            
            //Sets the selected event in details view controller
            targetVC?.selectedEvent = myModel.firstEvents[index ?? 0]
        }
        
    }
    
    func getDate(date : String) -> String{
        
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
        
        formattedDate += dateArray[2] //Attaches day to string
        return formattedDate
    }
    
    
        
}

extension Top10ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return myModel.firstEvents.count
    }

    //Populating the cells from data source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "top10cell") as! Top10TableViewCell
        
        let event = myModel.firstEvents[indexPath.row]
        
        //cell.artistName.text = event.artist.name
        cell.eventVenue.text = event.venue.name
        
        //Parses the date and time of event and sets appropriate labels
        let dateAndTime = event.datetime
        let splitDateTime = dateAndTime.components(separatedBy: "T")
        
        let date = getDate(date: splitDateTime[0])
        cell.date.text = date
        let startTime = splitDateTime[1]
        cell.time.text = startTime
        
        // Return the cell
        return cell
    }
    
}
