//
//  ViewController.swift
//  TCITTestUIKIT
//
//  Created by Luis Barrios on 28/7/23.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa

class PostViewController: UIViewController {
    
    //MARK: Components
    private let filterView =  {
        let view = FilterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    private  let postsTableView =  {
        let table =  UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let addView = {
        let view = AddView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var createBottomConstraint: NSLayoutConstraint!
    
    var viewModel: PostViewModel = getMockListViewModel()
    
    
    
    convenience init(viewModel: PostViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    
    
    //Bindings
    private var posts = PublishSubject<[Post]>()
    private var isAdding = false {
        didSet{
            
            print(isAdding)
            
        }
    }
    private let disposeBag = DisposeBag()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(filterView)
        view.addSubview(postsTableView)
        view.addSubview(addView)
        view.backgroundColor = .white
        postsTableView.register(PostCellViewTableViewCell.self, forCellReuseIdentifier: "postCell")
        setupFilterConstraints()
        postsTableView.delegate = self
        filterView.postFilterManager = self.viewModel
        addView.postAdditionManager = self.viewModel
        setupBindings()
        postsTableView.allowsSelection = false
        subscribeToKeyboardNotifications()
    }
    
    
    
    
}



//MARK: KeyboardStuff
extension PostViewController {
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(
                   self,
                   selector: #selector(self.keyboardWillShow),
                   name: UIResponder.keyboardWillShowNotification,
                   object: nil)

               NotificationCenter.default.addObserver(
                   self,
                   selector: #selector(self.keyboardWillHide),
                   name: UIResponder.keyboardWillHideNotification,
                   object: nil)
    }
    
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if isAdding, let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
     }
     
     @objc func keyboardWillHide(_ notification: NSNotification) {
         if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
         isAdding = false
     }
    
  
    
}


extension PostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}


//MARK: Bindings

extension PostViewController {
    
    func setupBindings(){
        
        viewModel
            .posts
            .observe(on: MainScheduler.instance)
            .bind(to: posts)
            .disposed(by: disposeBag)
        
        
        addView.isEditing.bind{[weak self] value in
            self?.isAdding = value
        }.disposed(by: disposeBag)
        
        
        
        posts.bind(to: postsTableView.rx.items(cellIdentifier: "postCell",cellType: PostCellViewTableViewCell.self)){[weak self]
            (row,post,cell) in
            guard let `self` = self else {return}
            cell.post = post
            cell.postDeletionManager = self.viewModel
            
        }.disposed(by: disposeBag)
        
        
        viewModel.loadPosts()
        
        
    }
    
    
    
}






//MARK: Constraints
extension PostViewController {
    
    
    func setupFilterConstraints(){
        let guide = view.safeAreaLayoutGuide
        //Filter constraints
        filterView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        filterView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        filterView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        filterView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0).isActive = true
        
        //table constraints
        postsTableView.topAnchor.constraint(equalToSystemSpacingBelow: filterView.bottomAnchor, multiplier: 1.0).isActive = true
        postsTableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        postsTableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        postsTableView.bottomAnchor.constraint(equalTo:addView.topAnchor).isActive = true
        
        //add section constraints
        addView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        addView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        addView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        createBottomConstraint = addView.bottomAnchor.constraint(equalTo:view.bottomAnchor)
        createBottomConstraint.isActive = true
      
    }
    
    
    
    
    
}
