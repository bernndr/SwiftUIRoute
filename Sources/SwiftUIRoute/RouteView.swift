import SwiftUI

struct RouteView<R: Routing, Content: View>: View {
  @EnvironmentObject private var router: Router<R>

  @Binding var route: Route<R>
  @ViewBuilder let content: (R) -> Content

  var body: some View {
    content(route.destination)
      .sheet(isPresented: present(.sheet)) {
        successorView
      }
      .fullScreenCover(isPresented: present(.fullscreen)) {
        successorView
      }
      .overlay(navigation)
      .onAppear {
        route.isPresented = true
      }
  }
}

private extension RouteView {
  @ViewBuilder
  var successorView: some View {
    if let successorRoute = router.route(after: route) {
      let binding = Binding(
        get: { successorRoute },
        set: { [self] newValue in
          router.routes
            .firstIndex(of: successorRoute)
            .flatMap { router.routes[$0] = newValue }
        }
      )

      RouteView(route: binding, content: content)
        .environmentObject(router)
    }
  }

  var navigation: some View {
    NavigationLink(
      destination: successorView,
      isActive: present(.push),
      label: EmptyView.init
    )
    .isDetailLink(false)
    .hidden()
  }
}

private extension RouteView {
  func present(_ style: PresentationStyle) -> Binding<Bool> {
    let successor = router.route(after: route)
    return Binding(
      get: {
        guard case style = successor?.style, route.isPresented else {
          return false
        }
        return true
      },
      set: {
        guard !$0, let successor = successor, successor.isPresented else {
          return
        }
        router.dismiss(successor.destination)
      }
    )
  }
}
