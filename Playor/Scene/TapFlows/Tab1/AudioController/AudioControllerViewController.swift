//
//  AudioControllerViewController.swift
//  Playor
//
//  Created by Behrad Kazemi on 9/5/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import UIKit
import RxSwift
class AudioControllerViewController: UIViewController {
	var viewModel: AudioControllerVM!
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var backgroundImage: UIImageView!
	@IBOutlet weak var headerBlurView: UIVisualEffectView!
	@IBOutlet weak var blurViewContainer: UIView!
	
	
	let disposeBag = DisposeBag()
	override func viewDidLoad() {
		super.viewDidLoad()

	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)		
		bounceHeaderArtwork()
	}
	
	func setupUI(){
		let header = UINib(nibName: "ACHeaderView", bundle: nil)
		print(header)
		tableView.contentInset = UIEdgeInsets(top: blurViewContainer.bounds.height, left: 0, bottom: 0, right: 0)
		tableView.register(header, forHeaderFooterViewReuseIdentifier: "headerID")
		let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerID") as! ACHeaderView
		headerView.setup(viewModel: viewModel.playerVM)
		tableView.rx.setDelegate(self).disposed(by: disposeBag)
		tableView.sectionHeaderHeight = UITableView.automaticDimension
		let artworkRatio: CGFloat = 1 / 1.2
		let artworkSize = artworkRatio * UIScreen.main.bounds.width
		let height = 42 + 48 + 36.5 + 25.5 + artworkSize
		tableView.estimatedSectionHeaderHeight = height
		tableView.reloadData()
		tableView.reloadInputViews()
		tableView.delaysContentTouches = false
	}
	func bounceHeaderArtwork(){
		let headerView = tableView.headerView(forSection: 0) as! ACHeaderView
		headerView.animationForStart()

	}
}

extension AudioControllerViewController: UITableViewDelegate{
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerID") as! ACHeaderView
		headerView.setup(viewModel: viewModel.playerVM)
		return headerView
	}
}
