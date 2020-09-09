import UIKit

public class ShareFacade {
  //MARK: - Instance Properties
  
  public unowned var entireDrawing: UIView
  public unowned var inputDrawing: UIView
  public unowned var parentViewController: UIViewController
  
  private var imageRender = ImageRenderer()
  
  //MARK: - Object Lifecycle
  
  public init(entireDrawing: UIView,
              inputDrawing: UIView,
              parentViewController: UIViewController) {
    self.entireDrawing = entireDrawing
    self.inputDrawing = inputDrawing
    self.parentViewController = parentViewController
  }
  
  //MARK: - Facade Methods
  
  public func presentShareController(){
    
    let selectionViewController = DrawingSelectionViewController.createInstance(entireDrawing: entireDrawing, inputDrawing: inputDrawing, delegate: self)
    
    parentViewController.present(selectionViewController, animated: true)
    
    
  }
  
}

//MARK: - DrawingSelectionViewControllerDelegate

extension ShareFacade: DrawingSelectionViewControllerDelegate {
  //when user press cancel button
  public func drawingSelectionViewControllerDidCancel(_ viewController: DrawingSelectionViewController) {
    parentViewController.dismiss(animated: true)
  }
  //when user press share button
  public func drawingSelectionViewController(_ viewController: DrawingSelectionViewController, didSelectView view: UIView) {
    parentViewController.dismiss(animated: false)
    //create a image to give view
    let image = imageRender.convertViewToImage(view)
    
    let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
    parentViewController.present(activityViewController, animated: true)
  }
}
