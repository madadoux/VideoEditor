//
//  ViewController.swift
//  VideoEditor
//
//  Created by Mohamed saeed on 11/24/20.
//

import UIKit
import SnapKit
import WPMediaPicker
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
class BaseVC : UIViewController
{
    func setupUI () {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}


class LandingVC : BaseVC, WPMediaPickerViewControllerDelegate {
    func mediaPickerController(_ picker: WPMediaPickerViewController, didFinishPicking assets: [WPMediaAsset]) {
        guard assets.count > 0 else {
            print("no assets selected")
            return
        }
        assets.first?.videoAsset(completionHandler: { (asset, err) in
            DispatchQueue.main.async {
                
            let videoPlayer = VideoPlayVC()
            videoPlayer.modalPresentationStyle = .popover
            videoPlayer.videoAsset = asset
            picker.present(videoPlayer, animated: true, completion: nil)
            }
        })
    }
    func mediaPickerControllerDidCancel(_ picker: WPMediaPickerViewController) {
        self.presentedViewController?.dismiss(animated: true , completion: nil)
    }
    
    override func setupUI() {
        super.setupUI()
        UIView.debugUI = false

        let font = UIFont.systemFont(ofSize: 20)
        let stack = DUColumn(frame: .zero, children: [DUButton(frame: .zero, title: "Video", textColor: .white, textFont: font, onTap: { btn in
            
            let options =  WPMediaPickerOptions()
            options.filter = .video
            options.allowMultipleSelection = true
            options.showMostRecentFirst = true
            let picker = WPNavigationMediaPickerViewController(options: options )
            picker.modalPresentationStyle = .fullScreen
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
            
        }, cb: { btn in
            btn.backgroundColor = .black
            btn
                .layer.cornerRadius = 10
            btn.layer.masksToBounds = true
        }),
        DUButton(frame: .zero, title: "New VideoUI", textColor: .white, textFont: font, onTap: { btn in
            
        }, cb: { btn in
            btn.backgroundColor = .black
            btn
                .layer.cornerRadius = 10
            btn.layer.masksToBounds = true

        })
        
        ], distribution: .fillEqually, alignment: .fill, spacing: 20)
        self.view.addSubview(stack)
        stack.snp.makeConstraints({ make in
            make.center.equalTo( self.view.center)
            make.width.equalTo(200)
            make.height.equalTo(100)
        })
        
    }
}
class VideoPlayVC : BaseVC {
    var videoAsset : AVAsset?
    var player : AVPlayer!
    override func setupUI() {
        guard let videoAsset = self.videoAsset else {
            return
        }
        view.backgroundColor = .white
        let playerItem = AVPlayerItem(asset: videoAsset)
        player = AVPlayer(playerItem: playerItem)
        let avPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.frame = CGRect(origin: CGPoint(x: 0, y: getStatusBarHeight()), size: CGSize(width: width, height: height * 0.3))
        self.view.layer.addSublayer(avPlayerLayer)
        player.play()
        
        
        let progressView = UIView()
        progressView.alpha = 0.5
        progressView.frame = CGRect (origin: CGPoint(x: 0, y: height * 0.3 + getStatusBarHeight() - 5 ), size: CGSize(width: width, height: 20))
        progressView.backgroundColor = .init(hexString: "#63E84A")
        view.addSubview(progressView)
        
        
        
        let duration = player.currentItem!.duration
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.1, preferredTimescale: 600), queue: DispatchQueue.main) {[weak self] (CMTime) -> Void in
            guard let self = self , let playerr = self.player else {
                return
            }
            if self.player.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player.currentTime());
                UIView.animate(withDuration: 0.2) {
                progressView.frame.size  = CGSize(width: CGFloat (time/duration.seconds) * self.width, height: 20)
                }
            }
        }

        let b = DUButton(title: "Pause", parent: view, textFont: .systemFont(ofSize: 20) ) { [weak self] btn in
            guard let self = self, let playerr = self.player else {
                return
            }

            if self.player.timeControlStatus == .paused {
                btn.setTitle("Pause", for: .normal)
                self.player.play()
            
                
            }
            else {
                btn.setTitle("Play", for: .normal)
                self.player.pause()
            }
        }
        
        b.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(height * 0.40)
        }
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem, queue: .main, using: {[weak self] noti in
            guard let self = self , let playerr = self.player else {
                return
            }

            b.setTitle("Play", for: .normal)
            self.player.seek(to: .zero)
            delay(seconds: 0.03) {
                progressView.frame.size  = CGSize(width:  self.width, height: 20)
            }

        })

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let p = player {
        p.pause()
        }
        player = nil
    }
}

class VideoEditorVC: BaseVC {
    
}

