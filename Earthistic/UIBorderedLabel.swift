import UIKit

class UIBorderedLabel: UILabel {
    
    var topInset:       CGFloat = 10
    var rightInset:     CGFloat = 10
    var bottomInset:    CGFloat = 10
    var leftInset:      CGFloat = 10
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        self.setNeedsLayout()
        return super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}
