//
//  PostViewModel.swift
//  TCITTestUIKIT
//
//  Created by Luis Barrios on 28/7/23.
//

import Foundation
import RxSwift

func getMockListViewModel() -> PostViewModel{
        
    return PostViewModel(postManager: getFilledMockPostManager())
}


protocol PostDeleter{
    func deletePost(id:Int)
}

protocol PostLoader{
    func loadPosts()
}

protocol PostFilterer:PostLoader{
    func getPostsWith(name:String)
}

protocol PostAdder{
    func addPost(name:String,description:String)

}




class PostViewModel:PostDeleter,PostFilterer,PostAdder{
    
    
    
    private var postManager:PostManager
    public let posts = PublishSubject<[Post]>()
    private let disposeBag = DisposeBag()
    private var filter:String?
    
    
    init(postManager: PostManager) {
        self.postManager = postManager
    }
    
    func loadPosts(){

        filter = nil
        postManager.getPosts()
            .subscribe(
                onNext: {[weak self] posts in
                    self?.posts.onNext(posts)
                }
            ).disposed(by: disposeBag)

    }
    func addPost(name:String,description:String){
        postManager.addPost(name: name, description: description)
            .subscribe(
                onNext: {[weak self] posts in
                    if let filter = self?.filter, !filter.isEmpty {
                        self?.getPostsWith(name: filter)
                    }else{
                        self?.posts.onNext(posts)
                    }
                }
            ).disposed(by: disposeBag)
    }


    func deletePost(id:Int){

        postManager.deletePost(id: id)
            .subscribe(
            onNext: {[weak self] posts in
                if let filter = self?.filter, !filter.isEmpty {
                    self?.getPostsWith(name: filter)
                    
                }else{
                    self?.posts.onNext(posts)
                }
            }
        ).disposed(by: disposeBag)


    }

    func getPostsWith(name:String){

        filter = name
        postManager.getPostsWith(name: name)
            .subscribe(
            onNext: {[weak self] posts in
                self?.posts.onNext(posts)
            }
        ).disposed(by: disposeBag)

    }

    
    
    
    
    
}
