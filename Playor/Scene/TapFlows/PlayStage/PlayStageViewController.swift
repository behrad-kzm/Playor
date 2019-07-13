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

class PlayStageViewController: UIViewController {
	
	var viewModel: PlayStageViewModel!
	let disposeBag = DisposeBag()
	
	@IBOutlet weak var albumsTitleLabel: UILabel!
	@IBOutlet weak var greatestHitsLabel: UILabel!
	@IBOutlet weak var recentlyTitleLabel: UILabel!
	@IBOutlet weak var pickedForUserLabel: UILabel!
	
	@IBOutlet weak var albumCollection: UICollectionView!
	@IBOutlet weak var mainStack: UIStackView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var blurHeaderView: UIVisualEffectView!

	
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

		let guide = view.safeAreaLayoutGuide.layoutFrame
		scrollView.contentInset = UIEdgeInsets(top: blurHeaderView.bounds.height, left: 0, bottom: guide.origin.y + guide.size.height, right: 0)
		
	}
	
	func bindData(){
		//			let dataSource = PlayStageViewController.dataSource()
		
		let input = PlayStageViewModel.Input(mainScrollViewContentOffset: scrollView.rx.contentOffset.asDriver(), albumSelection: albumCollection.rx.itemSelected.asDriver())
		let output = viewModel.transform(input: input)
		let layout = SWInflateLayout()
		layout.scrollDirection = .horizontal
		layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		layout.itemSize = FeatureBannerCell.defaultCellSize
		albumCollection.setCollectionViewLayout(layout, animated: true)
		
		albumCollection.register(UINib(nibName: "FeatureBannerCell", bundle: nil), forCellWithReuseIdentifier: FeatureBannerCell.cellID)
		
		mainStack.insertArrangedSubview(albumCollection, at: 1)
		
		let result = output.collections.map { (items) -> [SectionItem] in
			return items[0].items
		}
		
		result.drive(albumCollection.rx.items(cellIdentifier: FeatureBannerCell.cellID, cellType: FeatureBannerCell.self)){ index, item, cell in
			
			if case .FeatureAlbumSectionItem(let vm) = item {
				cell.viewModel = vm
			}
			}.disposed(by: disposeBag)
		
		[output.error.drive(),output.shouldBlur.do(onNext: { [unowned self](status) in
			
			if status {

				UIView.animate(withDuration: 0.3) {
					self.blurHeaderView.effect = UIBlurEffect(style: .light)
				}
			}else{

				UIView.animate(withDuration: 0.3) {
					self.blurHeaderView.effect = nil
				}
			}
		}).drive(), output.isFetching.drive()].forEach { (item) in
			item.disposed(by: disposeBag)
		}
	}
}
