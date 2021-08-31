import Foundation

public protocol Routing: Equatable {
  var presentationStyle: PresentationStyle { get }
}

public extension Routing {
  var presentationStyle: PresentationStyle { .push }
}
