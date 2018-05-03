//
//  ViewController.swift
//  SegmentSwiftSampleApp
//
//  Created by Jonathan Wesfield on 03/05/2018.
//  Copyright © 2018 AppsFlyer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        sendEvent()
    }

   
    func sendEvent() {
        var eventValues = [ String:Any]()
        eventValues["name"] = "JON"
        eventValues["signed_in"] = true
        eventValues["email"] = "jon@gmail.com"
        eventValues["user_id"] = "123456"
        SEGAnalytics.shared().track("test_event_1", properties: eventValues)
    }


}

