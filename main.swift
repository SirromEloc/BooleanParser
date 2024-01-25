import Foundation

enum Lexeme {
    enum LexemeError: Error {
        case failedToFindLexeme(inLine: String)
        
    }

    case chunk(name: String)
    case operators(value: String)

    static func nextLexeme(from line: Substring) throws ->
      (lexeme: Lexeme, line: Substring, charactersUsed: Int) {
        if let match = try /\s*([a-z]+|[\+]+)\s/.firstMatch(in: line) { //finds first lexeme
            
            if match.1.contains(/(\+)/) { //checks if lexeme is an operator and returns
                return (lexeme: Lexeme.operators(value: String(match.1)),
                        line: match.0,
                        charactersUsed: match.0.count)
                
            } else { //returns non variables
                return (lexeme: Lexeme.chunk(name: String(match.1)),
                    line: match.0,
                    charactersUsed: match.0.count)
            }
            
        } else {
            throw LexemeError.failedToFindLexeme(inLine: String(line))
        }
    }
}

struct LexemeSource {
    let lexeme: Lexeme
    let text: String
    static var allLexemes: [Lexeme] = []
    static var onlyVariables: [Lexeme] = []

    static func lex(line: String) throws ->
      (lexemes: [Lexeme], variables: [Lexeme]) {
        var workingLine = Substring(line)
        while workingLine.count > 0 {
            let (lexeme, text, charactersUsed) = try Lexeme.nextLexeme(from: workingLine) //iterates through lexemes

            allLexemes.append(lexeme)
            if case .chunk = lexeme {
                onlyVariables.append(lexeme)
            }
            
            workingLine = workingLine.dropFirst(charactersUsed)
            print("characters: '\(charactersUsed)' text: '\(text)' lexeme: '\(lexeme)'")
        }
        return (lexemes: allLexemes, variables: onlyVariables)
    }
}
    
func parseTree(from origin: [Lexeme]) throws {
    for lex in origin {
        if case .operators = lex {
            
        }
}

func main() {
    do {
        let line = " var x   +  mar "
        let (lexemes, variables) = try LexemeSource.lex(line: line)
        print(lexemes, variables)
    } catch {
        print("Failed because \(error).")
    }
}

main()
