//
//  HomeViewController.swift
//  Thesis
//
//  Created by Nabil Belfki on 24/11/20.
//

import UIKit
import SDWebImageSwiftUI

class HomeViewController: UIViewController {

    @IBOutlet weak var nfcText: UITextView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var ImageContainer: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Do any additional setup after loading the view.
    }
   
    @IBAction func scanTapped(_ sender: Any) {
        
    }
    
}
