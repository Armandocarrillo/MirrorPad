import UIKit

public class DrawViewState {
  
  // MARK: - Class Properties
  
  public class var identifier: AnyHashable {
    return ObjectIdentifier(self)
    
  }
  
  //MARK: - Instance Properties
  //this creates a thight coupling between DrawViewState and DrawView
  public unowned let drawView: DrawView
  
  //MARK: - Object Lifecycle
  
  public init(drawView: DrawView) {
    self.drawView = drawView
  }
  
  // MARK: - Actions
  
  public func animate() { }
  
  public func copyLines(from source: DrawView) { }
  public func clear() { }
  public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { }
  public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { }
  
  //MARK: - State Management
  //to declare a method to change between states
  @discardableResult internal func transitionToState (matching identifier: AnyHashable) -> DrawViewState {
    let state = drawView.states[identifier]!
    drawView.currentState = state
    return state
  }
  

}

//MARK: - DrawViewDelegate

extension DrawViewState: DrawViewDelegate {
  public func drawView(_ source: DrawView, didAddLine line: LineShape) { }
  
  public func drawView(_ source: DrawView, didAddPoint point: CGPoint) { }
  
}


