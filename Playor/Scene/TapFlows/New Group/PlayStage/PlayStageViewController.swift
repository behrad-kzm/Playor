//
//  PlayStageViewController.swift
//  Playor
//
//  Created by Behrad Kazemi on 6/17/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import UIKit
import SABlurImageView
import RxDataSources
import RxCocoa
import RxSwift
import Differentiator
import Stellar
class PlayStageViewController: UIViewController {
	
	var viewModel: PlayStageViewModel!
	let disposeBag = DisposeBag()
	

	@IBOutlet weak var musicPlayerButton: UIButton!
	@IBOutlet weak var albumsTitleLabel: UILabel!
	@IBOutlet weak var greatestHitsLabel: UILabel!
	@IBOutlet weak var recentlyTitleLabel: UILabel!
	@IBOutlet weak var pickedForUserLabel: UILabel!
	@IBOutlet weak var forYouSectionHeight: NSLayoutConstraint!
	@IBOutlet weak var recentSectionHeight: NSLayoutConstraint!
	@IBOutlet weak var recentlyTable: UITableView!
	@IBOutlet weak var greatestCollection: UICollectionView!
	@IBOutlet weak var pickedTable: UITableView!
	@IBOutlet weak var albumCollection: UICollectionView!
	@IBOutlet weak var mainStack: UIStackView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var blurHeaderView: UIVisualEffectView!
	@IBOutlet weak var audioControllerContainer: UIStackView!
	@IBOutlet weak var importFromLibrary: UIButton!
	@IBOutlet weak var artworkACImageView: UIImageView!
	@IBOutlet weak var artworkStackCellView: UIView!
	@IBOutlet weak var songTitleStackCell: UIView!
	@IBOutlet weak var controllersStackCell: UIView!
	@IBOutlet weak var artworkACContainer: UIView!
	@IBOutlet weak var songTitleACLabel: UILabel!
	@IBOutlet weak var artworkShadowHolderView: UIView!
	
	@IBOutlet weak var backwardButton: UIButton!
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var forwardButton: UIButton!
	@IBOutlet weak var backwardIcon: UIImageView!
	@IBOutlet weak var playIcon: UIImageView!
	@IBOutlet weak var forwardIcon: UIImageView!
	var artworkCurrentScale:CGFloat = 1.0
	override func viewDidLoad() {
		super.viewDidLoad()
		bindData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupUI()
	}
	
