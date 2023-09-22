//
//  VideoPostView.swift
//  Navigation
//
//  Created by Diego Abramoff on 12.06.23.
//

import UIKit
import AVFoundation

class VideoPostView: UIView {

    
    //MARK: - INITs
    override init(frame: CGRect) {
        super.init(frame: frame)
        showView()
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func showView() {
//        addSubview(videoView)
//
//        NSLayoutConstraint.activate([
//            videoView.topAnchor.constraint(equalTo: topAnchor),
//            videoView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            videoView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            videoView.heightAnchor.constraint(equalToConstant: 220),
////            videoView.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
    }
    
    private func setupLayer() {
        // retrive video from project files, type "mp4"
//        let videoURL = Bundle.main.url(forResource: "GoT", withExtension: "mp4")
//        let asset = AVAsset(url: videoURL!)
//
//        // configure player
//        playerItem = AVPlayerItem(asset: asset)
////        observePlayer(playerItem)
//
//        // Создаём AVPlayer со ссылкой на видео.
//        player = AVPlayer(playerItem: playerItem)
//
//        // Создаём AVPlayerViewController и передаём ссылку на плеер.
//        let videoLayer = AVPlayerLayer(player: player)
//        videoLayer.frame = videoView.bounds
//        videoLayer.isHidden = false
//        videoLayer.backgroundColor = UIColor.red.cgColor
//        videoLayer.videoGravity = .resizeAspectFill
//        videoLayer.backgroundColor = UIColor.blue.cgColor
//        videoView.layer.addSublayer(videoLayer)
////        videoLayer.player?.play()
//        player.play()
    }
}
