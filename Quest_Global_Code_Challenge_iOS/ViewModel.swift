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
    var per_page: Int = 0
//    var total_results: Int = 0
    var url: String = ""
    var urlArray: [String] = []
    var videos: [Videos] = []
//
//    var id: Int = 0
//    var width: Int = 0
//    var height: Int = 0
    var videoURL: String = ""
    var imageURL: String = ""
//    var full_res: String = ""
//    var duration: Int = 0
    var durationString: String = ""
    var durationArray: [String] = []
    var video_files: [VideoFiles] = []
    var video_pictures: [VideoPictures] = []
//
//    var userId: Int = 0
    var userName: String = ""
    var userNameArray: [String] = []
//    var userURL: String = ""
//
//    var videoFilesId: Int = 0
//    var videoFilesQuality: String = ""
//    var videoFilesFileType: String = ""
//    var videoFilesWidth: Int = 0
//    var videoFilesHeight: Int = 0
    
    var videoFileLinkArray: [String] = []
//
//    var videoPicturesId: Int = 0
    var videoPicturesPictureURL: String = ""
//    var videoPicturesNr: Int = 0

    var videoData: VideoDataCodable?
    let networkManager = NetworkServiceManager.shared
    
    let videoName: String = ""
    
    func getVideoDataFromCodable() {
        networkManager.getPopularVideoData(completion: {(error, data) in
            if error != nil {
                print("Error parsing the Data")
            } else {
                
                self.per_page = data.per_page
                self.videos = data.videos
                
                for video in self.videos {
                
                    self.userNameArray.append(video.user.name)
                    self.urlArray.append(video.url)
                    
                    let duration = self.getFormattedVideoTime(totalVideoDuration: video.duration)
                    if duration.hour != 0 {
                        self.durationString = String(duration.hour) + ":" + String(duration.minute) + ":" + String(duration.seconds)
                    } else if duration.minute != 0 {
                        self.durationString = String(duration.minute) + ":" + String(duration.seconds)
                    } else {
                        self.durationString = "0:" + String(duration.seconds)
                    }
                    self.durationArray.append(self.durationString)
                    
                    let video_files = video.video_files
                    for videoFile in video_files {
                        if videoFile.quality == "sd" {
                            self.videoFileLinkArray.append(videoFile.link)
                            break
                        }
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "jsonInitData"), object: self)
            }
        })
    }
    
    private func getFormattedVideoTime(totalVideoDuration: Int) -> (hour: Int, minute: Int, seconds: Int){
        let seconds = totalVideoDuration % 60
        let minutes = (totalVideoDuration / 60) % 60
        let hours   = totalVideoDuration / 3600
        return (hours,minutes,seconds)
    }

    
}
