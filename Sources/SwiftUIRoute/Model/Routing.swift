import Foundation

public protocol Routing: Hashable {
  var presentationStyle: PresentationStyle { get }
}

public extension Routing {
  var presentationStyle: PresentationStyle { .push }
}
