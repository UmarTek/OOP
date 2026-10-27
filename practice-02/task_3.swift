import Foundation

// Задание 3. Ссылочный тип Playlist
final class Playlist {
    let id: Int
    var name: String
    private(set) var tracks: [String] = []

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

    @discardableResult
    func add(_ track: String) -> Bool {
        // Пустые названия и дубликаты добавлять нельзя
        guard !track.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        guard !tracks.contains(track) else { return false }
        
        tracks.append(track)
        return true
    }

    @discardableResult
    func remove(_ track: String) -> Bool {
        guard let index = tracks.firstIndex(of: track) else { return false }
        tracks.remove(at: index)
        return true
    }
}

// --- Проверки (assert) ---
let playlist = Playlist(id: 1, name: "Учёба")
let sharedPlaylist = playlist

// Демонстрация ссылочной семантики
playlist.add("Swift Basics")
assert(sharedPlaylist.tracks == ["Swift Basics"]) // Изменения видны через обе ссылки
assert(playlist === sharedPlaylist)               // Ссылаются на один и тот же объект в памяти

// Проверка ограничений (дубликаты и пустые строки)
assert(playlist.add("Swift Basics") == false)
assert(playlist.add("   ") == false)

// Проверка уникальности экземпляров с одинаковыми данными
let anotherPlaylist = Playlist(id: 1, name: "Учёба")
assert(playlist !== anotherPlaylist) // Разные объекты, несмотря на одинаковые id и name

print("Task 3 completed successfully.")

/*
 Объяснение выбора class:
 Плейлист должен обладать уникальной идентичностью (identity) и разделяемым состоянием (shared state). 
 Если один пользователь добавляет трек в плейлист, все остальные пользователи или компоненты программы, 
 использующие этот плейлист, должны мгновенно увидеть изменения.

 Ответ на вопрос:
 Одинаковые id и name не делают два экземпляра тождественными, потому что оператор `!==` проверяет 
 идентичность ссылок (указывают ли они на одну и ту же область памяти). Два разных экземпляра класса 
 занимают разные адреса в куче (heap), являясь полностью независимыми объектами, у каждого из которых 
 своя собственная жизнь и свое состояние.
*/
