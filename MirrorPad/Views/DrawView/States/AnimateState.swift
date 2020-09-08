import UIKit

public class AnimateState: DrawViewState {
  public override func animate() {
    
  guard let sublayers = drawView.layer.sublayers, sublayers.count > 0 else {
   //if there arent any animation, return to AcceptInputState
  transitionToState(matching: AcceptInputState.identifier)
  return
  
  }
  
  sublayers.forEach { $0.removeAllAnimations() }
  UIView.beginAnimations(nil, context:nil)
  CATransaction.begin()
  CATransaction.setCompletionBlock { [weak self] in
    //The entire animation is complete, back to AcceptInputState
    self?.transitionToState(matching: AcceptInputState.identifier)
  }
    setSublayersStokeEnd(to: 0.0)
    animateStokeEnds(of: sublayers, at:0)
    CATransaction.commit()
    UIView.commitAnimations()
  }
  
  private func setSublayersStokeEnd(to value: CGFloat){
    drawView.layer.sublayers?.forEach {guard let shapeLayer = $0 as? CAShapeLayer else { return }
      shapeLayer.strokeEnd = 0.0
      let animation = CABasicAnimation(keyPath: "strokedEnd")
      animation.fromValue = value
      animation.toValue = value
      animation.fillMode = .forwards
      shapeLayer.add(animation, forKey: nil)
      }
}

  private func animateStokeEnds(of layers: [CALayer], at index: Int){
    guard index < layers.count else { return }
    let currentLayer = layers[index]
    CATransaction.setCompletionBlock {
      [weak self] in currentLayer.removeAllAnimations()
      self?.animateStokeEnds(of: layers, at: index + 1)
    }
    if let shapeLayer = currentLayer as? CAShapeLayer {
      shapeLayer.strokeEnd = 1.0
      let animation = CABasicAnimation(keyPath: "stokeEnd")
      animation.duration = 1.0
      animation.fillMode = .forwards
      animation.fromValue = 0.0
      animation.toValue = 1.0
      shapeLayer.add(animation, forKey: nil)
    }
    CATransaction.commit()
}
}
