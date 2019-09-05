//
//  Observable+Ext.swift
//  SoundsPlatform
//
//  Created by Behrad Kazemi on 8/30/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
public extension ObservableType {
	 func mapToVoid() -> Observable<Void> {
		return map { _ in }
	}
}
