//
//  Todo.swift
//  FirebaseTodo
//
//  Created by Elaine Chen on 2024-11-03.
//

import Foundation
import FirebaseFirestore

struct Todo: Identifiable, Codable{
    @DocumentID var id: String? // optional, we dont do this, firesbase do this for us
    let title: String
    let isDone: Bool
}
