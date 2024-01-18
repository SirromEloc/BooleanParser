import Foundation

enum Lexeme {
    enum LexemeError: Error {
        case failedToFindLexeme(inLine: String)
        
    }

    case variable(name: String)
    case operators(value: Int)

    static func nextLexeme(from line: Substring) throws -> [Lexeme] {
        var Lexemes : [Lexeme] = []
        if let match = try /\s*[a-zA-Z]*\s/.firstMatch(in: line) {
            Lexemes.append(Lexeme.variable(name: String(match.0)))
            //need to get range from match substring
            return Lexemes + self.nextLexeme(from: Substring)
        } else if let match = try /\s*=\s/.prefixMatch(in: line) {
            print("Found assignment operator")
        } else {
            throw LexemeError.failedToFindLexeme(inLine: String(line))
        }
    }
    
}

func main() {
    do {
        let lexemes: [Lexeme] = try Lexeme.nextLexeme(from: " var x = 123 var ")
        print(lexemes)
    } catch {
        print("Failed because \(error).")
    }
}

main()
