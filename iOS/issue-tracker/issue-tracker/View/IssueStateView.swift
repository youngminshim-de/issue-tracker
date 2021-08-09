import UIKit

class IssueStateView: UIView {
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateImageView: UIImageView!
    
    private let skyBlue = UIColor(red: 0.782, green: 0.922, blue: 1, alpha: 1)
    private let blue = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
    private let lightPurple = UIColor(red: 0.799, green: 0.831, blue: 1, alpha: 1)
    private let purple = UIColor(red: 0, green: 0.145, blue: 0.904, alpha: 1)
    private let openImage = UIImage(systemName: "exclamationmark.circle")
    private let closeImage = UIImage(systemName: "archivebox")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
    }
    
    private func setColor(isOpen: Bool) {
        if isOpen {
            self.backgroundColor = skyBlue
            self.layer.borderColor = blue.cgColor
            self.stateImageView.image = openImage
            self.stateImageView.tintColor = blue
            self.stateLabel.textColor = blue
        } else {
            self.backgroundColor = lightPurple
            self.layer.borderColor = purple.cgColor
            self.stateImageView.image = closeImage
            self.stateImageView.tintColor  = purple
            self.stateLabel.textColor = purple
        }
    }
    
    func configure(text: String, isOpen: Bool) {
        self.stateLabel.text = text
        self.setColor(isOpen: isOpen)
    }
    
}
