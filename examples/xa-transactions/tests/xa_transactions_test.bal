import ballerina/test;

(any|error)[] outputs = [];

// This is the mock function, which will replace the real function.
@test:Mock {
    moduleName: "ballerina/io",
    functionName: "println"
}
test:MockFunction mock_printLn = new();

public function mockPrint(any|error... s) {
    foreach var entry in s {
        string str = entry is error ? entry.toString() : entry.toString();
        outputs.push(str);
    }
}

@test:Config {}
function testFunc() {
    test:when(mock_printLn).call("mockPrint");

    // Invoking the main function.
    error? output = main();
    int len = outputs.length();
    test:assertExactEquals(outputs[len-7], "Transaction Info: ");
    test:assertExactEquals(outputs[len-5], "Transaction committed");
    test:assertExactEquals(outputs[len-4], "Employee Updated: ");
    test:assertExactEquals(outputs[len-3], "{\"affectedRowCount\":1,\"lastInsertId\":null}");
    test:assertExactEquals(outputs[len-2], "Salary Updated: ");
    test:assertExactEquals(outputs[len-1], "{\"affectedRowCount\":1,\"lastInsertId\":null}");
}
