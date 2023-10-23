import UIKit

extension UILabel {
    convenience init(title: String? = nil, textAligment: NSTextAlignment? = .center, titleColor: UIColor? = .black, font: UIFont? = .systemFont(ofSize: 15)) {
        self.init(frame: .zero)
        self.text = title
        self.textAlignment = textAlignment
        self.textColor = titleColor
        self.font = font
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
