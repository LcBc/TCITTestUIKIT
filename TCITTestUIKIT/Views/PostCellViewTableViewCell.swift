//
//  PostCellViewTableViewCell.swift
//  TCITTestUIKIT
//
//  Created by Luis Barrios on 28/7/23.
//

import UIKit
import RxSwift
import RxCocoa

class PostCellViewTableViewCell: UITableViewCell {
    
    var post:Post? {
        didSet{
            
             guard let postInfo = post else {return}
             nameLabel.text = postInfo.name
             descriptionLabel.text = postInfo.description
            
        }
        
        
    }
    
    var postDeletionManager: PostDeleter?{
        didSet{
            setupBindings()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    
  private let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        return view
    }()
    
    private  let nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor =  .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor =  .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private  let deleteButton:UIButton = {
        let btn = UIButton(type:.system)
        btn.setTitle("Delete", for: .normal)
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        contentView.addSubview(containerView)
        contentView.addSubview(deleteButton)
        contentView.isUserInteractionEnabled = true
        setupConstrains()
        setupBindings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setupConstrains(){
        
        deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        deleteButton.rightAnchor.constraint(equalTo:self.rightAnchor, constant:-20).isActive = true
        containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: deleteButton.trailingAnchor, constant:-10).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant:10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant:-10).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant:10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant:-10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
      
//        nameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true nameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true nameLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
    }
    
    func setupBindings(){
        
        deleteButton.rx.tap.bind{ [weak self] in            
            guard let `self` = self, let post = post  else {return}
            self.postDeletionManager?.deletePost(id: post.id)
        }.disposed(by: disposeBag)
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
