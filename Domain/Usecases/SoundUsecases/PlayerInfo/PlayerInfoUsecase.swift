//
//  PlayerInfoUsecase.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/22/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import Foundation
import RxSwift
import MediaPlayer

public protocol PlayerInfoUsecase {
		func get() -> Observable<PlayerInfo>
}
