//
//  AudioControllerViewController.swift
//  Playor
//
//  Created by Behrad Kazemi on 9/5/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import UIKit

class AudioControllerViewController: UIViewController {
	var viewModel: AudioControllerVM!
	
	@IBOutlet weak var acShadowHolderView: UIView!
	@IBOutlet weak var acArtworkContainer: UIView!
	@IBOutlet weak var artworkImageView: UIImageView!
	@IBOutlet weak var songTitleLabel: UILabel!
	@IBOutlet weak var slider: UISlider!
	@IBOutlet weak var backwardButton: UIButton!
	@IBOutlet weak var backwardIcon: UIImageView!
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var playIcon: UIImageView!
	@IBOutlet weak var forwardButton: UIButton!
	@IBOutlet weak var forwardIcon: UIImageView!
	
	@IBOutlet weak var headerBlurView: UIVisualEffectView!
	@IBOutlet weak var buttonsContainer: UIView!
	@IBOutlet weak var sliderContainer: UIView!
	@IBOutlet weak var titleContainer: UIView!
	@IBOutlet weak var artworkContainer: UIView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var upNextLabel: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()

    }
}
