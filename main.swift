//defines data type used to break apart the equation
indirect enum ParseUnit {
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
func main() {
    print("Enter your Boolean Equation")
    if var equationString = readLine() {  //receives user equation
        equationString.replace(" ", with: "") //removes all spaces
    
        var parsedArray = parse(input: equationString)
    } else { //if nothing is inputted, just tells them that
        print("Did not enter an equation")
}

func parse(_ input: String) -> Array {
    
}

