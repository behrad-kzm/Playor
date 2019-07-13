//
//  FeatureBannerCell.swift
//  Playor
//
//  Created by Behrad Kazemi on 6/20/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import UIKit
import SDWebImage
class FeatureBannerCell: UICollectionViewCell {

	@IBOutlet weak var backgroundImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var container: UIView!
	static let cellID = "FeatureBannerCell"
	static let defaultCellSize = CGSize(width: UIScreen.main.bounds.width * 0.8, height: 180)
	var viewModel: FeatureBannerViewModelProtocol! {
		didSet {
			titleLabel.text = viewModel.title
			backgroundImage.image = UIImage(contentsOfFile: viewModel.backgroundArtwork.dataPath)
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

	func setupUI(){
		titleLabel.font = Appearance.Fonts.Special.cellTitle()
		container.layer.cornerRadius = 21
		container.clipsToBounds = true
	}
	
	
}
