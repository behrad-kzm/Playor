import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		setupApplication()
		return true
	}
	
	private func setupApplication() {
		let window = UIWindow(frame: UIScreen.main.bounds)
		Application.shared.configureMainInterface(in: window)
		self.window = window
	}
}
