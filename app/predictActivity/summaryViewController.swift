//
//  summaryViewController.swift
//  predictActivity
//
//  Created by Ido on 7/1/18.
//  Copyright © 2018 Shachar Hirshberg. All rights reserved.
//

import UIKit

class summaryViewController: UIViewController {
    @IBAction func startOverButton(_ sender: Any) {
        performSegue(withIdentifier: "startOver", sender: self)
    }
    var predictionsArray: [Int8] = []
    
    @IBOutlet var myText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myText.text = String(self.predictionsArray[0])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
