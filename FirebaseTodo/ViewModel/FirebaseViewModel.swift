//
//  FirebaseViewModel.swift
//  FirebaseTodo
//
//  Created by Elaine Chen on 2024-11-03.
//

import Foundation
import FirebaseFirestore
import Combine // there is a 2 way communication b/w client and server (websockets)

class FirebaseViewModel: ObservableObject {
    // Singleton instance
    static let shared = FirebaseViewModel()
    
    // Initialize the Firestore database
    private let db = Firestore.firestore()
    
    @Published var todos: [Todo] = []
    
    // Cancellables set to manage subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        fetchTodos()
    }
    
    // Fetch the list of todos from Firestore
    func fetchTodos() {
        db.collection("todos").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching todos: \(error)")
                return
            }
            
            // Mapping documents to Todo objects
            self.todos = querySnapshot?.documents.compactMap { document in
                try? document.data(as: Todo.self)
            } ?? []
        }
    }
    
    // add a todo
    func addTodo(title: String){
        let newTodo = Todo(title: title, isDone: false)
        do{
            try db.collection("todos").addDocument(from: newTodo)
        }catch{
            print("Error: \(error)")
        }
    }
    
    
    // update the status of the todo
    func updateTodoStatus(todo: Todo, isDone: Bool){
        guard let todoId = todo.id else{ return }
        db.collection("todos").document(todoId).updateData(["isDone" : isDone])
    }
    
    // delete the todo
    func deleteTodo(todo: Todo){
        guard let todoId = todo.id else{ return }
        db.collection("todos").document(todoId).delete{
            error in
            if let error = error{
                print("Error: \(error)")
            }
        }
    }
    
    
    
    
    
}
