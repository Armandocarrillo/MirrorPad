
import UIKit

public class ViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet public var drawViewContainer: UIView!
  @IBOutlet public var inputDrawView: DrawView!
  @IBOutlet public var mirrorDrawViews: [DrawView]!

  // MARK: - Actions
  @IBAction public func animatePressed(_ sender: Any) {
    mirrorDrawViews.forEach { $0.copyLines(from: inputDrawView)   }
    mirrorDrawViews.forEach { $0.animate() }
    inputDrawView.animate()
  }

  @IBAction public func clearPressed(_ sender: Any) {
    inputDrawView.clear()
    mirrorDrawViews.forEach { $0.clear() }
  }

  @IBAction public func sharePressed(_ sender: Any) {

  }
}
