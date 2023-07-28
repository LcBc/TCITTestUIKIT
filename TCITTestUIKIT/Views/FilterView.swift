//
//  FilterView.swift
//  TCITTestUIKIT
//
//  Created by Luis Barrios on 28/7/23.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa


public class FilterView : UIView {
    
   private let filterTxtField:UITextField = {
        let txtField = UITextField()
        txtField.backgroundColor = UIColor(Color.gray.opacity(0.1))
        txtField.placeholder = "Name"
        txtField.borderStyle = .roundedRect
        txtField.translatesAutoresizingMaskIntoConstraints = false
        return txtField
    }()
    
    var postFilterManager: PostFilterer?{
        didSet{
            setupBindings()
        }
    }
    private let disposeBag = DisposeBag()
    
    
  private let filterButton:UIButton = {
        let btn = UIButton(type:.system)
        btn.setTitle("Clear", for: .normal)
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override init(frame: CGRect){
      super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(filterTxtField)
        self.addSubview(filterButton)
        self.backgroundColor = .white
        setupConstraints()

    }
    
    func setupConstraints(){
        filterTxtField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        filterTxtField.leftAnchor.constraint(equalTo:self.leftAnchor, constant:20).isActive = true
        filterTxtField.rightAnchor.constraint(equalTo:filterButton.leftAnchor, constant:-20).isActive = true
        filterButton.rightAnchor.constraint(equalTo:self.rightAnchor, constant:-20).isActive = true
        filterButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBindings(){
        
        filterButton
            .rx
            .tap
            .bind{ [weak self] in
            guard let `self` = self  else {return}
                self.filterTxtField.text = ""
                self.postFilterManager?.loadPosts()
                
        }.disposed(by: disposeBag)
        
        filterTxtField
            .rx
            .text
            .orEmpty
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
                   .subscribe(onNext: { [unowned self] (text) in
                     //  self.label.text = text
                       if !text.isEmpty {
                           self.postFilterManager?.getPostsWith(name: text)
                       }else{
                           self.postFilterManager?.loadPosts()
                       }
                       
                       print("Yo")
                   }).disposed(by: disposeBag)

        
    }
    
    
}

