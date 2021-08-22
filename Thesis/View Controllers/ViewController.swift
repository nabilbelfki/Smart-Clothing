//
//  ViewController.swift
//  Thesis
//
//  Created by Nabil Belfki on 24/11/20.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    var videoPlayer:AVPlayer?
    var videoPlayerLayer:AVPlayerLayer?
    
    
    //Connect signup button and login button from the Main Storyboard interface to this root ViewController.
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Call function named setUpElements
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Display Video in background
        setUpVideo()
    }
    
    //Creating functions
    func setUpElements(){
        Utilities.styleHollowButton(signUpButton)
        Utilities.styleFilledButton(loginButton)
    }
    func setUpVideo(){
        //Get the path to resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "loginbg", ofType: "mp4")
        guard bundlePath != nil else {
            return
        }
        //Create a URL from it
        let url = URL(fileURLWithPath: bundlePath!)
        
        //Create Video Player Item
        let item = AVPlayerItem(url: url)
        
        //Create Player
        videoPlayer = AVPlayer(playerItem: item)
        
        //Create Video Layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        //Adjust Size and Frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        //Display and Play
        videoPlayer?.playImmediately(atRate: 0.3)
    }
}

