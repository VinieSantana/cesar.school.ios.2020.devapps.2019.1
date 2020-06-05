//
//  AboutViewController.swift
//  Carangas
//
//  Created by Vinicius on 04/06/20.
//  Copyright © 2020 CESAR School. All rights reserved.
//

import UIKit
import SideMenu
class AboutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func openGithub(_ sender: Any) {
        if let url = URL(string: "https://github.com/viniesantana" ) {
            UIApplication.shared.open(url)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
