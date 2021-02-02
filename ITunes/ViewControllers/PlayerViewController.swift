//
//  PlayerViewController.swift
//  ITunes
//
//  Created by Tushar Mendiratta on 01/02/21.
//  Copyright © 2021 None. All rights reserved.
//

import UIKit
import AVFoundation
import Kingfisher

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var artImg: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var albumLbl: UILabel!
    
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var durationLbl: UILabel!
    
    
    @IBOutlet weak var slider: UISlider!
    
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var data : Track?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        slider.value = 0
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.nameLbl.text = data?.trackName ?? ""
        self.albumLbl.text = data?.collectionName ?? ""
        
        let imgUrl = URL(string: data?.artworkUrl100 ?? "")
        artImg.kf.setImage(with: imgUrl)
        let trackUrl = URL(string: data?.previewUrl ?? "")
        let playerItem:AVPlayerItem = AVPlayerItem(url: trackUrl!)
        player = AVPlayer(playerItem: playerItem)
        
        self.title = data?.artistName ?? ""
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        // Add playback slider
        slider.minimumValue = 0
        
        slider.addTarget(self, action: #selector(PlayerViewController.playbackSliderValueChanged(_:)), for: .valueChanged)
        
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        durationLbl.text = self.stringFromTimeInterval(interval: seconds)
        
        let duration1 : CMTime = playerItem.currentTime()
        let seconds1 : Float64 = CMTimeGetSeconds(duration1)
        timeLbl.text = self.stringFromTimeInterval(interval: seconds1)
        
        slider.maximumValue = Float(seconds)
        slider.isContinuous = true
        slider.tintColor = UIColor(red: 0.93, green: 0.74, blue: 0.00, alpha: 1.00)
        
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                self.slider.value = Float ( time );
                
                self.timeLbl.text = self.stringFromTimeInterval(interval: time)
            }
            
            let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
            if playbackLikelyToKeepUp == false{
                print("IsBuffering")
                self.playBtn.isHidden = true
                self.playBtn.isHidden = false
            } else {
                //stop the activity indicator
                print("Buffering completed")
                self.playBtn.isHidden = false
                //                self.loadingView.isHidden = true
            }
            
        }
        
        
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func playAction(_ sender: Any) {
        
        
        if player?.rate == 0
        {
            player!.play()
            playBtn.setBackgroundImage(UIImage(named: "pause"), for: UIControl.State.normal)
        } else {
            player!.pause()
            playBtn.setBackgroundImage(UIImage(named: "play"), for: UIControl.State.normal)
        }
    }
    
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
        }
    }
    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        playBtn.setBackgroundImage(UIImage(named: "play"), for: UIControl.State.normal)
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    
}
