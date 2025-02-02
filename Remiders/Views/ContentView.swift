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
    @State private var isShowingTextField: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Button(action: addTodoItem) {
                        Label("완료", systemImage: "plus.circle.fill")
                    }
                }
                List {
                    ForEach(todos) { todo in
                        Text(todo.title)
                    }
                    if isShowingTextField {
                        TextField("새로운 할일", text: $newTodoTitle)
                    }
                    Rectangle()
                }
                .background(
                    Color.blue
                )
                Button(action: {
                    isShowingTextField = true // "새로운 할일" 텍스트필드 보이기
                }) {
                    Label("새로운 미리 알림", systemImage: "plus.circle.fill")
                }
                
            }
        }
    }
    
    private func addTodoItem() {
        withAnimation {
            let newTodoItem = TodoItem(title: newTodoTitle, timestamp: Date())
            modelContext.insert(newTodoItem)
            newTodoTitle = ""
            isShowingTextField = false // "새로운 할일" 텍스트필드 숨기기
            
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
