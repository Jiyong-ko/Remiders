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
    @State private var isShowingTextField: Bool = false // "새로운 할일" 텍스트필드 숨김 여부
    @FocusState private var isFocused: Bool // 텍스트필드에 포커스(커서) 주기
    @State private var isNewTodoCompleted: Bool = false // "새로운 할일" 텍스트필드에 완료 토글 추가를 위한 새로운 변수
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button(action: addTodoItem) {
                    Label("완료", systemImage: "plus.circle.fill")
                }
            }
            List {
                ForEach(todos) { todo in
                    TodoItemRowView(todo: todo)
                }
                .onDelete(perform: deleteTodoItems)
                if isShowingTextField {
                    HStack {
                        Button(action: {
                            withAnimation {
                                // 새로운 Todo는 아직 생성되지 않았으므로 별도의 상태 변수가 필요
                                isNewTodoCompleted.toggle()
                            }
                        }) {
                            Image(systemName: isNewTodoCompleted ? "checkmark.circle.fill" : "circle")
                        }
                        TextField("새로운 할일", text: $newTodoTitle)
                        // 포커스(커서) 주기
                            .focused($isFocused)
                            .onAppear {
                                isFocused = true
                            }
                        // 엔터 버튼에 액션 호출
                            .onSubmit {
                                addTodoItem()
                            }
                    }
                }
                // 빈공간(개발 중에만 임시로 색깔 부여, 끝나면 opacity 0.0으로)
                Rectangle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(height: 700)
                    .onTapGesture {
                        if isShowingTextField {
                            addTodoItem()
                        } else {
                            isShowingTextField = true
                        }
                    }
                
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
        .navigationTitle("미리알림") // 타이틀 추가
    }
    
    
    private func addTodoItem() {
        // 빈 문자열, 공백 처리
        guard !newTodoTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            isShowingTextField = false // "새로운 할일"텍스트필드 숨기기
            isNewTodoCompleted = false // 텍스트필드 완료토글 초기화
            return
        }
        // addTodoItem 액션
        withAnimation {
            let newTodoItem = TodoItem(
                title: newTodoTitle,
                timestamp: Date(),
                isCompleted: isNewTodoCompleted
            )
            modelContext.insert(newTodoItem)
            newTodoTitle = ""
            isShowingTextField = false // "새로운 할일" 텍스트필드 숨기기
            isNewTodoCompleted = false // 텍스트필드 완료토글 초기화
            
            // 저장 시도
            do {
                try modelContext.save()
                print("아이템이 성공적으로 저장되었습니다: \(newTodoItem.title)")
            } catch {
                print("저장 실패: \(error)")
            }
        }
    }
    
    private func deleteTodoItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(todos[index])
                print("아이템이 삭제되었습니다.")
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


struct TodoItemRowView: View {
    @Environment(\.modelContext) private var modelContext
    let todo: TodoItem  // todos -> todo로 변경
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    todo.isCompleted.toggle()
                }
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
            }
            VStack(alignment: .leading) {
                Text(todo.title)
                    .strikethrough(todo.isCompleted) // 취소선 추가
                Text(todo.timestamp, format: .dateTime)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TodoItem.self, inMemory: false)
}
