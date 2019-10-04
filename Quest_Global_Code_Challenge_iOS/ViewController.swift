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
    
    let tempVideoLinkArray = ["","","","","","","","","","","","","","","","","","",""]
    var videoLinkArray:[String] = []
    
    let tempPictureLinkArray = ["https://static-videos.pexels.com/videos/2185857/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/2324293/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/2906042/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/857251/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/1448735/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/1292738/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/2785536/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/1851190/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/1972034/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/2268807/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/2364298/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/852348/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/1409899/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/2219383/pictures/preview-0.jpg", "https://static-videos.pexels.com/videos/2076445/pictures/preview-0.jpg"]
    
    var userNameArray = ["","","","","","","","","","","","","","","","","","",""]
    var userNames: [String] = []
    
    let urlFromNameArray = ["","","","","","","","","","","","","","","","","","",""]
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.refreshView), name: NSNotification.Name(rawValue: "jsonInitData"), object: nil)
                
        // initialized to first indexpath
        visibleIP = IndexPath.init(row: 0, section: 0)
        
//        userNames = userNameArray
//        namesFromURL = urlFromNameArray
//        videoLinkArray = tempVideoLinkArray

    }
    
    @objc func refreshView() {
        print("refreshView")
        
        print(viewModel.userNameArray)
        userNames = viewModel.userNameArray
        
        namesFromURL.removeAll()
        for name in viewModel.urlArray {
            
            let nameString = name
            var clearNameFromURL = nameString.replacingOccurrences(of: "https://www.pexels.com/video/", with: "")
            clearNameFromURL = clearNameFromURL.replacingOccurrences(of: "-", with:" ")
            clearNameFromURL = clearNameFromURL.components(separatedBy: CharacterSet.decimalDigits).joined()
            clearNameFromURL = clearNameFromURL.replacingOccurrences(of: "/", with:"")
            namesFromURL.append(clearNameFromURL)
        }
        
        
        videoLinkArray = viewModel.videoFileLinkArray
        
        let pictures = viewModel.video_pictures
        if pictures.count > 0 {
            print("count > 0")
            for picture in pictures {
                if picture.nr == 0 {
                    videoPictureArray.append(picture.picture)
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
        return viewModel.per_page
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        // Set Video name from URL
        cell.videoNameLabel.text = namesFromURL[indexPath.row]
        // Set User Name into Label
        cell.authorNameLabel.text = userNames[indexPath.row]
        // Set Video Lenght
        cell.durationLabel.text = viewModel.durationArray[indexPath.row]
        
        let videoURLString = String(videoLinkArray[indexPath.row]) + String(".mp4")
        let videoURL = URL(string: videoURLString)
        cell.videoPlayerItem = AVPlayerItem.init(url: videoURL!)
        cell.videoPlayerView.backgroundColor = .clear
        
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
//                print("\n \(currentHeight)")
                let cellHeight = (cells[i] as AnyObject).frame.size.height
//                0.95 here denotes how much you want the cell to display
//                for it to mark itself as visible,
//                .95 denotes 95 percent,
//                you can change the values accordingly
                if currentHeight > (cellHeight * 0.95) {
                    if visibleIP != indexPaths?[i]{
                        visibleIP = indexPaths?[i]
//                        print ("visible = \(String(describing: indexPaths?[i]))")
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
//        print("end = \(indexPath)")
        if let videoCell = cell as? CustomTableViewCell {
            videoCell.stopPlayback()
        }
    }
}
