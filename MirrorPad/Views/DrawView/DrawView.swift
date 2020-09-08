//notify all delegate instance whenever a new line or point

@objc public protocol DrawViewDelegate: class {
  func  drawView(_ source: DrawView, didAddLine line: LineShape)
  func drawView(_ source: DrawView, didAddPoint point: CGPoint)
}

import UIKit
// here it will create a new LineShape object
public class DrawView: UIView {

  // MARK: - Instance Properties
  public var lineColor: UIColor = .black
  public var lineWidth: CGFloat = 5.0
  public var lines: [LineShape] = []

  @IBInspectable public var scaleX: CGFloat = 1 {
    didSet { applyTransform() }
  }
  @IBInspectable public var scaleY: CGFloat = 1 {
    didSet { applyTransform() }
  }
  private func applyTransform() {
    layer.sublayerTransform = CATransform3DMakeScale(scaleX, scaleY, 1)
  }
  
  //MARK:- Refactor DrawView
  
  public lazy var currentState = states[AcceptInputState.identifier]!

  public lazy var states = [AcceptInputState.identifier: AcceptInputState(drawView: self),
                            AnimateState.identifier: AnimateState(drawView: self),
                            ClearState.identifier: ClearState(drawView: self),
                            CopyState.identifier: CopyState(drawView: self)
  ]
  // MARK: - UIResponder
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    /*guard let point = touches.first?.location(in: self) else { return }
    let line = LineShape(color: lineColor, width: lineWidth, startPoint: point)
    lines.append(line)
    layer.addSublayer(line)*/
    currentState.touchesBegan(touches, with: event)
  }

  public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    /*guard let point = touches.first?.location(in: self),
      let currentLine = lines.last else { return }
    currentLine.addPoint(point)*/
    currentState.touchesMoved(touches, with:event)
  }

  // MARK: - Actions
  public func animate() {
    /*
    guard let sublayers = layer.sublayers, sublayers.count > 0 else { return }
    sublayers.forEach { $0.removeAllAnimations() }
    UIView.beginAnimations(nil, context: nil)
    CATransaction.begin()
    setSublayersStrokeEnd(to: 0.0)
    animateStrokeEnds(of: sublayers, at: 0)
    CATransaction.commit()
    UIView.commitAnimations()*/
    currentState.animate()
  }
/*
  private func setSublayersStrokeEnd(to value: CGFloat) {
    layer.sublayers?.forEach {
      guard let shapeLayer = $0 as? CAShapeLayer else { return }
      shapeLayer.strokeEnd = 0.0
      let animation = CABasicAnimation(keyPath: "strokeEnd")
      animation.fromValue = value
      animation.toValue = value
      animation.fillMode = .forwards
      shapeLayer.add(animation, forKey: nil)
    }
  }

  private func animateStrokeEnds(of layers: [CALayer], at index: Int) {
    guard index < layers.count else { return }
    let currentLayer = layers[index]
    CATransaction.begin()
    CATransaction.setCompletionBlock { [weak self] in
      currentLayer.removeAllAnimations()
      self?.animateStrokeEnds(of: layers, at: index + 1)
    }
    if let shapeLayer = currentLayer as? CAShapeLayer {
      shapeLayer.strokeEnd = 1.0
      let animation = CABasicAnimation(keyPath: "strokeEnd")
      animation.duration = 1.0
      animation.fillMode = .forwards
      animation.fromValue = 0.0
      animation.toValue = 1.0
      shapeLayer.add(animation, forKey: nil)
    }
    CATransaction.commit()
  }*/

  public func clear() {
    /*lines = []
    layer.sublayers?.removeAll()*/
    currentState.clear()
  }

  public func copyLines(from source: DrawView){
    /*layer.sublayers?.removeAll()
    lines = source.lines.deepCopy()
    lines.forEach { layer.addSublayer($0) }*/
    currentState.copyLines(from: source)
  }

  //MARK: - Delegate Management
  public let multicastDelegate = MulticastDelegate<DrawViewDelegate>()

  public func addDelegate(_ delegate: DrawViewDelegate) {
    multicastDelegate.removeDelegate(delegate)
  }

  public func removeDelegate(_ delegate: DrawViewDelegate) {
    multicastDelegate.removeDelegate(delegate)
  }

}

//MARK: -DrawViewDelegate

extension DrawView: DrawViewDelegate {
  public func drawView(_ source: DrawView, didAddPoint point: CGPoint) {
    currentState.drawView(source, didAddPoint: point)
    
  }
  public func drawView(_ source: DrawView, didAddLine line: LineShape) {
    currentState.drawView(source, didAddLine: line)
  }
}


