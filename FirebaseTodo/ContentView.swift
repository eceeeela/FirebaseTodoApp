//
//  ContentView.swift
//  FirebaseTodo
//
//  Created by Elaine Chen on 2024-11-03.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var firebaseManager = FirebaseViewModel.shared
    @State private var newTodoTitle = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(firebaseManager.todos) {
                    todo in
                    HStack {
                        Text(todo.title)
                            .strikethrough(todo.isDone, color: .gray)
                        Spacer()
                        Toggle(isOn: Binding(get: {
                            todo.isDone
                        }, set: {
                            newValue in
                            firebaseManager.updateTodoStatus(todo: todo, isDone: newValue)
                        })){
                            EmptyView()
                        }
                        
                    }
                }
                .onDelete(perform: deleteTodo)
            }
            .onAppear{
                if firebaseManager.todos.isEmpty{
                    Task{
                        firebaseManager.fetchTodos()
                    }
                }
            }
            HStack{
                TextField("Enter new Todo", text: $newTodoTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action:{
                    if !newTodoTitle.isEmpty{
                        firebaseManager.addTodo(title: newTodoTitle)
                        newTodoTitle = ""
                    }
                }, label: {
                    Image(systemName: "plus")
                }).padding(.leading, 8)
            }.padding()
            
        }
    }
    
    private func deleteTodo(at offsets: IndexSet){
        offsets.forEach{
            index in
            let todo = firebaseManager.todos[index]
            firebaseManager.deleteTodo(todo: todo)
        }
    }
    
    
}

#Preview {
    ContentView()
}
