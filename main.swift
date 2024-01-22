import Foundation

enum Lexeme {
    enum LexemeError: Error {
        case failedToFindLexeme(inLine: String)
        case inconsistentSpacingForOperator(operator: String, inLine: String)
        
    }

    case variable(name: String)
    case operators(value: String)

    static func nextLexeme(from line: Substring) throws ->
      (lexeme: Lexeme, line: String, charactersUsed: Int) {
        if let match = try /\s*([a-z]+)\s/.firstMatch(in: line) {
            return (lexeme: Lexeme.variable(name: String(match.1)),
                    line: String(match.0),
                    charactersUsed: match.0.count)
                        
        } else if let match = try /(\s*)(\+)(\s*)/.prefixMatch(in: line) { //only suited for plus sign currently
            guard (match.1.count == 0 && match.3.count == 0) ||
                    (match.1.count > 0 && match.3.count > 0) else {
                throw LexemeError.inconsistentSpacingForOperator(operator: "+", inLine: String(line))
            }
            
            return (lexeme: Lexeme.operators(value: String(match.2)),
                    line: String(match.0),
                    charactersUsed: match.0.count)
            
        } else {
            throw LexemeError.failedToFindLexeme(inLine: String(line))
        }
    }
}

struct LexemeSource {
    let lexeme: Lexeme
    let text: String
    let lineIndex: Int
    let columnIndex: Int

    static func lex(line: String) throws {
        var workingLine = Substring(line)
        while workingLine.count > 0 {
            let (lexeme, text, charactersUsed) = try Lexeme.nextLexeme(from: workingLine)
            workingLine = workingLine.dropFirst(charactersUsed)
            print("characters: \(charactersUsed) text: \(text) lexeme: \(lexeme)")
        }
    }
}
    

func main() {
    do {
        let line = " var x = 123 var "
        try LexemeSource.lex(line: line)
    } catch {
        print("Failed because \(error).")
    }
}

main()
