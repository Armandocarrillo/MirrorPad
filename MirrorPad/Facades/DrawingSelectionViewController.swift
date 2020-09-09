
import UIKit

public protocol DrawingSelectionViewControllerDelegate: class {
  func drawingSelectionViewControllerDidCancel(_ viewController: DrawingSelectionViewController)

  func drawingSelectionViewController(_ viewController: DrawingSelectionViewController,
                                      didSelectView view: UIView)
}

public final class DrawingSelectionViewController: UIViewController {

  // MARK: - Constructors
  public class func createInstance(
    entireDrawing: UIView,
    inputDrawing: UIView,
    delegate: DrawingSelectionViewControllerDelegate) -> DrawingSelectionViewController {

    let viewController = DrawingSelectionViewController(nibName: nil, bundle: nil)
    viewController.modalPresentationStyle = .overCurrentContext
    viewController.modalTransitionStyle = .crossDissolve

    viewController.entireDrawing = entireDrawing
    viewController.inputDrawing = inputDrawing
    viewController.selectedDrawing = inputDrawing

    viewController.delegate = delegate
    return viewController
  }

  // MARK: - Instance Properties
  public var delegate: DrawingSelectionViewControllerDelegate?

  private var entireDrawing: UIView!
  private var inputDrawing: UIView!
  private var selectedDrawing: UIView!

  // MARK: - Outlets
  @IBOutlet var expandContractButton: UIButton!

  // MARK: - View Lifecycle
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.frame = selectedDrawing.frame
  }

  // MARK: - Actions
  @IBAction internal func cancelPressed(_ sender: Any) {
    delegate?.drawingSelectionViewControllerDidCancel(self)
  }

  @IBAction internal func sharePressed(_ sender: Any) {
    delegate?.drawingSelectionViewController(self, didSelectView: selectedDrawing)
  }

  @IBAction internal func expandContractPressed(_ sender: Any) {
    toggleSelectedDrawing()
    animateViewBounds()
  }

  private func toggleSelectedDrawing() {
    if selectedDrawing === inputDrawing {
      selectedDrawing = entireDrawing
    } else {
      selectedDrawing = inputDrawing
    }
  }

  private func animateViewBounds() {
    let newBounds = selectedDrawing.bounds
    UIView.animateKeyframes(
      withDuration: 0.33, delay: 0.0, options: .layoutSubviews,
      animations: { [weak self] in
        self?.view.bounds = newBounds
      },
      completion: { [weak self] _ in
        self?.updateExpandContractButtonTransform()
    })
  }

  private func updateExpandContractButtonTransform() {
    if selectedDrawing === inputDrawing {
      expandContractButton.transform = CGAffineTransform.identity
    } else {
      expandContractButton.transform = CGAffineTransform(rotationAngle: .pi)
    }
  }
}

// MARK: - OutlineView
@IBDesignable public class OutlineView: UIView {

  // MARK: - Properties
  @IBInspectable public var borderColor = UIColor.red {
    didSet {
      layer.borderColor = borderColor.cgColor
    }
  }
  @IBInspectable public var borderWidth = CGFloat(2.0) {
    didSet {
      layer.borderWidth = borderWidth
    }
  }

  // MARK: - Object Lifecycle
  public override init(frame: CGRect) {
    super.init(frame: frame)
    configureLayerProperties()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configureLayerProperties()
  }

  public override func prepareForInterfaceBuilder() {
    configureLayerProperties()
  }

  private func configureLayerProperties() {
    layer.borderColor = borderColor.cgColor
    layer.borderWidth = borderWidth
  }
}
