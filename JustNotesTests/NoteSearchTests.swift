import Testing
@testable import JustNotes

struct NoteSearchTests {
    let note = Note(title: "Shopping list", text: "Milk and Eggs")

    @Test func blankQueryMatchesEverything() {
        #expect(note.matches(""))
        #expect(note.matches("   "))
    }

    @Test func matchesTitleIgnoringCase() {
        #expect(note.matches("SHOPPING"))
    }

    @Test func matchesTextIgnoringCase() {
        #expect(note.matches("eggs"))
    }

    @Test func ignoresSurroundingWhitespace() {
        #expect(note.matches("  milk  "))
    }

    @Test func noMatch() {
        #expect(!note.matches("coffee"))
    }
}
