import Foundation

public enum PresentationStyle {
  case push
  case sheet
#if !os(macOS)
  case fullscreen
#endif
}

struct Route<R: Routing>: Equatable {
  let destination: R
  let style: PresentationStyle?

  var isPresented: Bool

  init(_ destination: R, style: PresentationStyle?) {
    self.destination = destination
    self.style = style
    self.isPresented = false
  }

  init(_ destination: R) {
    self.init(destination, style: destination.presentationStyle)
  }
}
