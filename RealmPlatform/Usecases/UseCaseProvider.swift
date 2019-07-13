import Foundation
import Domain
import Realm
import RxSwift
import RealmSwift

public final class UseCaseProvider: DataBaseUsecaseProvider{
	
    private let configuration: Realm.Configuration

    public init(configuration: Realm.Configuration = Realm.Configuration()) {
        self.configuration = configuration
			
	}
	public func makeQueryManager() -> Domain.QueryManager {
		return QueryManager(configuration: configuration)
	}
	public func makePlayStageUseCase(suggestion: Domain.SuggestionUsecase) -> Domain.PlayStageUsecase {
		let queryManager = QueryManager(configuration: configuration)
		return	PlayStageUsecase(suggestion: suggestion, musicQuery: queryManager.getSearchingQueries().getMusics, artworkQuery: queryManager.getSearchingQueries().artworks, playableQuery: queryManager.getSearchingQueries().getPlayable)
	}

}
