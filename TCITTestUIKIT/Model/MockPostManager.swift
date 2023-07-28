//
//  MockPostManager.swift
//  TCITPost
//
//  Created by Luis Barrios on 26/7/23.
//

import Foundation
import RxSwift



func getFilledMockPostManager()->MockPostManager {    
    return MockPostManager(posts: getMockPostData())
}


//This class mock a PostManager that actually fetch data from a source
class MockPostManager: PostManager {
    
    private var posts = [Post]()
    // we set this convenience init to preload data for tests or mocking
    init(posts: [Post] = [Post]()) {
        self.posts = posts
    }
    
    func addPost(name: String, description: String) -> RxSwift.Observable<[Post]> {
        
        let id = (posts.last?.id ?? 0) + 1
        posts.append(Post(id: id, name: name, description: description))
        
        return Observable.just(posts)
    }
    
    func deletePost(id: Int) -> RxSwift.Observable<[Post]> {
        
        posts.removeAll(where: {$0.id == id})
        return Observable.just(posts)
    }
    
    func getPostsWith(name: String) -> RxSwift.Observable<[Post]> {
        return Observable.just(posts.filter({$0.name.lowercased().contains(name.lowercased())}))
    }
    
    func getPosts() -> RxSwift.Observable<[Post]> {
        return Observable.just(posts)
    }
    
        
}


