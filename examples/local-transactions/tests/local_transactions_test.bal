import ballerina/test;

(any|error)[] outputs = [];

// This is the mock function which will replace the real function
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

    // Invoking the main function
    error? output = main();
    test:assertExactEquals(outputs[0], "Transaction Info: ");
    test:assertExactEquals(outputs[2], "Transaction committed");
    test:assertExactEquals(outputs[3], "Account Credit: ");
    test:assertExactEquals(outputs[4], "{\"affectedRowCount\":1,\"lastInsertId\":null}");
    test:assertExactEquals(outputs[5], "Account Debit: ");
    test:assertExactEquals(outputs[6], "{\"affectedRowCount\":1,\"lastInsertId\":null}");
}
