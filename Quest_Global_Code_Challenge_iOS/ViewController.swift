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
    
    var numberOfItems = 5
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    @IBOutlet weak var searchMoreButton: UIButton!
    
    
    let viewModel = ViewModel()
    var videoPictureArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let nib = UINib.init(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModel.getVideoDataFromCodable(numberOfItems: numberOfItems)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.refreshView), name: NSNotification.Name(rawValue: "jsonInitData"), object: nil)
                
        // initialized to first indexpath
        visibleIP = IndexPath.init(row: 0, section: 0)
        
        numberOfItemsLabel.text = "0"
        
        searchMoreButton.layer.cornerRadius = 5
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        updateSearch()
    }
    @objc func refreshView() {
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
            for picture in pictures {
                if picture.nr == 0 {
                    videoPictureArray.append(picture.picture)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.numberOfItemsLabel.text = String(self.viewModel.per_page)
            self.tableView.reloadData()
        }
    }
    
    func updateSearch() {
        if numberOfItems < viewModel.total_results {
            numberOfItems = numberOfItems + 1
            viewModel.getVideoDataFromCodable(numberOfItems: numberOfItems)
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
}