	func setupUI(){
		blurHeaderView.effect = nil
		[albumsTitleLabel, pickedForUserLabel,recentlyTitleLabel,greatestHitsLabel].forEach { (item) in
			item?.font = Appearance.Fonts.Special.defaultValue()
			item?.textColor = .white
		}
		[songTitleACLabel, backwardIcon, forwardIcon, playIcon].forEach { (item) in
			item?.alpha = 0
		}
		artworkShadowHolderView.layer.cornerRadius =  0.305 * self.artworkACContainer.bounds.size.width
		songTitleACLabel.font = Appearance.Fonts.Regular.controllerTitle()
		artworkACContainer.clipsToBounds = true
		artworkACContainer.layer.cornerRadius = 0.4 * self.artworkACContainer.bounds.size.width
		scrollView.contentInset = UIEdgeInsets(top: blurHeaderView.bounds.height, left: 0, bottom: 0, right: 0)
		scrollView.setContentOffset(CGPoint(x: 0, y: -blurHeaderView.bounds.height), animated: false)
	}
	func getBannerLayout() -> UICollectionViewFlowLayout {
		let bannerListLayout = SWInflateLayout()
		bannerListLayout.scrollDirection = .horizontal
		bannerListLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		bannerListLayout.itemSize = FeatureBannerCell.defaultCellSize
		return bannerListLayout
	}
	func bindData(){
		greatestCollection.setCollectionViewLayout(getBannerLayout(), animated: true)
		albumCollection.setCollectionViewLayout(getBannerLayout(), animated: true)
		
		let forward = forwardButton.rx.controlEvent([.touchDown]).flatMapLatest{ [unowned self]_ in
			Observable<Int64>.interval(0.3, scheduler: MainScheduler.instance).takeUntil(self.forwardButton.rx.controlEvent([.touchUpInside]))
			}.asDriverOnErrorJustComplete().mapToVoid()
		let backward = backwardButton.rx.controlEvent([.touchDown]).flatMapLatest{ [unowned self]_ in
			Observable<Int64>.interval(0.3, scheduler: MainScheduler.instance).takeUntil(self.backwardButton.rx.controlEvent([.touchUpInside]))
			}.asDriverOnErrorJustComplete().mapToVoid()
		let input = PlayStageViewModel.Input(mainScrollViewContentOffset: scrollView.rx.contentOffset.asDriver(), albumSelection: albumCollection.rx.itemSelected.asDriver(), pickedSelection: pickedTable.rx.itemSelected.asDriver(), recentSelection: recentlyTable.rx.itemSelected.asDriver(), playPause: playButton.rx.tap.asDriver(), next: forwardButton.rx.tap.asDriver(), previous: backwardButton.rx.tap.asDriver(), forward: forward, backward: backward, openController: musicPlayerButton.rx.tap.asDriver())
		let output = viewModel.transform(input: input)
		
		albumCollection.register(UINib(nibName: "FeatureBannerCell", bundle: nil), forCellWithReuseIdentifier: FeatureBannerCell.cellID)
		greatestCollection.register(UINib(nibName: "FeatureBannerCell", bundle: nil), forCellWithReuseIdentifier: FeatureBannerCell.cellID)
		
		pickedTable.register(UINib(nibName: "SongCell", bundle: nil), forCellReuseIdentifier: SongCell.cellID)
		pickedTable.rowHeight = SongCell.defaultCellHeight
		recentlyTable.register(UINib(nibName: "SongCell", bundle: nil), forCellReuseIdentifier: SongCell.cellID)
		recentlyTable.rowHeight = SongCell.defaultCellHeight
		
		let picked = output.collections.map { (items) -> [SectionItem] in
			return items[3].items
			}.do(onNext: { [unowned self](items) in
				self.forYouSectionHeight.constant = (items.count > 4) ? 5.0 * SongCell.defaultCellHeight : SongCell.defaultCellHeight * CGFloat(items.count)
				
				}, onCompleted: {[unowned self] in
					self.mainStack.layoutSubviews()
			})
		
		let albums = output.collections.map { (items) -> [SectionItem] in
			return items[0].items
		}
		
		let recently = output.collections.map { (items) -> [SectionItem] in
			return items[1].items
			}.do(onNext: { [unowned self](items) in
				self.recentSectionHeight.constant = (items.count > 4) ? 5.0 * SongCell.defaultCellHeight : SongCell.defaultCellHeight * CGFloat(items.count)
				
				}, onCompleted: {[unowned self] in
					self.mainStack.layoutSubviews()
			})
		
		let greatest = output.collections.map { (items) -> [SectionItem] in
			return items[2].items
		}
		
		greatest.drive(greatestCollection.rx.items(cellIdentifier: FeatureBannerCell.cellID, cellType: FeatureBannerCell.self)){ index, item, cell in
			if case .FeaturePlaylistSectionItem(let vm) = item {
				cell.viewModel = vm
			}
			}.disposed(by: disposeBag)
		
		albums.drive(albumCollection.rx.items(cellIdentifier: FeatureBannerCell.cellID, cellType: FeatureBannerCell.self)){ index, item, cell in
			if case .FeatureAlbumSectionItem(let vm) = item {
				cell.viewModel = vm
			}
			}.disposed(by: disposeBag)
		
		recently.drive(recentlyTable.rx.items(cellIdentifier: SongCell.cellID, cellType: SongCell.self)){ index, item, cell in
			if case .TrackSectionItem(let vm) = item {
				cell.viewModel = vm
			}
			}.disposed(by: disposeBag)
		
		picked.drive(pickedTable.rx.items(cellIdentifier: SongCell.cellID, cellType: SongCell.self)){ index, item, cell in
			if case .TrackSectionItem(let vm) = item {
				cell.viewModel = vm
			}
			}.disposed(by: disposeBag)
		
		[output.error.drive(),
		 output.backward.drive(),
		 output.forward.drive(),
		 output.openMusicplayer.drive(),
		 output.playPause.throttle(1).do(onNext: { [unowned self](status) in
			self.playIcon.image = status != .playing ? UIImage(named: "PauseButton") : UIImage(named: "PlayButton")
			let firstScale: CGFloat = 1.2
			let secondScale: CGFloat = 10.0 / 12.0
			
			if status != .playing {
				self.artworkShadowHolderView.shadowRadius(24).shadowColor(.black).shadowOpacity(0.6).shadowOffset(CGSize(width: 4, height: 8)).duration(0.2).scaleXY(firstScale, firstScale).duration(0.1).animate()
				self.artworkACContainer.scaleXY(firstScale, firstScale).duration(0.1).animate()
			}else {
				self.artworkShadowHolderView.shadowColor(.black).shadowOpacity(0).shadowOffset(CGSize(width: 0, height: 0)).duration(0.2).scaleXY(secondScale, secondScale).duration(0.1).animate()
				self.artworkACContainer.scaleXY(secondScale, secondScale).duration(0.1).animate()
			}
			self.artworkCurrentScale = status != .playing ? firstScale : secondScale
		}).drive(),
		 output.next.drive(),
		 output.previous.drive(),
		 output.artworkACPath.do(onNext: { [unowned self](path) in
			self.artworkACImageView.image = UIImage(contentsOfFile: path)
		}).drive(), output.songTitleAC.drive(songTitleACLabel.rx.text),
								output.showController.throttle(1).do(onNext: { [unowned self](shouldShow) in
									self.playIcon.image = UIImage(named: "PauseButton")
									
									self.artworkStackCellView.isHidden = !shouldShow
									self.songTitleStackCell.isHidden = !shouldShow
									self.controllersStackCell.isHidden = !shouldShow
									self.view.layoutSubviews()
									self.view.layoutIfNeeded()
									if shouldShow{
										let firstScale: CGFloat = 1.2
										let secondScale: CGFloat = 10.0 / 12.0
										
										let radiusFirst =  0.4 * self.artworkACContainer.bounds.size.width
										let radiusSecond = 0.305 * self.artworkACContainer.bounds.size.width
										if self.artworkCurrentScale == secondScale {
											self.artworkACContainer.scaleXY(firstScale, firstScale).duration(0.1).then().moveY(16).easing(.easeInEaseOut).cornerRadius(radiusFirst).scaleXY(firstScale, firstScale).duration(0.1).then().moveY(-16).easing(.swiftOut).scaleXY(secondScale, secondScale).cornerRadius(radiusSecond).animate()
											self.artworkShadowHolderView.scaleXY(firstScale, firstScale).duration(0.1).then().shadowRadius(24).shadowColor(.black).shadowOpacity(0.6).shadowOffset(CGSize(width: 4, height: 8)).duration(0.2).animate()
										} else {
											self.artworkACContainer.moveY(16).easing(.easeInEaseOut).cornerRadius(radiusFirst).scaleXY(firstScale, firstScale).duration(0.1).then().moveY(-16).easing(.swiftOut).scaleXY(secondScale, secondScale).cornerRadius(radiusSecond).animate()
											self.artworkShadowHolderView.shadowRadius(24).shadowColor(.black).shadowOpacity(0.6).shadowOffset(CGSize(width: 4, height: 8)).duration(0.2).animate()
										}
										self.artworkCurrentScale = 1
										
										self.songTitleACLabel.moveY(16).easing(.swiftOut).scaleXY(firstScale, firstScale).duration(0.1).then().moveY(-16).easing(.swiftOut).scaleXY(secondScale, secondScale).makeAlpha(1).duration(0.2).animate()
										self.playIcon.moveY(4).makeAlpha(0.5).duration(0.1).then().moveY(-4).makeAlpha(1).animate()
										self.forwardIcon.moveX(8).moveY(4).makeAlpha(0.5).duration(0.1).then().moveX(-8).moveY(-4).makeAlpha(1).animate()
										self.backwardIcon.moveY(4).makeAlpha(0.5).moveX(-8).duration(0.1).then().moveY(-4).moveX(8).makeAlpha(1).animate()
										
										Vibrator.vibrate(hardness: 3)
									}
								}).drive()
			,output.playAction.drive(),output.shouldBlur.do(onNext: { [unowned self](status) in
				if status {
					UIView.animate(withDuration: 0.3) {
						self.blurHeaderView.effect = UIBlurEffect(style: .light)
					}
				}else{
					UIView.animate(withDuration: 0.3) {
						self.blurHeaderView.effect = nil
					}
				}
			}).drive(), output.isFetching.drive(),output.checkITunes.subscribe()].forEach { (item) in
				item.disposed(by: disposeBag)
		}
	}
	
}
