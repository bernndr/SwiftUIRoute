import Foundation

public final class Router<R: Routing>: ObservableObject {
  @Published var routes: [Route<R>]

  init(_ root: R) {
    routes = [.init(root, style: nil)]
  }
}

// MARK: - Present
extension Router {
  public func present(_ route: R) {
    routes.append(Route(route))
  }

  public func navigate(_ routing: [R]) {
    guard !routes.isEmpty else { return }

    var newRoutes = [routes[0]]
    newRoutes += routing.map { .init($0) }

    let firstMatchRouting = matchRouting(routes)
    routes = newRoutes
      .enumerated()
      .map {
        let currentRoute = firstMatchRouting.contains($0) ? routes[$0] : nil
        let isPresented = currentRoute.map(\.isPresented) ?? false &&
          ($0 != firstMatchRouting.last || $0 == routes.endIndex.advanced(by: -1))

        var route = $1
        route.isPresented = isPresented
        return route
      }
  }
}

// MARK: - Dismiss
extension Router {
  public func dismiss() {
    guard routes.count > 1 else { return }
    routes = routes.dropLast()
  }

  @discardableResult
  public func dismiss(_ route: R) -> Bool {
    dismiss { $0.destination == route }
  }

  public func dismissToRoot() {
    routes = [routes[0]]
  }
}

// MARK: - Dismiss Identifiable
extension Router where R: Identifiable {
  @discardableResult
  public func dismiss(_ route: R) -> Bool {
    dismiss { $0.destination.id == route.id }
  }
}

// MARK: - Routes
extension Router {
  func route(after: Route<R>) -> Route<R>? {
    if let index = routes.firstIndex(of: after)?.advanced(by: 1), index < routes.count {
      return routes[index]
    }
    return nil
  }
}

private extension Router {
  @discardableResult
  func dismiss(_ condition: (Route<R>) -> Bool) -> Bool {
    let index = routes.lastIndex { condition($0) && $0.style != nil }
    guard let index = index else { return false }

    routes = Array(routes.prefix(index))
    return true
  }

  func matchRouting(_ routes: [Route<R>]) -> Range<Int> {
    let routesPrefix = self.routes.prefix(routes.count)
    let matchRouting = routesPrefix
      .enumerated()
      .first {
        $1.destination != routes[$0].destination || $1.style != routes[$0].style
      }

    return 0..<(matchRouting?.offset ?? routesPrefix.count)
  }
}
