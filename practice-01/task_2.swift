final class Counter {
    // Состояние ТИПА (static): общее для всех объектов этого класса
    private(set) static var createdCount = 0
    
    // Состояние ЭКЗЕМПЛЯРА: уникальное для каждого конкретного объекта
    private(set) var value = 0

    // Инициализатор увеличивает счетчик созданных экземпляров типа
    init() {
        Counter.createdCount += 1
    }

    // Увеличивает значение текущего объекта на 1
    func increment() {
        self.value += 1
    }

    // Увеличивает значение текущего объекта на положительное число
    func increment(by amount: Int) -> Bool {
        // Аргумент должен быть строго больше нуля
        guard amount > 0 else {
            return false
        }
        self.value += amount
        return true
    }

    // Сбрасывает значение конкретного счетчика к нулю
    func reset() {
        self.value = 0
    }

    // Статический метод возвращает общее количество созданных объектов
    static func howManyCreated() -> Int {
        return createdCount
    }
}

// --- Проверки ---

// 1. Проверяем состояние типа при создании объектов
let firstCounter = Counter()
let secondCounter = Counter()

// 2. Проверяем независимость состояния экземпляров
firstCounter.increment()
assert(firstCounter.value == 1)
assert(secondCounter.value == 0) // secondCounter остался равен 0
assert(Counter.howManyCreated() == 2) // Всего создано 2 объекта

// 3. Дополнительные проверки для increment(by:) и reset()
assert(firstCounter.increment(by: 5) == true)
assert(firstCounter.value == 6)

assert(firstCounter.increment(by: -3) == false) // Некорректный аргумент
assert(firstCounter.value == 6) // Значение не изменилось

firstCounter.reset()
assert(firstCounter.value == 0) // Счетчик сброшен
assert(Counter.howManyCreated() == 2) // Общее количество созданных объектов не изменилось

print("Все проверки успешно пройдены!")
