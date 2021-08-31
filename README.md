# SwiftUIRoute
SwiftUIRoute is a centralized system for routing in SwiftUI.

## Usage
```swift
enum Destination: Routing {
  case home
  case login
  case profile(String)
  case detail

  var presentationStyle: PresentationStyle {
    switch self {
    case .home:
      return .push
    case .detail:
      return .push
    case .login:
      return .fullscreen
    case .profile:
      return .sheet
    }
  }
}
	
struct ContentView: View {
  var body: some View {
    NavigationView {
      RouterView(initial: Destination.home) {
        switch $0 {
        case .home: HomeView()
        case .detail: DetailView()
        case .login: LoginView()
        case .profile(let username): ProfileView(username: username)
        }
      }
    }  
  }
}
	
struct HomeView: View {
  @EnvironmentObject private var router: Router<Destination>
  
  var body: some View {
    VStack {
      Button("Fullscreen login") {
        router.present(.login)
      }

      Button("Sheet profile") {
        router.present(.profile(User()))
      }

      Button("Push detail") {
        router.present(.detail)
      }
    }
  }
}
```

![example](https://user-images.githubusercontent.com/12200970/131490476-2057cce3-b978-4ddd-b954-44b6627813a4.gif)

## Installation
Add this Swift package in Xcode using its Github repository url. (File > Swift Packages > Add Package Dependency...)

## License
SwiftUIRoute is available under the MIT license. See the LICENSE file for more info.
