import Foundation

enum Lexeme {
    enum LexemeError: Error {
        case failedToFindLexeme(inLine: String)
//        case failedToParseLexeme(inLine: String)
    }

    static func nextLexeme(from line: Substring) throws ->
      (lexeme: String, line: Substring, charactersUsed: Int, op: Bool) {
        if let match = try /\s*([a-z]+|[\+]+)\s*/.firstMatch(in: line) { //finds first lexeme
            if match.1.contains(/(\+)/) { //checks if lexeme is an operator and returns
                return (String(match.1),
                        line: match.0,
                        charactersUsed: match.0.count,
                        op: true)
                
            } else { //returns non operators
                return (String(match.1),
                        line: match.0,
                        charactersUsed: match.0.count,
                        op: false)
            }
            
        } else {
            throw LexemeError.failedToFindLexeme(inLine: String(line))
        }
    }
}

struct LexemeSource {
    let lexeme: Lexeme
    let text: String
    static var allLexemes: [String] = []
    static var onlyVariables: [String] = []

    static func lex(line: String) throws ->
      (lexemes: [String], variables: [String]) {
        var workingLine = Substring(line)
        while workingLine.count > 0 {
            let (lexeme, text, charactersUsed, op) = try Lexeme.nextLexeme(from: workingLine) //iterates through lexemes

            allLexemes.append(lexeme) //collects all lexemes
            if !op { //adds non operators to array for truth table
                onlyVariables.append(lexeme)
            }
            
            workingLine = workingLine.dropFirst(charactersUsed)
            print("characters: '\(charactersUsed)' text: '\(text)' lexeme: '\(lexeme)'")
        }
        return (lexemes: allLexemes, variables: onlyVariables)
    }
}

func truthTableGen(from variables: [String]) -> [String: [Bool]]{
    var truthTable : [String: [Bool]] = [:]
    for column in 0 ..< variables.count { //selects a variable
        var values : [Bool] = []
        var flag = false
        for row in 0 ..< Int(truncating: pow(2, variables.count) as NSNumber) { //caps rows to 2^n
            if row % Int(truncating: pow(2, column) as NSNumber) == 0 { //overly complicated way I make the truth table
                values.append(flag)
                flag = !flag
            } else {
                values.append(!flag)
            }
        }
        truthTable.updateValue(values, forKey: variables[column])
    }
    return truthTable
}

indirect enum parseNode {
    case addition(parseNode, parseNode)
    case variab(String)

}

func parse(from origin: [String]) -> parseNode {
    if origin.count == 1 { //node endcase
        return parseNode.variab(origin[0])
    }
    
    if origin.contains("+") {
        let i = origin.firstIndex(of: "+")!
        return parseNode.addition(
          parse(from: Array(origin[0 ..< i]) ),
          parse(from: Array(origin[i + 1 ..< origin.count]) )
        )  
    }
    
    return parseNode.variab("broken")
}

func evaluate(_ tree: parseNode, with truthTable: [String : [Bool]]) -> [Bool] {
    var results : [Bool] = []
    for i in 0 ..< Int(truncating: pow(2, truthTable.count) as NSNumber) { //iterates through rows of truthTable
        results.append(solve(tree, with: truthTable, at: i))
    }
    return results
}

func solve(_ tree: parseNode, with truthTable: [String : [Bool]], at index: Int) -> Bool {
    switch tree { //recursively goes down tree and returns bool value
    case .variab(let variableName):
        return truthTable[variableName]![index]
    case .addition(let Left, let Right):
        return solve(Left, with: truthTable, at: index) && solve(Right, with: truthTable, at: index)
    }
}

func printTable(variables: [String], table: [String: [Bool]], results: [Bool]) {
    for name in variables {
        for i in 0 ..< table[name]!.count {
            if table[name]![i] {
                print("1", terminator: " ")
            } else {
                print("0", terminator: " ")
            }
        }
        print(name)
    }
    print("----------------------------")
    for i in 0 ..< results.count {
        if results[i] {
            print("1", terminator: " ")
        } else {
            print("0", terminator: " ")
        }
    }
    print("Results")
}

func main() {
    do {
        let line = " var  +  botot"
        let (lexemes, variables) = try LexemeSource.lex(line: line)
        // print(lexemes,p variables)
        
        let tree = parse(from: lexemes) //makes parse tree
        
        let sortedVar = variables.sorted() 
        let truthTable = truthTableGen(from: sortedVar) //generates starting values for variables

        let results = evaluate(tree, with: truthTable)

        print("\n" + line + "\n")
        printTable(variables: sortedVar, table: truthTable, results: results)
    } catch {
        print("Failed because \(error).")
    }
}

main()
