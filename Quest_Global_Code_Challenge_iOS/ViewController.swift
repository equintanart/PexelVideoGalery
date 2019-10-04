//
//  ViewController.swift
//  Quest_Global_Code_Challenge_iOS
//
//  Created by Erick Quintanar on 10/2/19.
//  Copyright © 2019 Erick Quintanar. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var videoArray: [Videos] = [] {
        didSet {
            print("Did set")
        }
    }
    
    let tempVideoLinkArray = ["https://player.vimeo.com/external/331114247.sd.mp4?s=774a9cd251c1df88f5f031864a7b66dcdd393837&profile_id=165&oauth2_token_id=57447761", "https://player.vimeo.com/external/336531450.sd.mp4?s=1d6fed6c6386d44ca29a7464c89d074cd5404574&profile_id=164&oauth2_token_id=57447761", "https://player.vimeo.com/external/358397399.sd.mp4?s=f0aedf596dfb897b88e03ea8ad9eb7730707e0b9&profile_id=139&oauth2_token_id=57447761", "https://player.vimeo.com/external/236075858.sd.mp4?s=488e67b8e35ca33ef18880b46bb4752da56a4035&profile_id=165&oauth2_token_id=57447761", "https://player.vimeo.com/external/291648067.sd.mp4?s=7f9ee1f8ec1e5376027e4a6d1d05d5738b2fbb29&profile_id=164&oauth2_token_id=57447761", "https://player.vimeo.com/external/282873577.sd.mp4?s=8749951ce945263606bccf5930b05d18254c9b88&profile_id=164&oauth2_token_id=57447761", "https://player.vimeo.com/external/353226442.sd.mp4?s=ed709010e22497aeffa2977fa3fa32b7573ebcc0&profile_id=165&oauth2_token_id=57447761", "https://player.vimeo.com/external/314181352.sd.mp4?s=d2cd7a37f6250cd543e6d13209730b4bcf242130&profile_id=165&oauth2_token_id=57447761", "https://player.vimeo.com/external/320621378.sd.mp4?s=9f704fce983c9c862e4c26e33ed38510e448bdfb&profile_id=164&oauth2_token_id=57447761", "https://player.vimeo.com/external/334034343.sd.mp4?s=86f5d7798a820e355dea70d0c50d892298f976af&profile_id=165&oauth2_token_id=57447761", "https://player.vimeo.com/external/338331649.sd.mp4?s=cbab1e540c39f5a9b65118779c6288e934a33924&profile_id=139&oauth2_token_id=57447761", "https://player.vimeo.com/external/121539209.sd.mp4?s=c624cdd92325a2f4b1944f36b563baa91a382a9f&profile_id=112&oauth2_token_id=57447761", "https://player.vimeo.com/external/289258217.sd.mp4?s=50b11b521df767740fa56e4743159474f540afa2&profile_id=165&oauth2_token_id=57447761", "https://player.vimeo.com/external/332093699.sd.mp4?s=87239a079ca20d2959ccd862b7560463dfac8802&profile_id=165&oauth2_token_id=57447761", "https://player.vimeo.com/external/327335901.sd.mp4?s=ae442bf07db3d94a94b6847e4a1359c5204ab871&profile_id=164&oauth2_token_id=57447761"]
    
    let tempPictureLinkArray = ["https://static-videos.pexels.com/videos/2185857/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/2324293/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/2906042/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/857251/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/1448735/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/1292738/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/2785536/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/1851190/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/1972034/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/2268807/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/2364298/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/852348/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/1409899/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/2219383/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/2076445/pictures/preview-0.jpg"]
    
    let userNameArray = ["Tim Savage","Engin Akyurt","Tim Savage","eberhard gros","Ruvim Miksans","mentatdgt","cottonbro","Space Space","Tim Savage","Joel Dunn","Tim Savage","Distill","Michal Marek","Oleg Magni","Tim Savage","Tim Savage","Engin Akyurt","Tim Savage","eberhard gros","Ruvim Miksans","mentatdgt","cottonbro","Space Space","Tim Savage","Joel Dunn","Tim Savage","Distill","Michal Marek","Oleg Magni","Tim Savage"]
    
    let urlFromNameArray = ["https://www.pexels.com/video/women-walking-on-the-shore-with-different-two-piece-swimsuits-2185857/","https://www.pexels.com/video/smoke-with-colors-232429/","https://www.pexels.com/video/women-in-their-swimsuits-walks-on-the-beach-2906042/","https://www.pexels.com/video/beautiful-timelapse-of-the-night-sky-with-reflections-in-a-lake-857251/","https://www.pexels.com/video/video-of-forest-1448735/","https://www.pexels.com/video/people-in-a-meeting-1292738/","https://www.pexels.com/video/woman-doing-a-jump-rope-exercise-2785536/","https://www.pexels.com/video/the-sun-illuminating-earth-s-surface-1851190/","https://www.pexels.com/video/following-a-woman-in-slow-motion-1972034/","https://www.pexels.com/video/an-open-book-2268807/","https://www.pexels.com/video/woman-walking-with-a-group-of-people-2364298/","https://www.pexels.com/video/coffee-at-the-morning-852348/","https://www.pexels.com/video/waves-rushing-and-splashing-to-the-shore-1409899/","https://www.pexels.com/video/white-keyboard-2219383/","https://www.pexels.com/video/people-having-drinks-at-a-bar-2076445/"]
    
    var namesFromURL:[String] = []
    
    // The current VisibleIndexPath,
    //it can be an array, but for now,
    //i am targetting one cell only
    var visibleIP : IndexPath?
    
    var aboutToBecomeInvisibleCell = -1
    var avPlayerLayer: AVPlayerLayer!
    var videoURLs = Array<URL>()
    var firtsLoad = true
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ViewModel()
    var videoLinkArray: [String] = []
    var videoPictureArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View Did Load")
        
        // Do any additional setup after loading the view.
        
        let nib = UINib.init(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModel.getVideoDataFromCodable()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.refreshView), name: NSNotification.Name(rawValue: "jsonInitData"), object: nil)
        
        viewModel.getVideoDataFromCodableWith(completion: {(error, data) in
            print("View Model Completion Data")
            
          if error != nil {
                print("Error parsing the Data - View Controller")
            } else {
                self.refreshView()
            }
        })
        
        viewModel.getVideoDataFromCodableWith2(completion: {(error, data) in
        
            
            
        })
        
        // initialized to first indexpath
        visibleIP = IndexPath.init(row: 0, section: 0)
        
        for urlName in urlFromNameArray {
            var cleanNameFromURL = urlName.replacingOccurrences(of: "https://www.pexels.com/video/", with: "")
            cleanNameFromURL = cleanNameFromURL.replacingOccurrences(of: "-", with:" ")
            cleanNameFromURL = cleanNameFromURL.components(separatedBy: CharacterSet.decimalDigits).joined()
            cleanNameFromURL = cleanNameFromURL.replacingOccurrences(of: "/", with:"")
            
            print("cleanNameFromURL")
            print(cleanNameFromURL)
            namesFromURL.append(cleanNameFromURL)
        }

    }
    
    @objc func refreshView() {
        print("refreshView")
        
        let videos = viewModel.video_files
        if videos.count > 0 {
            print("count > 0")
            for video in videos {
                if video.quality == "sd" {
                    videoLinkArray.append(video.link)
//                    print(video.link)
                }
            }
        }
        
        let pictures = viewModel.video_pictures
        if pictures.count > 0 {
            print("count > 0")
            for picture in pictures {
                if picture.nr == 0 {
                    videoPictureArray.append(picture.picture)
//                    print(picture.picture)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

extension ViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Did Select Row")
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        // Set Video name from URL
        cell.videoNameLabel.text = namesFromURL[indexPath.row]
        // Set User Name into Label
        cell.authorNameLabel.text = userNameArray[indexPath.row]
        
        let videoURLString = String(tempVideoLinkArray[indexPath.row]) + String(".mp4")
        print(videoURLString)
        let videoURL = URL(string: videoURLString)
        cell.videoPlayerItem = AVPlayerItem.init(url: videoURL!)
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexPaths = self.tableView.indexPathsForVisibleRows
        var cells = [Any]()
        for ip in indexPaths! {
            if let videoCell = self.tableView.cellForRow(at: ip) as? CustomTableViewCell{
                cells.append(videoCell)
            }
        }
        let cellCount = cells.count
        if cellCount == 0 {return}
        if cellCount == 1 {
            if visibleIP != indexPaths?[0] {
                visibleIP = indexPaths?[0]
            }
            if let videoCell = cells.last! as? CustomTableViewCell{
                self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?.last)!)
            }
        }
        
        if cellCount >= 2 {
            for i in 0..<cellCount{
                let cellRect = self.tableView.rectForRow(at: (indexPaths?[i])!)
                let intersect = cellRect.intersection(self.tableView.bounds)
//                curerntHeight is the height of the cell that
//                is visible
                let currentHeight = intersect.height
                print("\n \(currentHeight)")
                let cellHeight = (cells[i] as AnyObject).frame.size.height
//                0.95 here denotes how much you want the cell to display
//                for it to mark itself as visible,
//                .95 denotes 95 percent,
//                you can change the values accordingly
                if currentHeight > (cellHeight * 0.95) {
                    if visibleIP != indexPaths?[i]{
                        visibleIP = indexPaths?[i]
                        print ("visible = \(String(describing: indexPaths?[i]))")
                        if let videoCell = cells[i] as? CustomTableViewCell{
                            self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?[i])!)
                        }
                    }
                } else {
                    if aboutToBecomeInvisibleCell != indexPaths?[i].row{
                        aboutToBecomeInvisibleCell = (indexPaths?[i].row)!
                        if let videoCell = cells[i] as? CustomTableViewCell{
                            self.stopPlayBack(cell: videoCell, indexPath: (indexPaths?[i])!)
                        }
                        
                    }
                }
            }
        }
    }
    
    func playVideoOnTheCell(cell : CustomTableViewCell, indexPath : IndexPath){
        cell.startPlayback()
    }

    func stopPlayBack(cell : CustomTableViewCell, indexPath : IndexPath){
        cell.stopPlayback()
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("end = \(indexPath)")
        if let videoCell = cell as? CustomTableViewCell {
            videoCell.stopPlayback()
        }
    }
}
