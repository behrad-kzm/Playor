//
//  IOManager
//  RealmPlatform
//
//  Created by Behrad Kazemi on 6/28/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Realm
import RealmSwift
import RxSwift
import RxRealm
import Domain

public final class IOManager: Domain.IOManager {
	
	private let configuration: Realm.Configuration
	private let scheduler: RunLoopThreadScheduler
	private var realm: Realm {
		return try! Realm(configuration: self.configuration)
	}
	
	init(configuration: Realm.Configuration) {
		self.configuration = configuration
		let name = Constants.Keys.realmRepository.rawValue
		self.scheduler = RunLoopThreadScheduler(threadName: name)
	}
	
	public func insert(Playlist playlist: Playlist, TrackIDS trackIDS: [String], Artwork artwork: Artwork) -> Observable<Void> {
		let insertTracks = Observable<Void>.create {[unowned self] observer in
			trackIDS.forEach { (uid) in
				let entity = RMPlaylistTrack()
				entity.musicID = uid
				entity.playlistID = playlist.uid
				do {
					try self.realm.write {
						self.realm.add(entity, update: true)
					}
				} catch {
					observer.onError(error)
				}
			}
			observer.onNext(())
			observer.onCompleted()
			return Disposables.create()
		}
		let insertPlaylistModel = Repository<Playlist>(configuration: configuration).save(entity: playlist)
		let insertArtwork = Repository<Artwork>(configuration: configuration).save(entity: artwork)
		return insertPlaylistModel.concat(insertTracks).concat(insertArtwork)
	}
	
	public func insert(Music music: Music, PlayableModel playable: Playable, Artwork artwork: Artwork) -> Observable<Void> {
		let insertMusic = Repository<Music>(configuration: configuration).save(entity: music)
		let insertPlayable = Repository<Playable>(configuration: configuration).save(entity: playable)
		let insertArtwork = Repository<Artwork>(configuration: configuration).save(entity: artwork)
		return insertMusic.concat(insertPlayable).concat(insertArtwork)
	}
	
	public func insert(Artist artist: Artist, Artwork artwork: Artwork) -> Observable<Void> {
		let insertArtist = Repository<Artist>(configuration: configuration).save(entity: artist)
		let insertArtwork = Repository<Artwork>(configuration: configuration).save(entity: artwork)
		return insertArtist.concat(insertArtwork)
	}
	
	public func insert(Music music: Music, ToPlaylist playlist: Playlist) -> Observable<Void> {
		return Observable<Void>.create {[unowned self] observer in
			let entity = RMPlaylistTrack()
			entity.musicID = music.uid
			entity.playlistID = playlist.uid
			do {
				try self.realm.write {
					self.realm.add(entity, update: true)
				}
			} catch {
				observer.onError(error)
			}
			observer.onNext(())
			observer.onCompleted()
			return Disposables.create()
		}
	}
	
	public func insert(FeaturedCollection collection: FeaturedCollections, Playlists playlists: [Playlist]) -> Observable<Void> {
		let insertFeaturedCollection = Repository<FeaturedCollections>(configuration: configuration).save(entity: collection)
		let insertCollectionPlaylists = Observable<Void>.create {[unowned self] observer in
			playlists.forEach { (playlist) in
				let entity = RMCollectionList()
				entity.collectionID = collection.uid
				entity.playlistID = playlist.uid
				do {
					try self.realm.write {
						self.realm.add(entity, update: true)
					}
				} catch {
					observer.onError(error)
				}
			}
			observer.onNext(())
			observer.onCompleted()
			return Disposables.create()
		}
		return insertFeaturedCollection.concat(insertCollectionPlaylists)
	}
	
	public func insert(Album album: Album, Artwork artwork: Artwork) -> Observable<Void> {
		let insertAlbum = AlbumQueries(repository: Repository<Album>(configuration: configuration)).update(model: album)
		let insertArtwork = ArtworkQueries(repository: Repository<Artwork>(configuration: configuration)).update(model: artwork)
		return insertAlbum.concat(insertArtwork)
	}
	
	public func remove(Playlist playlist: Playlist) -> Observable<Void> {
		let removeTracks = Observable<Void>.create {[unowned self] observer in
			let objects = self.realm.objects(RMCollectionList.self).filter("playlistID == %@", playlist.uid)
			self.realm.delete(objects)
			observer.onNext(())
			observer.onCompleted()
			return Disposables.create()
		}
		let removePlaylist = Repository<Playlist>(configuration: configuration).delete(entity: playlist)
		let removeArtwork = Repository<Artwork>(configuration: configuration).delete(forPrimaryKey: playlist.artworkID)
		return removeTracks.concat(removePlaylist).concat(removeArtwork)
	}
	
	public func remove(Album album: Album) -> Observable<Void> {
		let removeMusics = Observable<Void>.create {[unowned self] observer in
			let objects = self.realm.objects(RMMusic.self).filter("albumID == %@", album.uid)
			let playables = objects.compactMap({ (music) -> RMPlayable? in
				return self.realm.object(ofType: RMPlayable.self, forPrimaryKey: music.playableID)
			})
			let artworks = objects.compactMap({ (music) -> RMArtwork? in
				return self.realm.object(ofType: RMArtwork.self, forPrimaryKey: music.artworkID)
			})
			self.realm.delete(artworks)
			self.realm.delete(playables)
			self.realm.delete(objects)
			observer.onNext(())
			observer.onCompleted()
			return Disposables.create()
		}
		let removeAlbum = Repository<Album>(configuration: configuration).delete(entity: album)
		let removeArtwork = Repository<Artwork>(configuration: configuration).delete(forPrimaryKey: album.artworkID)
		return removeMusics.concat(removeAlbum).concat(removeArtwork)
	}
	
	public func remove(Music music: Music) -> Observable<Void> {
		let removeArtwork = Repository<Artwork>(configuration: configuration).delete(forPrimaryKey: music.artworkID)
		let removePlayable = Repository<Playable>(configuration: configuration).delete(forPrimaryKey: music.playableID)
		let removeMusic = Repository<Music>(configuration: configuration).delete(entity: music)
		return removeArtwork.concat(removePlayable).concat(removeMusic)
	}
	
	public func remove(Artwork artwork: Artwork) -> Observable<Void> {
		let removeFile = Observable<Void>.create {observer in
			do {
				try FileManager.default.removeItem(at: artwork.dataURL)
			} catch {
				observer.onError(error)
			}
			
			observer.onNext(())
			observer.onCompleted()
			return Disposables.create()
		}
		let removeFromDB = ArtworkQueries(repository: Repository<Artwork>(configuration: configuration)).delete(model: artwork)
		return removeFile.concat(removeFromDB)
	}
	
	public func replaceWithDefault(Artwork artwork: Artwork, type: ArtworkPlaceholderType) -> Observable<Void>{
		let query = ArtworkQueries(repository: Repository<Artwork>(configuration: configuration))
		let defaultArtwork = query.getPlaceHolder(type: type, random: false)
		return defaultArtwork.flatMapLatest({ (defArtwork) -> Observable<Void> in
			let model = Artwork(uid: artwork.uid, dataURL: defArtwork.dataURL, source: .local)
			return query.update(model: model)
		})
	}
}
