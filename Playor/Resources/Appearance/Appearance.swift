//
//  Appearance.swift

//
//  Created by Behrad Kazemi on 11/21/18.
//  Copyright © 2018 Behrad Kazemi. All rights reserved.
//

import UIKit

enum Appearance {
	
	enum Colors {
		
		enum blue {
		}
		
		enum brown {
		}
		
		struct red {
			static let remove = { return UIColor.red}
		}
		
		enum green {
		}
		
		enum gray {
		}
		
		enum orange {
		}
		
		enum yellow {
		}
		
	}
	enum Gradients {
		enum blueTone {
		}
		
		enum greenTone {
		}
		
		enum orangeTone {
			
		}
	}
	
	struct Fonts {
		struct Special {
			static let logo = { return SpecialFonts.Regular.h1()}
			static let cellTitle = { return SpecialFonts.SemiBold.h2()}
			static let defaultValue = { return SpecialFonts.Regular.h2()}
		}
		struct Regular {
			static let cellTitle = { return UIFont.systemFont(ofSize: 16, weight: .regular)}
			static let controllerTitle = { return UIFont.systemFont(ofSize: 20, weight: .regular)}
		}
	}
	
}

private enum SpecialFonts {
	private static let regularFontName = "SignPainterHouseScript"  //[TODO]type regular font name here
	enum Regular {
		static let h1 = { return UIFont(name: regularFontName, size: 80)!}
		static let h2 = { return UIFont(name: regularFontName, size: 40)!}
		static let h3 = { return UIFont(name: regularFontName, size: 16)!}
	}
	enum SemiBold {// I didn't find the signPainter semibold yet
		static let h1 = { return UIFont(name: regularFontName, size: 80)!}
		static let h2 = { return UIFont(name: regularFontName, size: 50)!}
		static let h3 = { return UIFont(name: regularFontName, size: 40)!}
	}
}
