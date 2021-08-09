import UIKit

class CommentTableViewCell: UITableViewCell, Identifying {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var writeTime: UILabel!
    @IBOutlet weak var commentOption: UIButton!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var emojiCollectionView: UICollectionView!
    @IBOutlet weak var emojiCollectionViewHeight: NSLayoutConstraint!
    
    private let imageViewDefaultHeight: CGFloat = 160
    
    var emojis: [String]? {
        didSet {
            self.emojiCollectionView.reloadData()
            let height = self.emojiCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.emojiCollectionViewHeight.constant = height
        }
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.emojiCollectionView.dataSource = self
        self.emojiCollectionView.delegate = self
        
        let flowLayout = CollectionViewLeftAlignFlowLayout()
        self.emojiCollectionView.collectionViewLayout = flowLayout
        self.emojiCollectionView.register(EmojiCollectionViewCell.nib, forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
    }
    
    func setHeightZero() {
        self.imageViewHeight.constant = 0
    }
    
    func setDefaultHeight() {
        self.imageViewHeight.constant = self.imageViewDefaultHeight
    }
    
}

extension CommentTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.emojis?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as? EmojiCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.emojiLabel.text = self.emojis?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return EmojiCollectionViewCell.emojiSize
    }
    
}
