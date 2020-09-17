import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        self.firstIndex { currentElement in
            currentElement.id == matching.id
        }
    }
}
