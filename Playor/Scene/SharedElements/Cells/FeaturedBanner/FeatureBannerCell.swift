//
//  FeatureBannerCell.swift
//  Playor
//
//  Created by Behrad Kazemi on 6/20/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import UIKit

class FeatureBannerCell: UICollectionViewCell {

	@IBOutlet weak var backgroundImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var container: UIView!
	var viewModel: FeatureBannerViewModelProtocol! {
		didSet {
			titleLabel.text = viewModel.title
			backgroundImage.image = viewModel.backgroundImage
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
