//
//  Track.swift
//  SwiftPlayer
//
//  Created by Abdullah Obaied on 4/17/16.
//

class Track {
    var title: String
    var imageUri: String
    var videoUri: String
    
    init(title: String, imageUri: String, videoUri: String){
        self.title = title
        self.imageUri = imageUri
        self.videoUri = videoUri
    }
}
