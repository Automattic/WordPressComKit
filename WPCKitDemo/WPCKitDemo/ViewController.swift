//
//  ViewController.swift
//  WPCKitDemo
//
//  Created by Aaron Douglas on 12/7/15.
//  Copyright © 2015 Automattic. All rights reserved.
//

import UIKit
import WordPressComKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doSomethingFun(sender: UIButton) {
        RequestRouter.bearerToken = ""
        
        let meService = MeService()
        meService.fetchMe { me, error in
            print("Me: \(me) \n\nError: \(error)")
        }
    }
}

