

import UIKit
import AppsFlyerLib
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }


    @IBAction func trackEventPressed(_ sender: Any) {
        /* Track Event */
        AppsFlyerTracker.shared().trackEvent(AFEventLevelAchieved, withValues: [ AFEventParamLevel: 9, AFEventParamScore : 100 ]);
    }
    

}

