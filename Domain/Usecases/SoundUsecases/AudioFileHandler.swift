//
//  AudioFileHandler.swift
//  Domain
//
//  Created by Behrad Kazemi on 7/11/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
public protocol AudioFileHandler {
	func handleNewMusic(url: URL) -> Observable<Void>
}
