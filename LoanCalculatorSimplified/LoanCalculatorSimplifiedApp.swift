import SwiftUI

@main
struct LoanCalculatorSimplifiedApp: App {
    init() {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 36, weight: .bold)
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
