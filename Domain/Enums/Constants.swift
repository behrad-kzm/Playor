//
//  Constants.swift
//  Domain
//
//  Created by Behrad Kazemi on 12/26/18.
//  Copyright © 2018 Behrad Kazemi. All rights reserved.
//

import CoreTelephony
import Reachability
public enum Constants {
	public enum Keys: String {
		//MARK: - Schedulers name
		case cacheSchedulerQueueName = "com.bekapps.Network.Cache.queue"
		case realmRepository = "com.bekapps.RealmPlatform.Repository"
		//MARK: - Storage Keys
		public enum Authentication: String {
			case refreshToken = "com.bekapps.storagekeys.authentication.token.refresh"
			case accessToken = "com.bekapps.storagekeys.authentication.token.access"
			case UUID = "com.bekapps.storagekeys.authentication.info.uuid"
		}
		public enum User: String {
			case musicCount = "com.bekapps.storagekeys.music.count"
			case latestCreatedPlaylists = "com.bekapps.storagekeys.music.latestTimeForPlaylists"
			case name = ""
		}
		
	}
	public enum DefaultNames: String {
		
		//Main
		case album = "Unknown Album"
		case artist = "Unknown Artist"
		case genre = "Various"
		case title = "Untitled"
		case fileType = "UnknownFile"

	}
	public enum EndPoints: String {
		
		//Main
		case defaultBaseUrl = ""//[TODO] write your endpoint here ex: http://example.com/api/v3/
		
		//Login
		case tokenUrl = " "//[TODO] write token route here ex: account/user/token
	}
	
	public enum Info {
		public static let osType = "iOS"
		public static let osVersion = { return UIDevice.current.systemVersion}
		public static let deviceName = { return UIDevice.current.model}
		public static let deviceType = { return UIDevice.current.userInterfaceIdiom == .phone ? "Phone" : "Tablet"}
		public static let appVersion = { return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""}
		public static let connectionType = { () -> String in
			if let reachability = Reachability(){
				switch reachability.connection {
				case .cellular:
					let networkInfo = CTTelephonyNetworkInfo()
					let networkString = networkInfo.currentRadioAccessTechnology
					if networkString == CTRadioAccessTechnologyLTE{
						return "LTE"
					}else if networkString == CTRadioAccessTechnologyWCDMA{
						return "3G"
					}else if networkString == CTRadioAccessTechnologyEdge{
						return "EDGE"
					}
				case .wifi:
					return "WiFi"
				default:
					return ""
				}
			}
			return ""
		}
	}
}
