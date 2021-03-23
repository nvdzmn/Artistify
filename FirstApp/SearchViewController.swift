//
//  SearchViewController.swift
//  FirstApp
//
//  Created by Navid Zaman on 5/2/20.
//  Copyright © 2020 Navid Zaman. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController : UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    var myModel = EventModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.becomeFirstResponder()
        
        //UI Setup
        searchButton.layer.cornerRadius = 10
        searchButton.clipsToBounds = true
    }
    
    //Stops displaying keyboard if done button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    //Stops displaying keyboard if background touched
    @IBAction func backgroundTapped(_ sender: Any) {
        searchTextField.resignFirstResponder()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        //Flag for whether it should segue
        var shouldSegue : Bool = false
        
        //If text field is empty, display alert, clear text field, and stop segue
        if(searchTextField.text == ""){
            let alertController = UIAlertController(title: "Invalid!", message: "Please enter the name correctly", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.searchTextField.text = ""
            })
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            shouldSegue = false
        }
            
        //If text field input is incorrect, display alert and clear text field and stop segue
        else if(searchTextField.text != ""){
            myModel.getUpcomingEvents(artist: searchTextField.text!) { (potentialEvents) in
                
                //If there's no events to display
                if(potentialEvents.count == 0){
                    let alertController = UIAlertController(title: "Sorry!", message: "There doesn't seem to be any events for this artist, check spelling or search for a new artist.", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.searchTextField.text = ""
                    })
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    shouldSegue = false
                }
                else if(potentialEvents.count > 0 ){
                    shouldSegue = true
                }
            }
        }
        
        //Segues if inputted correctly
        return shouldSegue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as? UINavigationController
        let targetVC = destinationViewController?.topViewController as? UpcomingEventsViewController
        if(segue.identifier == "searchSegue"){
            targetVC?.artistName = searchTextField.text!
        }
    }
    
    
}
