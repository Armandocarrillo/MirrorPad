//as a generic class accepts any protocolType
public class MulticastDelegate<ProtocolType> {
  
    //as an inner class, to wrap delegate objects as weak property
  // MARK: - DelegateWrapper
  private class DelegateWrapper {
    //weak objects have to be AnyObject
    weak var delegate: AnyObject?
    
    init(_ delegate: AnyObject) {
      self.delegate = delegate
    }
  }
  
  // MARK: - Instance Properties
//
  private var delegateWrappers: [DelegateWrapper]
  
  public var delegates: [ProtocolType] {
    delegateWrappers = delegateWrappers
      .filter { $0.delegate != nil }
    return delegateWrappers.map
      { $0.delegate! } as! [ProtocolType]
  }
  
  // MARK: - Object Lifecycle
  public init(delegates: [ProtocolType] = []) {
    delegateWrappers = delegates.map {
      DelegateWrapper($0 as AnyObject)
    }
  }
  
  // MARK: - Delegate Management
  public func addDelegate(_ delegate: ProtocolType) {
    let wrapper = DelegateWrapper(delegate as AnyObject)
    delegateWrappers.append(wrapper)
  }
  
  public func removeDelegate(_ delegate: ProtocolType) {
    guard let index = delegateWrappers.index(where: {
      $0.delegate === (delegate as AnyObject) //if found you remove the delegate wrapper
    }) else {
      return
    }
    delegateWrappers.remove(at: index)
  }
  //invoke all delegates
  public func invokeDelegates(_ closure: (ProtocolType) -> ()) {
    delegates.forEach { closure($0) }
  }
}
