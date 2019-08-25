import Foundation

public class GradientView: UIView {
    override public class var layerClass: AnyClass {
        get { return CAGradientLayer.self }
    }
    
    public var colors: [UIColor] = [.clear, .clear] {
        didSet { updateView() }
    }

    public var horizontal: Bool = true {
        didSet { updateView() }
    }
    
    fileprivate func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = colors.map{ $0.cgColor }
        
        if horizontal {
            layer.startPoint = CGPoint(x: 0.0, y: 0.5)
            layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0.0)
            layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
    }
}
