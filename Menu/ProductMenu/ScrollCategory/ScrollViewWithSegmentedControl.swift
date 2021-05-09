import  UIKit

class ScrollViewWithSegmentControll: UIScrollView {
    var parameters = [String]()
    var callBackSegmentControl : ((_ parameter : (String)) -> ())?
    
    init(parentView: UIView, parameters : [String], selectedParameter: String) {
        super.init(frame: parentView.bounds)
        self.parameters = parameters
        self.settings()
        let segmentControl = UISegmentedControl.init(items: parameters)
        segmentControlSettings(segmentControl: segmentControl)
        if segmentControl.frame.width < self.frame.width{
            segmentControl.frame.size.width = self.frame.width
        }
        segmentControl.selectedSegmentIndex = parameters.firstIndex(of: selectedParameter) ?? 0
        self.contentSize = CGSize (width: segmentControl.frame.width, height: self.frame.height)
        self.addSubview(segmentControl)
        parentView.addSubview(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func settings(){
        
 //       self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        self.isScrollEnabled = true
        self.bounces = false
        self.showsHorizontalScrollIndicator = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentSize.height = self.frame.height
    }
    
    
    func segmentControlSettings(segmentControl : UISegmentedControl){
        segmentControl.layer.backgroundColor = UIColor.white.cgColor

        segmentControl.layer.shadowRadius = 2;
        segmentControl.layer.shadowOpacity = 0.1;
        
        segmentControl.setBackgroundImage(UIImage(color: .white), for: .normal, barMetrics: .default)
        segmentControl.setBackgroundImage(UIImage(color: .black.withAlphaComponent(0.1)), for: .selected, barMetrics: .default)
        segmentControl.frame.size.height = self.frame.height - 5

        segmentControl.apportionsSegmentWidthsByContent = true
        segmentControl.addTarget(self, action: #selector (segmentedControlValueChanged), for: .valueChanged)
    }
    
    //MARK: выполнить какое-нибудь действие, при нажатии на ячейку
    @objc func segmentedControlValueChanged(segmentControl: UISegmentedControl){

        let ind = segmentControl.selectedSegmentIndex
        if callBackSegmentControl != nil {
            callBackSegmentControl!(segmentControl.titleForSegment(at: ind)!)
        }
    }
}

public extension UIImage {
  public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    guard let cgImage = image?.cgImage else { return nil }
    self.init(cgImage: cgImage)
  }
}
