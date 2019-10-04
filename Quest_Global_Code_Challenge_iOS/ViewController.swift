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
    
    var videoLinkArray:[String] = []
    var userNames: [String] = []
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
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("didEndDisplaying")
        //        print("end = \(indexPath)")
        if let videoCell = cell as? CustomTableViewCell {
            videoCell.stopPlayback()
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")
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
        
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            print(" you reached end of the table")
        }
        
    }
    
    func playVideoOnTheCell(cell : CustomTableViewCell, indexPath : IndexPath){
        print("playVideoOnTheCell")
        cell.startPlayback()
    }

    func stopPlayBack(cell : CustomTableViewCell, indexPath : IndexPath){
        print("stopPlayBack")
        cell.stopPlayback()
    }
    
}
