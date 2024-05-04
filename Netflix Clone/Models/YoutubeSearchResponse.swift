//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Ahmed Darwish on 28/04/2024.
//

import Foundation

struct YoutubeSearchResponse: Codable{
    let items:[VideoElement]
}

struct VideoElement: Codable{
    let id:IdVideoElement
}

struct IdVideoElement: Codable{
    let videoId: String
    let kind: String
}



