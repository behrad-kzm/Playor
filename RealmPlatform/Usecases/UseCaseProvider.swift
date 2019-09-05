import Foundation
import Domain
import Realm
import RxSwift
import RealmSwift

public final class UseCaseProvider: DataBaseUsecaseProvider{
	
    private let configuration: Realm.Configuration

    public init(configuration: Realm.Configuration = Realm.Configuration()) {
        self.configuration = configuration
			let count = Repository<Playable>(configuration: configuration).countAll()
			UserDefaults.standard.set(count, forKey: Constants.Keys.User.musicCount.rawValue)
	}
	public func makeQueryManager() -> Domain.QueryManager {
		return QueryManager(configuration: configuration)
	}
	public func makePlayStageUseCase(suggestion: Domain.SuggestionUsecase, fileHandler: Domain.AudioFileHandler) -> Domain.PlayStageUsecase {
		let queryManager = QueryManager(configuration: configuration)
		return	PlayStageUsecase(suggestion: suggestion, autioFileHandler: fileHandler, musicQuery: queryManager.getSearchingQueries().getMusics, artworkQuery: queryManager.getSearchingQueries().artworks, playableQuery: queryManager.getSearchingQueries().getPlayable, musicFromPlayable: queryManager.getSearchingQueries().getMusics)
	}

}
