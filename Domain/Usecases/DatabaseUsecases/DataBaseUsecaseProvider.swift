//
//  DataBaseUsecase.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/23/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift

public protocol DataBaseUsecaseProvider {
	func makeQueryManager() -> QueryManager
	func makePlayStageUseCase(suggestion: SuggestionUsecase, fileHandler: Domain.AudioFileHandler) -> PlayStageUsecase
}
