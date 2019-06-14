//
//  Appearance.swift

//
//  Created by Behrad Kazemi on 11/21/18.
//  Copyright © 2018 Behrad Kazemi. All rights reserved.
//

import UIKit

enum Appearance {
	private enum hub {
		private static let boldFontName = " " 	//[TODO]type bold font name here
		private static let regularFontName = " "  //[TODO]type regular font name here
		enum fonts {
			enum Bold {
				static let title = { return UIFont(name: boldFontName, size: 18)!}
				static let subtitle = { return UIFont(name: boldFontName, size: 14)!}
				static let middle = { return UIFont(name: boldFontName, size: 16)!}
				static let header = { return UIFont(name: boldFontName, size: 20)!}
				static let caption = { return UIFont(name: boldFontName, size: 12)!}
			}
			enum Regular {
				static let title = { return UIFont(name: regularFontName, size: 16)!}
				static let caption = { return UIFont(name: regularFontName, size: 14)!}
			}
			
		}
	}
	enum colors {
		
		enum blue {
		}
		
		enum brown {
		}
		
		enum red {
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
	enum gradients {
		enum blueTone {
		}
		
		enum greenTone {
		}
		
		enum orangeTone {

		}
	}
	
	enum fonts {
		struct buttons {
			static let defaultValue = { return Appearance.hub.fonts.Bold.subtitle()}
			static let small = { return Appearance.hub.fonts.Bold.caption()}
			
			
		}
		
		struct labels {
			static let defaultValue = { return Appearance.hub.fonts.Bold.subtitle()}
			static let title = { return Appearance.hub.fonts.Bold.title()}
			static let boldBig = { return Appearance.hub.fonts.Bold.header()}
			static let details = { return Appearance.hub.fonts.Bold.caption()}
			static let mid = { return Appearance.hub.fonts.Bold.middle()}
			static let subtitle = { return Appearance.hub.fonts.Bold.subtitle()}
			static let detailedInfo = { return Appearance.hub.fonts.Regular.title()}
			static let description = { return Appearance.hub.fonts.Regular.caption()}
		}
	}
}
