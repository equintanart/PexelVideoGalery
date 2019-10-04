//
//  CustomTableViewCell.swift
//  Quest_Global_Code_Challenge_iOS
//
//  Created by Erick Quintanar on 10/2/19.
//  Copyright © 2019 Erick Quintanar. All rights reserved.
//

import UIKit
import AVFoundation

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var videoNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var controllsButton: UIButton!
    @IBOutlet weak var dimButton: UIButton!
    
    
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var paused: Bool = false
    
    var videoURL: String = ""
    var pictureLink: String = ""
    
    var controllsAreShown = true
    
    //This will be called everytime a new value is set on the videoplayer item
    
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            /*
            If needed, configure player item here before associating it with a player.
            (example: adding outputs, setting text style rules, selecting media options)
            */
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupMoviePlayer()
        
    }
    
    func setupMoviePlayer() {
        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        
        if UIScreen.main.bounds.width == 375 {
            let widthRequired = self.frame.size.width - 20
            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: widthRequired, height: widthRequired/1.78)
        } else if UIScreen.main.bounds.width == 320 {
            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: (self.frame.size.height - 120) * 1.78, height: self.frame.size.height - 120)
        } else {
            let widthRequired = self.frame.size.width
            avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: widthRequired, height: widthRequired/1.78)
        }
        
        self.backgroundColor = .clear
        self.videoPlayerView.layer.insertSublayer(avPlayerLayer!, at: 0)
        
        // This notification is fired when the video ends, you can handle it in the method.
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer?.currentItem)
        
    }
    
    func stopPlayback(){
        self.avPlayer?.pause()
    }

    func startPlayback(){
        self.avPlayer?.play()
    }
    
    // A notification is fired and seeker is sent to the beginning to loop the video again
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: CMTime.zero, completionHandler: nil)
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
    }
    
    @IBAction func fullScreenActionButton(_ sender: Any) {
        print("Full Screen Button Action")
    }
    @IBAction func controllsActionButton(_ sender: Any) {
        print("Control Button Pressed")
        
        if self.avPlayer?.timeControlStatus == .playing {
            stopPlayback()
            controllsButton.setImage(UIImage(named: "play"), for: .normal)
            
        } else if self.avPlayer?.timeControlStatus == .paused {
            startPlayback()
            controllsButton.setImage(UIImage(named: "pause"), for: .normal)
            controllsButton.isHidden = true
            dimButton.alpha = 0.1
            controllsAreShown = false
        }
    }
    
    @IBAction func dimButtonAction(_ sender: Any) {
        print("Dim Button Action")
        if controllsAreShown {
            controllsButton.isHidden = true
            dimButton.alpha = 0.1
            controllsAreShown = false
        } else {
            controllsButton.isHidden = false
            dimButton.alpha = 0.5
            controllsAreShown = true
        }
    }
}
