import Foundation
import Realm
import RealmSwift
import RxSwift
import RxRealm
import Domain


final class Repository<T:RealmRepresentable>: AbstractRepository where T == T.RealmType.DomainType, T.RealmType: Object {
    private let configuration: Realm.Configuration
    private let scheduler: RunLoopThreadScheduler

    private var realm: Realm {
        return try! Realm(configuration: self.configuration)
    }

    init(configuration: Realm.Configuration) {
        self.configuration = configuration
        let name = Constants.Keys.realmRepository.rawValue
        self.scheduler = RunLoopThreadScheduler(threadName: name)
        print("File 📁 url: \(RLMRealmPathForFile("default.realm"))")
    }

    func queryAll() -> Observable<[T]> {
        return Observable.deferred {
                    let realm = self.realm
                    let objects = realm.objects(T.RealmType.self)

                    return Observable.array(from: objects)
                            .mapToDomain()
                }
                .subscribeOn(scheduler)
    }

    func query(with predicate: NSPredicate,
                        sortDescriptors: [NSSortDescriptor] = []) -> Observable<[T]> {
        return Observable.deferred {
                    let realm = self.realm
                    let objects = realm.objects(T.RealmType.self).filter(predicate).sorted(by: sortDescriptors.map(SortDescriptor.init))
                    return Observable.array(from: objects)
                            .mapToDomain()
                }
                .subscribeOn(scheduler)
    }

    func save(entity: T) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.save(entity: entity, update: true)
        }.subscribeOn(scheduler)
    }

    func delete(entity: T) -> Observable<Void> {
        return Observable.deferred {
            return self.realm.rx.delete(entity: entity)
        }.subscribeOn(scheduler)
    }
	
	func object(forPrimaryKey key: String) -> Observable<T?> {
		return Observable.deferred {
			let realm = self.realm
			let object = realm.object(ofType: T.RealmType.self, forPrimaryKey: key)?.asDomain()
			return Observable.just(object)
			}
			.subscribeOn(scheduler)
	}
	
	func delete(forPrimaryKey key: String) -> Observable<Void> {
		return Observable.deferred {
			let realm = self.realm
			if let object = realm.object(ofType: T.RealmType.self, forPrimaryKey: key)?.asDomain(){
				return self.realm.rx.delete(entity: object)
			}
			return Observable<Void>.just(())
			}.subscribeOn(scheduler)
	}
}
