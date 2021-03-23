//
//  EventModel.swift
//  FirstApp
//
//  Created by Navid Zaman on 4/16/20.
//  Copyright © 2020 Navid Zaman. All rights reserved.
//

import Foundation
import SwiftyJSON

class EventModel : NSObject{
    
    //Declaration of Singleton and constants
    static let sharedInstance = EventModel()
    let ACCESS_KEY = " "
    let BASE_URL = "https://rest.bandsintown.com/artists/"
    
    //Data Structure for Event Model
    public var events: [Event] = []
    public var firstEvents : [Event] = []
    private var artists : [Artist] = []
    
    //Gets all upcoming events for specific artist from BandsInTown API
    func getUpcomingEvents(artist: String, onSuccess: @escaping ([Event]) -> Void){
        let trimmedName = artist.removingWhitespaces()
        
        var request = URLRequest(url: URL(string: "https://rest.bandsintown.com/artists/\(trimmedName)/events?app_id=\(ACCESS_KEY)&date=upcoming")! ,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
            do{
                let events = try JSONDecoder().decode([Event].self, from: data)
                onSuccess(events)
                print(String(data: data, encoding: .utf8)!)
            } catch {
                print(error)
                exit(1)
            }
        }
        task.resume()
        print("The count of FirstEvents is: \(firstEvents.count)")
        print("the count of Events is : \(events.count)")
    }
    
    //Gets top 10 artist from Billboard Top 100 and gets their first upcoming event
    func getTop10(onSuccess: @escaping (Bool) -> Void){

        let headers = [
            "x-rapidapi-host": "billboard-api2.p.rapidapi.com",
            "x-rapidapi-key": "b616e5b22dmsh078a94688a71246p198fc7jsn6c63f4994b67"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://billboard-api2.p.rapidapi.com/artist-100?date=2020-04-24&range=1-10")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let data = data {
                do {
                    let myGroup = DispatchGroup()
                    let json = try JSON(data: data)
                    for i in 1...json["content"].count{
                        let selectedArtist = Artist(name: json["content"]["\(i)"]["artist"].stringValue)
                        print(selectedArtist.artist)
                        if(selectedArtist.artist == "Drake" || selectedArtist.artist == "John Prine"){
                            //dont append, they dont have events
                        }
                        else{
                            self.artists.append(selectedArtist)
                        }
                    }
                    
                    print(self.artists.count)
                    
                    for top10artist in self.artists{
                        myGroup.enter()
                        self.getUpcomingEvents(artist: top10artist.artist) { (events) in
                            self.firstEvents.append(events.first!)
                            myGroup.leave()
                        }

                    }
                    myGroup.notify(queue: .main) {
                        onSuccess(true)
                        print("Finished all requests.")
                        print(self.firstEvents.count)
                    }
                    
                } catch {
                    print(error)
                }
            }
        })
        dataTask.resume()
    }
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
