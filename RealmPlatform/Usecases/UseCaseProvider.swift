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
	private let musicFromPlaylistMethod: (_ playlist: Playlist) -> Observable<[Music]>


	
	public func makePlayStageUseCase(suggestion: Domain.SuggestionUsecase) -> Domain.PlayStageUsecase {
		return	PlayStageUsecase(suggestion: suggestion, musicQuery: musicFromPlaylistMethod, artworkQuery: artworks, playableQuery: playables)
	}

}
