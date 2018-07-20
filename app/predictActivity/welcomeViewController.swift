/* Workflow:
 1) Initiallize Welcome window
 2) Wait for click on the "Start recording" button
 3) Move to the "Recording" window.
 */

import UIKit

class welcomeViewController: UIViewController {

    @IBAction func startRecording(_ sender: Any) {
        performSegue(withIdentifier: "goToRecording", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
