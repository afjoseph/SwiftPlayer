//
//  ViewController.swift
//  SwiftPlayer
//
//  Created by Abdullah Obaied on 3/24/16.
//

import UIKit
import Alamofire
import SwiftyJSON
import youtube_ios_player_helper

class TrackTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, YTPlayerViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    var tracks = [Track]()
    
    let progressHUD_fetch = ProgressHUD(text: "Fetching Data")
    let progressHUD_player = ProgressHUD(text: "Loading Video")

    let playerView = YTPlayerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(progressHUD_fetch)
        progressHUD_fetch.hide()
        
        self.view.addSubview(progressHUD_player)
        progressHUD_player.hide()
        
        //Init player view
        playerView.delegate = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "TrackTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            as! TrackTableViewCell
        
        let targetTrack = tracks[indexPath.row]
        if  let url = NSURL(string: targetTrack.imageUri),
            let data = NSData(contentsOfURL: url) {
                cell.img_cover.image = UIImage(data: data)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard
            let track: Track = tracks[indexPath.row]
            else {
            fatalError("Could not find track object")
        }
        
        self.progressHUD_player.show()
        self.tableView?.allowsSelection = false
        
        let videoUriArr = track.videoUri.componentsSeparatedByString("=")
        let videoId = videoUriArr[1]
        
        self.playerView.loadWithVideoId(videoId)
    }
    
    //The video is loaded. Start Playing...
    func playerViewDidBecomeReady(playerView: YTPlayerView) {
        self.progressHUD_player.hide()
        self.tableView?.allowsSelection = true
        
        self.playerView.playVideo()
    }
    
    @IBAction func onClick_btn_reloadData() {
        progressHUD_fetch.show()
        fetchData()
    }
    
    private func fetchData() {
        let uri = "http://pastebin.com/raw/Rw6R9D2f"
        Alamofire.request(.GET, uri)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    self.progressHUD_fetch.hide()
                    
                    //Get the response's value
                    guard
                        let value = response.result.value
                    else {
                        fatalError("Couldn't find value from JSON response")
                    }
                    
                    //remove all tracks
                    self.tracks.removeAll()
                    
                    //Get the JSON object [SwiftyJson]
                    let json = JSON(value)
                    
                    //Get the tracks array
                    guard
                        let tracks = json["tracks"].array
                        else {
                        fatalError("Couldn't parse JSON response")
                    }
                    
                    for track in tracks {
                        if let title = track["title"].string,
                            let imageUri = track["imageUri"].string,
                            let videoUri = track["videoUri"].string {
                                self.tracks.append(Track(title: title, imageUri: imageUri, videoUri: videoUri))
                        }
                    }
                    
                    self.tableView?.reloadData()
                    
                case .Failure(let error):
                    self.progressHUD_fetch.hide()
                    self.showAlertViewController("Failed to connect",
                        buttonMessage: "Retry?") { action in
                            print("Reloading data")
                            self.fetchData()
                    }
                }
        }
    }
}

