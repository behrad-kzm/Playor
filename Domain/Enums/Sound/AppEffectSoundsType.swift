//
//  AppEffectSoundsType.swift
//  Domain
//
//  Created by Behrad Kazemi on 6/22/19.
//  Copyright © 2019 Behrad Kazemi. All rights reserved.
//

import Foundation
public enum AppEffectSoundsType {
	public static let splash = { return Bundle.main.url(forResource: "Splash", withExtension: "mp3")!}
	public static let error = { return Bundle.main.url(forResource: "Error", withExtension: "mp3")!}
}
