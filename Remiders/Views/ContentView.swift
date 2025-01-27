//
//  ContentView.swift
//  Remiders
//
//  Created by Noel Mac on 1/22/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var todos: [TodoItem] // Todo 항목들 리스트
    @State private var newTodoTitle: String = "" // 새로운 Todo 항목
    @State private var showCompleted: Bool = false // 완료된 항목 표시 여부
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("새로운 할일", text: $newTodoTitle)
                    Button(action: addTodoItem) {
                        Label("완료", systemImage: "plus.circle.fill")
                    }
                }
                List {
                    ForEach(todos) { todo in
                        Text(todo.title)
                    }
                    TextField("새로운 할일", text: $newTodoTitle)
                    
                    
                }
                
            }
        }
    }
    
    private func addTodoItem() {
        withAnimation {
            let newTodoItem = TodoItem(title: newTodoTitle, timestamp: Date())
            modelContext.insert(newTodoItem)
            newTodoTitle = ""
            
            // 저장 시도
            do {
                try modelContext.save()
                print("아이템이 성공적으로 저장되었습니다: \(newTodoItem.title)")
            } catch {
                print("저장 실패: \(error)")
            }
        }
    }
    
}


struct TodoDetailView: View {
    let todos: TodoItem
    
    var body: some View {
        VStack {
            Text("TodoDetailView")
        }
    }
}
    


#Preview {
    ContentView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
