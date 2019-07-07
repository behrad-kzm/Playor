import Foundation
import Domain
import Realm
import RealmSwift

public final class UseCaseProvider: DataBaseUsecaseProvider{
	
    private let configuration: Realm.Configuration

    public init(configuration: Realm.Configuration = Realm.Configuration()) {
        self.configuration = configuration
			
    }
	
	public func makePlayStageUseCase(suggestion: Domain.SuggestionUsecase) -> Domain.PlayStageUsecase {
		return	PlayStageUsecase(suggestion: suggestion)
	}

}
