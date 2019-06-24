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
		
		@IBOutlet weak var tableView: UITableView!
		
		let disposeBag = DisposeBag()
		
		override func viewDidLoad() {
			super.viewDidLoad()
			let albumsFeature = MultipleSectionModel.FeatureListSection(title: "Albums", items: [SectionItem]())
			let sections: [MultipleSectionModel] = [
				.ToggleableSection(title: "Section 2",
													 items: [.ToggleableSectionItem(title: "On", enabled: true)]),
				.StepperableSection(title: "Section 3",
														items: [.StepperSectionItem(title: "1")])
			]
			
			let dataSource = MultipleSectionModelViewController.dataSource()
			
			Observable.just(sections)
				.bind(to: tableView.rx.items(dataSource: dataSource))
				.disposed(by: disposeBag)
		}
	}
	
	extension PlayStageViewController {
		static func dataSource() -> RxTableViewSectionedReloadDataSource<MultipleSectionModel> {
			return RxTableViewSectionedReloadDataSource<MultipleSectionModel>(
				configureCell: { (dataSource, table, idxPath, _) in
					switch dataSource[idxPath] {
					case let .ImageSectionItem(image, title):
						let cell: ImageTitleTableViewCell = table.dequeueReusableCell(forIndexPath: idxPath)
						cell.titleLabel.text = title
						cell.cellImageView.image = image
						
						return cell
					case let .StepperSectionItem(title):
						let cell: TitleSteperTableViewCell = table.dequeueReusableCell(forIndexPath: idxPath)
						cell.titleLabel.text = title
						
						return cell
					case let .ToggleableSectionItem(title, enabled):
						let cell: TitleSwitchTableViewCell = table.dequeueReusableCell(forIndexPath: idxPath)
						cell.switchControl.isOn = enabled
						cell.titleLabel.text = title
						
						return cell
					}
			},
				titleForHeaderInSection: { dataSource, index in
					let section = dataSource[index]
					return section.title
			}
			)
		}
}
