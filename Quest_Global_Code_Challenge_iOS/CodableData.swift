//
//  CodableData.swift
//  Quest_Global_Code_Challenge_iOS
//
//  Created by Erick Quintanar on 10/2/19.
//  Copyright © 2019 Erick Quintanar. All rights reserved.
//

import Foundation

//struct JSONDataCodable: Codable {
//    let VideoData: VideoDataCodable
//}

struct VideoDataCodable: Codable {
    let page: Int
    let per_page: Int
    let total_results: Int
    let url: String
    let videos: [Videos]
}

    struct Videos: Codable {
        let id: Int
        let width: Int
        let height: Int
        let url: String
        let image: String
        let full_res: String?
        let duration: Int
        let user: User
        let video_files: [VideoFiles]
        let video_pictures: [VideoPictures]
    }

        struct User: Codable {
            let id: Int
            let name: String
            let url: String
        }

        struct VideoFiles: Codable {
            let id: Int
            let quality: String
            let file_type: String
            let width: Int?
            let height: Int?
            let link: String
        }

        struct VideoPictures: Codable {
            let id: Int
            let picture: String
            let nr: Int
        }

