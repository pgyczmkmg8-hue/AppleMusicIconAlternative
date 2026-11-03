import UIKit

// UIKit only and no scene: SwiftUI is not loaded and nothing waits for a scene to become active,
// so music:// is requested as soon as the app has launched.
@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	private var pending = false
	private var done = false

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		let controller = UIViewController()
		controller.view.backgroundColor = .black
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.rootViewController = controller
		window.makeKeyAndVisible()
		self.window = window
		openMusic(application)
		return true
	}

	// Retries when the request made during launch was not accepted yet, and reopens on every return to the app.
	func applicationDidBecomeActive(_ application: UIApplication) {
		openMusic(application)
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		done = false
	}

	private func openMusic(_ application: UIApplication) {
		guard !done, !pending else { return }
		pending = true
		application.open(URL(string: "music://")!, options: [:]) { [weak self] success in
			self?.pending = false
			self?.done = success
		}
	}
}
