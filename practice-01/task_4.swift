import Foundation

final class BankAccount {
    // Константа (let) гарантирует, что номер задается один раз и не может быть изменен
    let number: String
    // Чтение доступно отовсюду, модификация — только внутри класса
    private(set) var balance: Double

    // Вычисляемое свойство для маскирования номера счета
    var maskedNumber: String {
        // Берем последние 4 символа. Если номер короче 4 символов, берем его целиком.
        let suffix = String(number.suffix(4))
        return "****\(suffix)"
    }

    // Проваливаемый инициализатор (failable initializer)
    init?(number: String, initialBalance: Double = 0) {
        // Дополнительное условие: убираем пробелы по краям и внутри строки 
        // и проверяем, что она не стала пустой.
        let trimmedNumber = number.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedNumber.isEmpty, initialBalance >= 0 else {
            return nil
        }
        
        self.number = number
        self.balance = initialBalance
    }

    // Метод для пополнения счета
    @discardableResult
    func deposit(_ amount: Double) -> Bool {
        // Сумма пополнения должна быть строго больше нуля
        guard amount > 0 else {
            return false
        }
        self.balance += amount
        return true
    }

    // Метод для снятия средств
    @discardableResult
    func withdraw(_ amount: Double) -> Bool {
        // Сумма должна быть положительной и не превышать текущий баланс
        guard amount > 0, amount <= balance else {
            return false
        }
        self.balance -= amount
        return true
    }

    // Описание счета в текстовом формате
    func description() -> String {
        return "Счёт \(maskedNumber): \(balance)"
    }
}

// --- Минимальные и расширенные проверки ---

let account = BankAccount(number: "408178101234", initialBalance: 100)

assert(account?.deposit(50) == true)
assert(account?.withdraw(30) == true)
assert(account?.balance == 120)
assert(account?.withdraw(1_000) == false) // Попытка снять больше, чем есть
assert(account?.balance == 120)            // Баланс не изменился
assert(account?.maskedNumber == "****1234")
assert(account?.description() == "Счёт ****1234: 120.0")

// Проверка валидации инициализатора
assert(BankAccount(number: "", initialBalance: 0) == nil)     // Пустая строка -> nil
assert(BankAccount(number: "1234", initialBalance: -1) == nil) // Отрицательный баланс -> nil

// Проверка дополнительного условия (строка из пробелов)
assert(BankAccount(number: "   ", initialBalance: 100) == nil)  // Только пробелы -> nil
assert(BankAccount(number: "\n\t", initialBalance: 50) == nil)  // Переносы и табы -> nil

// Проверка ограничений на некорректные суммы в методах
assert(account?.deposit(-10) == false)  // Отрицательное пополнение
assert(account?.withdraw(-5) == false)   // Отрицательное снятие
assert(account?.balance == 120)          // Баланс железно защищен

print("Все проверки успешно пройдены!")
