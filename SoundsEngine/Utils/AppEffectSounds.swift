//
//  AppEffectSounds.swift
//  SoundsEngine
//
//  Created by Behrad Kazemi on 6/17/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
import AudioToolbox
public struct AppEffectSounds {
	public init() {}
	public func playSound() {
		var sound: SystemSoundID = 0
		AudioServicesCreateSystemSoundID(AppEffectSoundsType.splash() as CFURL, &sound)
		AudioServicesPlaySystemSound(sound)
	}
}
public enum AppEffectSoundsType {
	public static let splash = { return Bundle.main.url(forResource: "Splash", withExtension: "mp3")!}
}
