import Foundation

enum Lexeme {
    enum LexemeError: Error {
        case failedToFindLexeme(inLine: String)
        
    }

    case variable(name: String)
    case operators(value: String)

    static func nextLexeme(from line: Substring) throws -> [Lexeme] {
        var Lexemes : [Lexeme] = []
        if let match = try /\s*([a-z]+)\s/.firstMatch(in: line) {
            
            //get range from match substring
            let matchRange = NSRange(match.range, in: line)
            print(matchRange)

            //removes leading and trailing spaces from match, then adds to array
            Lexemes.append(.variable(name: String(match.1)))

            /* This would recurrsively run the program until 
            if (matchRange.upperBound) < (line.count - 1) {
                let index = line.index(line.endIndex, offsetBy: matchRange.upperBound)
                let next = try self.nextLexeme(from: line.suffix(from: index))
                return Lexemes + next
                
            } else {
                return Lexemes
            } 
            */
                        
        } else if let match = try /\s*(\+)\s*/.prefixMatch(in: line) { //only suited for plus sign currently
            Lexemes.append(.operators(value: String(match.1)))
            
        } else {
            throw LexemeError.failedToFindLexeme(inLine: String(line))
        }

        return Lexemes
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
