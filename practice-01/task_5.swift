import Foundation

struct LibraryBook: Equatable {
    let id: UUID
    let title: String
}

final class LibraryMember {
    // Неизменяемые id и name (объявлены через let)
    let id: UUID
    let name: String
    
    // Доступно для чтения извне, но менять массив напрямую нельзя
    private(set) var borrowedBooks: [LibraryBook] = []

    // Вычисляемое свойство для количества взятых книг
    var borrowedCount: Int {
        return borrowedBooks.count
    }

    // Инициализатор со значением id по умолчанию
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }

    // Метод выдачи книги читателю
    @discardableResult
    func borrow(_ book: LibraryBook) -> Bool {
        // Лимит: не более 5 книг одновременно
        guard borrowedBooks.count < 5 else {
            return false
        }
        
        // Проверка: одна и та же книга не должна выдаваться повторно
        if hasBorrowed(bookID: book.id) {
            return false
        }
        
        borrowedBooks.append(book)
        return true
    }

    // Метод возврата книги по ее ID
    @discardableResult
    func returnBook(id: UUID) -> Bool {
        // Ищем индекс книги в массиве по её идентификатору
        guard let index = borrowedBooks.firstIndex(where: { $0.id == id }) else {
            return false // Книга не найдена у этого читателя
        }
        
        borrowedBooks.remove(at: index)
        return true
    }

    // Проверка, находится ли книга у читателя
    func hasBorrowed(bookID: UUID) -> Bool {
        return borrowedBooks.contains { $0.id == bookID }
    }

    // Формирование текстовой сводки
    func summary() -> String {
        if borrowedBooks.isEmpty {
            return "Читатель \(name) не взял ни одной книги."
        }
        
        let bookTitles = borrowedBooks.map { "«\($0.title)»" }.joined(separator: ", ")
        return "Читатель \(name) взял книги: \(bookTitles)."
    }
}

// --- Минимальные и расширенные проверки ---

let member = LibraryMember(name: "Амина")
let sameMember = member
let book = LibraryBook(id: UUID(), title: "Swift Programming")

// Проверка ссылочной семантики
assert(member === sameMember) // Обе переменные указывают на один экземпляр
assert(member.borrow(book) == true)
assert(sameMember.borrowedCount == 1) // Изменение видно через обе переменные

// Проверка лимита книг (максимум 5)
for i in 1...4 {
    let extraBook = LibraryBook(id: UUID(), title: "Книга \(i)")
    assert(member.borrow(extraBook) == true)
}
assert(member.borrowedCount == 5)

let sixthBook = LibraryBook(id: UUID(), title: "Шестая книга")
assert(member.borrow(sixthBook) == false) // Лимит превышен, вернет false

// Проверка возврата книги
assert(member.returnBook(id: book.id) == true)
assert(member.borrowedCount == 4)
assert(member.hasBorrowed(bookID: book.id) == false)

// Проверка дополнительной части (разные объекты с одинаковыми данными)
let anotherMember = LibraryMember(name: "Амина")
assert(member !== anotherMember) // Разные объекты в куче

print("Все проверки успешно пройдены!")
