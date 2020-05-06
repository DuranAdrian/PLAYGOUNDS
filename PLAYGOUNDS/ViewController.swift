//
//  ViewController.swift
//  PLAYGOUNDS
//
//  Created by Adrian Duran on 5/5/20.
//  Copyright © 2020 ScoutCloud. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices

class ViewController: UIViewController {
    let mediaContainer = UIView()
    let mediaImageView = UIImageView()
    var videoPlayer = AVPlayer()
    let videoPlayerQueue = AVQueuePlayer()
    let videoViewContainer = AVPlayerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpMediaContainer()
        
        let customButton = UIButton()
        customButton.setTitle("PRESS ME", for: .normal)
        customButton.layer.borderColor = UIColor.red.cgColor
        customButton.layer.borderWidth = 1.5
        customButton.backgroundColor = .darkGray
        customButton.addTarget(self, action: #selector(myPressedButton(_:)), for: .touchUpInside)
        customButton.translatesAutoresizingMaskIntoConstraints  = false
        view.addSubview(customButton)
        NSLayoutConstraint.activate([
            customButton.topAnchor.constraint(equalTo: mediaImageView.bottomAnchor, constant: 10),
            customButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            customButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            customButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setUpMediaContainer() {
        
        // Set Up Container
        mediaContainer.layer.borderWidth = 1.5
        mediaContainer.layer.borderColor = UIColor.black.cgColor
        mediaContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mediaContainer)
        
        // Set up mediaPlayer
        videoViewContainer.player = videoPlayer
        videoViewContainer.view.contentMode = .scaleAspectFill
        videoViewContainer.view.translatesAutoresizingMaskIntoConstraints = false
        mediaContainer.addSubview(videoViewContainer.view)
        
        // Set up ImageView
//        imageView.frame = UIImageView(frame: view.safeAreaLayoutGuide.layoutFrame)
        mediaImageView.translatesAutoresizingMaskIntoConstraints = false
        mediaImageView.backgroundColor = UIColor.black
//        mediaImageView.layer.borderWidth = 1.5
        mediaContainer.addSubview(mediaImageView)
        
        
        
        // Constraints
        NSLayoutConstraint.activate([
            // Media Container
            mediaContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mediaContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            mediaContainer.heightAnchor.constraint(equalToConstant: 250.0),
            mediaContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            
            // Image View Container
            mediaImageView.topAnchor.constraint(equalTo: mediaContainer.topAnchor),
            mediaImageView.trailingAnchor.constraint(equalTo: mediaContainer.trailingAnchor),
            mediaImageView.bottomAnchor.constraint(equalTo: mediaContainer.bottomAnchor),
            mediaImageView.leadingAnchor.constraint(equalTo: mediaContainer.leadingAnchor),
            
            videoViewContainer.view.topAnchor.constraint(equalTo: mediaContainer.topAnchor),
            videoViewContainer.view.trailingAnchor.constraint(equalTo: mediaContainer.trailingAnchor),
            videoViewContainer.view.bottomAnchor.constraint(equalTo: mediaContainer.bottomAnchor),
            videoViewContainer.view.leadingAnchor.constraint(equalTo: mediaContainer.leadingAnchor)
            
            
        ])
    }
    
    @objc func myPressedButton(_ sender: UIButton) {
        
        let pickerController = UIAlertController(title: nil, message: "Select Video", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let videoAction = UIAlertAction(title: "Videos", style: .default, handler: { (action) in
            if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                return
            }
            let mediaPicker = UIImagePickerController()
            mediaPicker.delegate = self
            mediaPicker.allowsEditing = true
            mediaPicker.mediaTypes = ["public.movie"]
            mediaPicker.videoQuality = .typeHigh
            mediaPicker.videoMaximumDuration = TimeInterval(5.0)
            self.present(mediaPicker, animated: true, completion: nil)
            
        })
        
        let photoAction = UIAlertAction(title: "Photos", style: .default, handler: { (action) in
            if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                return
            }
            let mediaPicker = UIImagePickerController()
            mediaPicker.delegate = self
            mediaPicker.allowsEditing = false
            mediaPicker.mediaTypes = ["public.image"]
            self.present(mediaPicker, animated: true, completion: nil)
            
        })

        pickerController.addAction(videoAction)
        pickerController.addAction(photoAction)
        pickerController.addAction(cancelAction)
        
        present(pickerController, animated: true, completion: nil)
    }


}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedMediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else { return }
        switch selectedMediaType {
        case "public.movie":
             print("Selected Movie")
             if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
//                videoPlayerQueue.removeAllItems()
//                let playerItem = AVPlayerItem.init(url: url)
//                videoPlayerQueue.insert(playerItem, after: nil)
//                videoPlayerQueue.play()
                mediaImageView.isHidden = true
                videoViewContainer.view.isHidden = false
                 videoPlayer = AVPlayer(url: url)
                videoViewContainer.player = videoPlayer
             }
            break
        case "public.image":
            print("Selected Image")
            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                mediaImageView.image = selectedImage
                mediaImageView.contentMode = .scaleAspectFill
                mediaImageView.clipsToBounds = true
                mediaImageView.layer.backgroundColor = UIColor.white.cgColor
                mediaImageView.isHidden = false
                videoViewContainer.view.isHidden = true
            }
            break
        default:
            print("ERROR")
        }
        
        dismiss(animated: true, completion: nil)
    }
}

