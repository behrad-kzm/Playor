//
//  AudioFileHandler.swift
//  SoundsPlatform
//
//  Created by Behrad Kazemi on 7/11/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import RxSwift
import Domain
import MobileCoreServices
import AVFoundation
public final class AudioFileHandler: Domain.AudioFileHandler {
	
	private let manager : Domain.QueryManager
	let disposeBag = DisposeBag()
	init(manager: Domain.QueryManager) {
		self.manager = manager
	}
	
	public func handleNewMusic(url: URL) -> Observable<Void> {
		
		let saveFile = savefile(fromURL: url)
		let music = createMusic(fromURL: url)
		music.subscribe(onNext: { (music) in
			
		}, onError: { (error) in
			
		}, onCompleted: {
			
		}).disposed(by: disposeBag)
		return Observable.just(())
	}
	
	public func savefile(fromURL url: URL) -> Observable<Void> {
		
		let audioFileName = url.lastPathComponent
		var safeAudioName = audioFileName.replacingOccurrences(of: " ", with: "_")
		let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
		let fileSavingPath = documentsPath.path + "/" + safeAudioName
		if FileManager.default.fileExists(atPath: fileSavingPath){
			safeAudioName = safeAudioName + String(Date().timeIntervalSinceReferenceDate)
		}
		do {
			let audioData = try Data(contentsOf: url)
			let fileSavingURL = URL(fileURLWithPath: fileSavingPath)
			try audioData.write(to: fileSavingURL)
		}catch {
			return Observable.error(error)
		}
		return Observable.just(())
	}
	
	public func createMusic(fromURL url: URL) -> Observable<Music> {
		let asset = AVURLAsset(url: url)
		let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
		let fileTypeString = String(UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,url.absoluteString as CFString,nil)?.takeUnretainedValue() ?? Constants.DefaultNames.fileType.rawValue as CFString)
		let id3Title = AVMetadataItem.metadataItems(from: asset.commonMetadata, withKey: AVMetadataKey.commonKeyTitle, keySpace: .common).first
		let id3Artist = AVMetadataItem.metadataItems(from: asset.commonMetadata, withKey: AVMetadataKey.commonKeyArtist, keySpace: .common).first
		let id3Album = AVMetadataItem.metadataItems(from: asset.commonMetadata, withKey: AVMetadataKey.commonKeyAlbumName, keySpace: .common).first
		let id3Subject = AVMetadataItem.metadataItems(from: asset.commonMetadata, withKey: AVMetadataKey.commonKeySubject, keySpace: .common).first
		let id3Genre = AVMetadataItem.metadataItems(from: asset.commonMetadata, withKey: AVMetadataKey.commonKeyType, keySpace: .common).first
		let id3Artwork = AVMetadataItem.metadataItems(from: asset.commonMetadata, withKey: AVMetadataKey.commonKeyArtwork, keySpace: .common).first

		let songTitle = id3Title?.value?.copy(with: nil) as? String ?? id3Subject?.value?.copy(with: nil) as? String ?? Constants.DefaultNames.title.rawValue
		let safeAlbumName = id3Album?.value?.copy(with: nil) as? String ?? Constants.DefaultNames.album.rawValue
		let artworkData = id3Artwork?.value?.copy(with: nil) as? Data
		let audioDuration = Double(CMTimeGetSeconds(asset.duration))
		let artworkSavingPath = documentsPath.path + "/" + "Artwork_" + songTitle + String(Date().timeIntervalSinceReferenceDate)
		var artworkSavingURL = URL(fileURLWithPath: artworkSavingPath)
		do {
			try artworkData?.write(to: artworkSavingURL)
		} catch {
			artworkSavingURL = Bundle.main.url(forResource: "0", withExtension: "jpg")!
		}
		
		let artwork = Artwork(uid: UUID().uuidString, dataURL: artworkSavingURL.absoluteString, source: DataSourceType.local)
		let playable = Playable(uid: UUID().uuidString, url: url, format: fileTypeString)
		
