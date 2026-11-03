import UIKit

// UIKit only: SwiftUI is not loaded and nothing waits for a view to render,
// so music:// is requested as soon as the scene connects. iOS 27 traps apps that
// do not use the scene lifecycle, so the window lives in a scene delegate.
@main
final class AppDelegate: UIResponder, UIApplicationDelegate {}

@objc(SceneDelegate)
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?
	private var pending = false
	private var done = false

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = scene as? UIWindowScene else { return }
		let controller = UIViewController()
		controller.view.backgroundColor = .black
		let window = UIWindow(windowScene: windowScene)
		window.rootViewController = controller
		window.makeKeyAndVisible()
		self.window = window
		openMusic()
	}

	// Retries when the request made while connecting was not accepted yet, and reopens on every return to the app.
	func sceneDidBecomeActive(_ scene: UIScene) {
		openMusic()
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		done = false
	}

	private func openMusic() {
		guard !done, !pending else { return }
		pending = true
		UIApplication.shared.open(URL(string: "music://")!, options: [:]) { [weak self] success in
			self?.pending = false
			self?.done = success
		}
	}
}
