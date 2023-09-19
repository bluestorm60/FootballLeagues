//
//  CommonLeagueView.swift
//  Football Leagues
//
//  Created by Ahmed Shafik on 15/09/2023.
//

import UIKit

class CommonLeagueView: UIView {
    
    @IBOutlet private weak var logoImgeView: UIImageView!
    
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var moreDetailsContainerStackView: UIStackView!
    @IBOutlet private weak var teamsNumberLbl: UILabel!
    @IBOutlet private weak var matchesNumberLbl: UILabel!
    @IBOutlet private weak var seasonNumberLbl: UILabel!

    var actionClicked: (()->Void)?
    
    var item: CommonLeagueModel? {
        didSet{
            guard let item = item else {return}
            configure(item: item)
        }
    }
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let contentView = fromNib() else {return}
        setupViewFromNib(contentView: contentView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let contentView = fromNib() else {return}
        setupViewFromNib(contentView: contentView)
        self.isUserInteractionEnabled = true
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    private func configure(item: CommonLeagueModel){
        nameLbl.text = item.name
        logoImgeView.load(with: item.logo)
        moreDetailsContainerStackView.isHidden = item.isDetailsHidden
        seasonNumberLbl.text = item.seasonsNumber
        matchesNumberLbl.text = item.matchesNumber
        teamsNumberLbl.text = item.teamsNumber
    }
    
    //MARK: - actions
    @IBAction private func openLeaguesAction(_ sender: Any) {
        actionClicked?()
    }
}

public extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}

public extension UIView {
    func setupViewFromNib(contentView: UIView) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    class func initFromNib<T: UIView>() -> T? {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as? T
    }
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(type(of: self).className, owner: self, options: nil)?.first as? T else {
            return nil
        }
        addSubview(contentView)
        return contentView
    }
}

extension UINib {
    static func loadNib<T: UITableViewCell>(classType: T.Type) -> T? {
        let nibName = String(describing: classType)
        guard let customCell = UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil).first as? T
        else { return UITableViewCell() as? T }
        return customCell
    }
}