		let genre = id3Genre?.value?.copy(with: nil) as? String ?? Constants.DefaultNames.genre.rawValue
		if let artistName = id3Artist?.value?.copy(with: nil) as? String {
			// if we found an artist there must be at least one album and one music!
			let artistResult = manager.getSingleTableQueries().getArtistQueries().artists(with: artistName)
			let sameArtistResult = artistResult.filter{$0.first != nil}.map{$0.first!}
			let sameAlbumResult = sameArtistResult.flatMapLatest { (artist) -> Observable<Album> in
				return self.manager.getSingleTableQueries().getAlbumsQueries().albums(withName: safeAlbumName, artistID: artist.uid).filter{$0.first != nil}.map{$0.first!}
			}

			let audioInsertForArtistResult = Observable.combineLatest(sameArtistResult, sameAlbumResult).flatMapLatest { (artist, album) -> Observable<Music> in
				let music = Music(uid: UUID().uuidString, title: songTitle, genre: genre, artworkID: artwork.uid, artistID: artist.uid, artistName: artist.name, playableID: playable.uid, creationDate: Date(), playCount: 0, albumID: album.uid, albumName: album.title, rate: 1.0, liked: false, duration: audioDuration)
				let result = Observable.just(music)
				return self.manager.getIOManager().insert(Music: music, PlayableModel: playable, Artwork: artwork).withLatestFrom(result)
			}
			
			let audioInsertForNoArtistResult = artistResult.filter{$0.first == nil}.flatMapLatest { _ -> Observable<Music> in
				let artistArtwork = Artwork(uid: UUID().uuidString, dataURL: Bundle.main.url(forResource: "placeholder.artist", withExtension: "jpg")!.absoluteString, source: DataSourceType.local)
				let artist = Artist(uid: UUID().uuidString, name: artistName, artworkID: artistArtwork.uid, liked: false)
				let album = Album(uid: UUID().uuidString, artistID: artist.artworkID, title: safeAlbumName, creationDate: Date(), artworkID: artwork.uid, liked: false)
				let music = Music(uid: UUID().uuidString, title: songTitle, genre: genre, artworkID: artwork.uid, artistID: artist.uid, artistName: artist.name, playableID: playable.uid, creationDate: Date(), playCount: 0, albumID: album.uid, albumName: album.title, rate: 1.0, liked: false, duration: audioDuration)
				let insertAlbum = self.manager.getIOManager().insert(Album: album, Artwork: artwork)
				let insertArtist = self.manager.getIOManager().insert(Artist: artist, Artwork: artistArtwork)
				let insertMusic = self.manager.getIOManager().insert(Music: music, PlayableModel: playable, Artwork: artwork)
				let result = Observable.just(music)
				return insertAlbum.concat(insertArtist).concat(insertMusic).withLatestFrom(result)
			}
			return Observable.merge(audioInsertForArtistResult,audioInsertForNoArtistResult)
		}
		/* Why not setting artistName a default?
		because if we use default artist name it will always artist result by searching with name so that wee need to insert new artist to separate musics that has no artist with eatch other
		*/
			let artistArtwork = Artwork(uid: UUID().uuidString, dataURL: Bundle.main.url(forResource: "placeholder.artist", withExtension: "jpg")!.absoluteString, source: DataSourceType.local)
			let artist = Artist(uid: UUID().uuidString, name: Constants.DefaultNames.artist.rawValue, artworkID: artistArtwork.uid, liked: false)
			let album = Album(uid: UUID().uuidString, artistID: artist.artworkID, title: safeAlbumName, creationDate: Date(), artworkID: artwork.uid, liked: false)
			let music = Music(uid: UUID().uuidString, title: songTitle, genre: genre, artworkID: artwork.uid, artistID: artist.uid, artistName: artist.name, playableID: playable.uid, creationDate: Date(), playCount: 0, albumID: album.uid, albumName: album.title, rate: 1.0, liked: false, duration: audioDuration)
			let insertAlbum = self.manager.getIOManager().insert(Album: album, Artwork: artwork)
			let insertArtist = self.manager.getIOManager().insert(Artist: artist, Artwork: artistArtwork)
			let insertMusic = self.manager.getIOManager().insert(Music: music, PlayableModel: playable, Artwork: artwork)
			let result = Observable.just(music)
			return insertAlbum.concat(insertArtist).concat(insertMusic).withLatestFrom(result)
	}
}
