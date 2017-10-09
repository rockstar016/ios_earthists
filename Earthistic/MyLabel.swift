




import UIKit
extension UILabel {
    func AdjustFontSize(_ rate:CGFloat) {
        
        //self.titleLabel!.font = 120;
        self.font = UIFont(name: (self.font?.fontName)!, size: 12 * Constants.getRateHeight())
        print(self.font.pointSize)
    }
}

class MyLabel:UILabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.AdjustFontSize(Constants.getRateHeight())
        print(String(describing: Constants.getRateHeight()))
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.AdjustFontSize(Constants.getRateHeight())
        print(String(describing: Constants.getRateHeight()))
    }
    
}
