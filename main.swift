//defines data type used to break apart the equation
indirect enum ParseUnit {
    case operate(op: Operating, leftBranch: ParseUnit, rightBranch: ParseUnit)
    case variable(v: String)
}

enum Operating {
    case rpar
    case lpar
    case negation
    case land
    case lor
    case xor
    case implies
    case equation
    case nequation
}

//start of program
print("Enter your Boolean Equation")
if let equationString = readLine() {  //receives user equation
    //need translating function here

    let tokenized = tokenizer(equationString)
    
        
} else { //if nothing is inputted, just tells them that
    print("Did not enter an equation")
}


func tokenizer(_ input: String) -> Array<Any> {
    let operators : [Character : Operating] = [
      "^" : .land,
    ]

    var parseArray : Array<Any> = []
    
    
    for (index, char) in input.enumerated() {
        while char != " " {
            if let token  = operators[char] {
                parseArray.append(token)
            }
           
        }
    }
    return parseArray
}

func makeUnit(op: Operating, leftBranch: String, rightBranch: String) {
    
}
