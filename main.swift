//defines data type used to break apart the equation
indirect enum ParseUnit {
    case unparsed(String)
    case operate(op: Operating, leftBranch: ParseUnit, rightBranch: ParseUnit)
    case variable(v: String)
}

enum Operating {
    case parenthesis
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
if var equationString = readLine() {  //receives user equation
    equationString.replace(" ", with: "") //removes all spaces
    
    var equation : ParseUnit = ParseUnit.unparsed(equationString)
    parse(&equation)
    
        
} else { //if nothing is inputted, just tells them that
    print("Did not enter an equation")
}


func parse(_ input:inout ParseUnit) {
    print(input)
}

