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
		//        print("File 📁 url: \(RLMRealmPathForFile("default.realm"))")
	}
	
	func queryAll() -> Observable<[T]> {
		return Observable.create { observer in
			let realm = self.realm
			let objects = realm.objects(T.RealmType.self)
			observer.onNext(objects.mapToDomain())
			observer.onCompleted()
			return Disposables.create()
		}
	}
	func countAll() -> Int{
		let objects = realm.objects(T.RealmType.self)
		return objects.count
	}
	
	func countAll(with predicate: NSPredicate) -> Int{
		return realm.objects(T.RealmType.self).filter(predicate).count
	}
	
	func query(with predicate: NSPredicate,
						 sortDescriptors: [NSSortDescriptor] = []) -> Observable<[T]> {
		return Observable.create { observer in
			let realm = self.realm
			let objects = realm.objects(T.RealmType.self).filter(predicate).sorted(by: sortDescriptors.map(SortDescriptor.init))
			observer.onNext(objects.mapToDomain())
			observer.onCompleted()
			return Disposables.create()
		}
	}
	
	func save(entity: T) -> Observable<Void> {
		return realm.rx.save(entity: entity, update: true)
	}
	
	func delete(entity: T) -> Observable<Void> {
		return realm.rx.delete(entity: entity)
	}
	
	func object(forPrimaryKey key: String) -> Observable<T?> {
		return Observable.create { observer in
			let realm = self.realm
			let object = realm.object(ofType: T.RealmType.self, forPrimaryKey: key)?.asDomain()
			observer.onNext(object)
			observer.onCompleted()
			return Disposables.create()
		}
	}
	
	func delete(forPrimaryKey key: String) -> Observable<Void> {
			if let object = realm.object(ofType: T.RealmType.self, forPrimaryKey: key)?.asDomain(){
				return realm.rx.delete(entity: object)
			}
			return Observable<Void>.just(())
	}
}
