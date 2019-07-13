//
//  MultipleSectionModel.swift
//  Playor
//
//  Created by Behrad Kazemi on 6/21/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxDataSources
import RxCocoa
import RxSwift
import Differentiator

enum MultipleSectionModel {
	case TrackListSection(title: String, items: [SectionItem])
	case FeatureAlbumListSection(title: String, items: [SectionItem])
	case FeaturePlaylistListSection(title: String, items: [SectionItem])
}

enum SectionItem {
	case TrackSectionItem(viewModel: SongCellViewModelProtocol)
	case FeatureAlbumSectionItem(viewModel: StageAlbumFeatureBannerViewModel)
	case FeaturePlaylistSectionItem(viewModel: StagePlaylistFeatureBannerViewModel)
}

extension MultipleSectionModel: SectionModelType {
	typealias Item = SectionItem
	
	var items: [SectionItem] {
		switch  self {
		case .TrackListSection(title: _, items: let items):
			return items.map {$0}
		case .FeatureAlbumListSection(title: _, items: let items):
			return items.map {$0}
		case .FeaturePlaylistListSection(title: _, items: let items):
			return items.map {$0}
		}
	}
	
	init(original: MultipleSectionModel, items: [Item]) {
		switch original {
		case let .TrackListSection(title: title, items: _):
			self = .TrackListSection(title: title, items: items)
		case let .FeatureAlbumListSection(title, _):
			self = .FeatureAlbumListSection(title: title, items: items)
		case let .FeaturePlaylistListSection(title, _):
			self = .FeaturePlaylistListSection(title: title, items: items)
		}
	}
}

extension MultipleSectionModel {
	var title: String {
		switch self {
		case .TrackListSection(title: let title, items: _):
			return title
		case .FeatureAlbumListSection(title: let title, items: _):
			return title
		case .FeaturePlaylistListSection(title: let title, items: _):
			return title
		}
	}
}
