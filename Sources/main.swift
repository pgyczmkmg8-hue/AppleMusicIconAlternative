import SwiftUI

@main
struct MusicLauncherApp: App {
	@Environment(\.scenePhase) private var scenePhase

	var body: some Scene {
		WindowGroup {
			Color.black.ignoresSafeArea()
		}
		.onChange(of: scenePhase) { phase in
			if phase == .active {
				UIApplication.shared.open(URL(string: "music://")!)
			}
		}
	}
}
