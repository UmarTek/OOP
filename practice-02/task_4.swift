import Foundation

// Задание 4. Найдите скрытое общее состояние

// Шаг 1. Предсказание (исходный код)
/*
 Предсказание значений ДО запуска:
 first.number = 1          (так как это значимый тип, изменение second.number его не трогает)
 second.number = 2         (прямое изменение переменной second)
 first.address.city = "Москва"  (так как Address — это класс, обе структуры хранят ссылку на ОДИН экземпляр)
 second.address.city = "Москва" (изменение свойства через одну ссылку меняет данные внутри общего объекта)
*/

final class AddressClass {
    var city: String
    init(city: String) { self.city = city }
}

struct OrderDraftWithClass {
    var number: Int
    var address: AddressClass
}

// Тест для проверки прогноза
let addressCl = AddressClass(city: "Нальчик")
var firstCl = OrderDraftWithClass(number: 1, address: addressCl)
var secondCl = firstCl
secondCl.number = 2
secondCl.address.city = "Москва"

// Шаг 2. Подтверждение прогноза через assert
assert(firstCl.number == 1)
assert(secondCl.number == 2)
assert(firstCl.address.city == "Москва")  // Скрытое общее состояние сработало!
assert(secondCl.address.city == "Москва")


// Шаг 3. Переделка Address в структуру для полной независимости
struct AddressStruct: Equatable {
    var city: String
}

struct OrderDraftFixed: Equatable {
    var number: Int
    var address: AddressStruct
}

// Тест, подтверждающий исправление
let addressStr = AddressStruct(city: "Нальчик")
var firstFixed = OrderDraftFixed(number: 1, address: addressStr)
var secondFixed = firstFixed

secondFixed.number = 2
secondFixed.address.city = "Москва"

// Теперь черновики полностью независимы
assert(firstFixed.number == 1)
assert(secondFixed.number == 2)
assert(firstFixed.address.city == "Нальчик") // Город в первом черновике НЕ изменился!
assert(secondFixed.address.city == "Москва")

print("Task 4 completed successfully.")

/*
 Объяснение:
 Одной надписи struct у OrderDraft было недостаточно, потому что структура производила "поверхностное копирование" 
 (shallow copy). Значения базовых типов (Int) скопировались по-настоящему, но свойство `address` хранило лишь ссылку 
 на объект класса Address. При копировании структуры скопировался сам указатель (адрес в памяти), в результате чего 
 оба независимых черновика стали ссылаться на один и тот же объект в куче.
*/
