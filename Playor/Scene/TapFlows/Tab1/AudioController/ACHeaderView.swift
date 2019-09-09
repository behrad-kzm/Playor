//
//  ACHeaderView.swift
//  Playor
//
//  Created by Behrad Kazemi on 9/6/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import UIKit
import RxSwift
import Stellar
class ACHeaderView: UITableViewHeaderFooterView {
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
	
	@IBOutlet weak var buttonsContainer: UIView!
	@IBOutlet weak var sliderContainer: UIView!
	@IBOutlet weak var titleContainer: UIView!
	@IBOutlet weak var artworkContainer: UIView!
	@IBOutlet weak var upNextLabel: UILabel!
	private var disposeBag: DisposeBag?
	
	func setup(viewModel: ACHeaderVM){
		disposeBag = nil
		disposeBag = DisposeBag()

		setupUI()
		let forward = forwardButton.rx.controlEvent([.touchDown]).flatMapLatest{ [unowned self]_ in
			Observable<Int64>.interval(0.3, scheduler: MainScheduler.instance).takeUntil(self.forwardButton.rx.controlEvent([.touchUpInside]))
			}.asDriverOnErrorJustComplete().mapToVoid()
		let backward = backwardButton.rx.controlEvent([.touchDown]).flatMapLatest{ [unowned self]_ in
			Observable<Int64>.interval(0.3, scheduler: MainScheduler.instance).takeUntil(self.backwardButton.rx.controlEvent([.touchUpInside]))
			}.asDriverOnErrorJustComplete().mapToVoid()
		let output = viewModel.transform(input: ACHeaderVM.Input(currentSlider: slider.rx.value.asDriver(), playPause: playButton.rx.tap.asDriver(), next: forwardButton.rx.tap.asDriver(), previous: backwardButton.rx.tap.asDriver(), forward: forward, backward: backward))

		[output.next.drive(),
		 output.seekAction.drive(),
		 output.forward.drive(),
		 output.previous.drive(),
		 output.backward.drive(),
		 output.currentTimePercent.drive(slider.rx.value),
			output.playPause.do(onNext: { [unowned self](status) in
			self.playIcon.image = status != .playing ? UIImage(named: "PauseButton") : UIImage(named: "PlayButton")
		}).drive(),
		 output.songTitleAC.drive(songTitleLabel.rx.text),output.artworkACPath.do(onNext: { [unowned self](path) in
			self.artworkImageView.image = UIImage(contentsOfFile: path)
		}).drive()].forEach { (item) in
			item.disposed(by: disposeBag!)
		}
	}
	func setupUI(){
		layoutIfNeeded()
		layoutSubviews()
		acShadowHolderView.layer.cornerRadius =  0.305 * self.acShadowHolderView.bounds.size.width
		songTitleLabel.font = Appearance.Fonts.Regular.controllerTitle()
		acArtworkContainer.clipsToBounds = true
		acArtworkContainer.layer.cornerRadius = 0.305 * self.acArtworkContainer.bounds.size.width
	}
	func animationForStart() {
		layoutIfNeeded()
		layoutSubviews()
		let scale: CGFloat = 10.0 / 11.0
//		.scaleXY(firstScale, firstScale).duration(0.1).then().easing(.swiftOut)
		acArtworkContainer.scaleXY(scale, scale).duration(0.2).animate()
		acShadowHolderView.scaleXY(scale, scale).shadowRadius(48).shadowColor(.black).shadowOpacity(0.8).shadowOffset(CGSize(width: 8, height: 16)).duration(0.1).then().shadowRadius(24).shadowColor(.black).shadowOpacity(0.6).shadowOffset(CGSize(width: 4, height: 8)).duration(0.2).animate()
	}
	
	override func draw(_ rect: CGRect) {
		upNextLabel.font = Appearance.Fonts.Special.defaultValue()
	}
}
