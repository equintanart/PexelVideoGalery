//
//  ViewModel.swift
//  Quest_Global_Code_Challenge_iOS
//
//  Created by Erick Quintanar on 10/3/19.
//  Copyright © 2019 Erick Quintanar. All rights reserved.
//

import Foundation


class ViewModel {
    
//    var page: Int = 0
//    var per_page: Int = 0
//    var total_results: Int = 0
//    var url: String = ""
    var videos: [Videos] = []
//
//    var id: Int = 0
//    var width: Int = 0
//    var height: Int = 0
    var videoURL: String = ""
    var imageURL: String = ""
//    var full_res: String = ""
//    var duration: Int = 0
//    var user: User
    var video_files: [VideoFiles] = []
    var video_pictures: [VideoPictures] = []
//
//    var userId: Int = 0
    var userName: String = ""
//    var userURL: String = ""
//
//    var videoFilesId: Int = 0
//    var videoFilesQuality: String = ""
//    var videoFilesFileType: String = ""
//    var videoFilesWidth: Int = 0
//    var videoFilesHeight: Int = 0
    var videoFilesLink: String = ""
//
//    var videoPicturesId: Int = 0
    var videoPicturesPictureURL: String = ""
//    var videoPicturesNr: Int = 0

    var videoData: VideoDataCodable?
    let networkManager = NetworkServiceManager.shared
    
    let videoName: String = ""
    
    func getVideoDataFromCodableWith2(completion: @escaping ([Videos], Error?)-> Void) {
        networkManager.getPopularVideoData(completion: {(error, data) in
            if error != nil {
                print("Error parsing the Data - View Model")
            } else {
                self.videos = data.videos
                completion(self.videos,nil)
            }
        })
    }
    
    func getVideoDataFromCodableWith(completion: @escaping (Array< Videos >?,Error?)-> Void) {
        networkManager.getPopularVideoData(completion: {(error, data) in
            if error != nil {
                print("Error parsing the Data - View Model")
            } else {
                self.videos = data.videos
                completion(self.videos,nil)
            }
        })
    }
    
    func getVideoDataFromCodable() {
        
        print("getVideoDataFromCodable - View Model")
        
        networkManager.getPopularVideoData(completion: {(error, data) in
            if error != nil {
                print("Error parsing the Data")
            } else {
                
                self.videos = data.videos
                
                print("Videos Count")
                print(self.videos.count)
                
                for video in self.videos {
                    
                    self.videoURL = video.url
                    print("self.videoURL")
                    print(self.videoURL)
                    
                    let videoFiles = video.video_files
                    for videoFile in videoFiles {
                        if videoFile.quality == "sd" {
                            print(videoFile.link)
                        }
                    }
                    
                    let videoPictures = video.video_pictures
                    for videoPicture in videoPictures {
                        if videoPicture.nr == 0 {
                            print(videoPicture.picture)
                        }
                    }
                    
                    self.userName = video.user.name
                    print("self.userName")
                    print(self.userName)
                }
                
                
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "jsonInitData"), object: self)
            }
        })
    }
    
}
