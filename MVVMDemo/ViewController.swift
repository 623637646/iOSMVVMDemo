//
//  ViewController.swift
//  MVVMDemo
//
//  Created by Wang Ya on 5/8/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToLoginPage(_ sender: Any) {
        let loginVC = LoginVC()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func goToPay(_ sender: Any) {
        
    }
}

