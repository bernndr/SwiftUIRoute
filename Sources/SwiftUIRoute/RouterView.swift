import SwiftUI

public struct RouterView<R: Routing, Content: View>: View {
  @ViewBuilder private var content: (R) -> Content
  @StateObject private var router: Router<R>

  public init(initial: R, @ViewBuilder content: @escaping (R) -> Content) {
    _router = StateObject(wrappedValue: Router(initial))
    self.content = content
  }

  public var body: some View {
    RouteView(route: $router.routes[0], content: content)
      .environmentObject(router)
  }
}
