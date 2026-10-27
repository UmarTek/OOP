import Foundation

// 1. Структура EmailAddress с валидацией
struct EmailAddress: Equatable {
    let value: String

    init?(_ value: String) {
        // Проверяем, что строка не пустая и содержит ровно один символ '@'
        let components = value.components(separatedBy: "@")
        guard components.count == 2 else { return nil }
        
        // Проверяем, что до и после '@' есть символы (компоненты не пустые)
        let localPart = components[0]
        let domainPart = components[1]
        guard !localPart.isEmpty && !domainPart.isEmpty else { return nil }
        
        self.value = value
    }
}

// 2. Структура StudentRecord
struct StudentRecord: Equatable {
    let id: Int
    let name: String
    let email: EmailAddress
    var grades: [Int] // массив оценок

    // Вычисляемое свойство для среднего балла
    var averageGrade: Double {
        guard !grades.isEmpty else { return 0.0 }
        let sum = grades.reduce(0, +)
        return Double(sum) / Double(grades.count)
    }

    // Возвращает изменённую копию с новой оценкой
    func addingGrade(_ grade: Int) -> StudentRecord? {
        // Проверяем диапазон оценки от 1 до 5
        guard (1...5).contains(grade) else { return nil }
        
        // Создаем копию текущей записи, изменяем массив оценок и возвращаем её
        var updatedRecord = self
        updatedRecord.grades.append(grade)
        return updatedRecord
    }
}

// --- ПРОВЕРКА РАБОТЫ ---

// Проверка EmailAddress
assert(EmailAddress("user@example.com") != nil, "Валидный email не создался")
assert(EmailAddress("invalid-email") == nil, "Email без @ создался")
assert(EmailAddress("@example.com") == nil, "Email без имени создался")
assert(EmailAddress("user@") == nil, "Email без домена создался")
assert(EmailAddress("user@domain@com") == nil, "Email с двумя @ создался")

// Проверка StudentRecord
if let email = EmailAddress("student@university.edu") {
    let initialRecord = StudentRecord(id: 1, name: "Иван Иванов", email: email, grades: [])
    
    // Проверка среднего балла для пустого списка
    assert(initialRecord.averageGrade == 0.0, "Средний балл пустого списка должен быть 0")
    
    // Добавление корректных оценок
    guard let recordWithFive = initialRecord.addingGrade(5),
          let finalRecord = recordWithFive.addingGrade(4) else {
        fatalError("Не удалось добавить валидные оценки")
    }
    
    // Проверка, что исходная запись не изменилась (иммутабельность)
    assert(initialRecord.grades.isEmpty, "Исходная запись изменилась!")
    
    // Проверка правильности добавления оценок в копию (массив добавлен)
    assert(finalRecord.grades == [5, 4], "Оценки в новой копии не совпадают")
    assert(finalRecord.averageGrade == 4.5, "Средний балл рассчитан неверно")
    
    // Проверка валидации оценок (вне диапазона 1...5)
    assert(finalRecord.addingGrade(6) == nil, "Добавилась оценка 6")
    assert(finalRecord.addingGrade(0) == nil, "Добавилась оценка 0")
    
    print("Все проверки успешно пройдены!")
}