//
//  MockPostData.swift
//  TCITPost
//
//  Created by Luis Barrios on 27/7/23.
//

import Foundation




func getMockPostData()-> [Post]{
    
    let jsonData = Data(mockJSON.utf8)
    let decoder = JSONDecoder()

    do {
        let data = try decoder.decode(MockPostRemoteResponse.self, from: jsonData)
        return data.data
    } catch {
        print(error.localizedDescription)
        return []
    }
    
    
    
}


struct MockPostRemoteResponse: Codable {
    let data:[Post]
}


var mockJSON = """
{"data":[
  {
    "id": 1,
    "name": "Test",
    "description": "Test Data"
  }, {
    "id": 2,
    "name": "Different",
    "description": "Test Data From Other User"
  },{
    "id": 3,
    "name": "Acme",
    "description": "More Test Data"
  }, {
    "id": 4,
    "name": "Test3",
    "description": "Test Data of OTHER OTHER USER"
  }
]
}
"""
