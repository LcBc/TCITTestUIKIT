//
//  PostManager.swift
//  TCITPost
//
//  Created by Luis Barrios on 26/7/23.
//

import Foundation
import RxSwift

protocol PostManager {
    
    func addPost(name:String,description:String) -> Observable<[Post]>
    func deletePost(id:Int) -> Observable<[Post]>
    func getPostsWith(name: String) -> Observable<[Post]>
    func getPosts() -> Observable<[Post]>
    
    
}



