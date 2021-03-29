// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;

string[] outputs = [];
int counter = 0;

@test:Mock {
    moduleName: "ballerina/io",
    functionName: "println"
}
test:MockFunction mock_printLn = new();

public function mockPrint(any|error... s) {
    any|error s0 = s[0];
    string data0 = s0 is error ? s0.toString() : s0.toString();
    match counter {
        0|1|6 => {
            outputs[counter] = data0;
        }
        _ => {
            any|error s1 = s[1];
            string data1 = s1 is error ? s1.toString() : s1.toString();
            outputs[counter] = data0 + data1;
        }
    }
    counter += 1;
}

@test:Config {
    enable:false
}
function testFunc() {
    test:when(mock_printLn).call("mockPrint");

    main();
    test:assertEquals(outputs[2], "Rows affected: 1");
    test:assertEquals(outputs[3], "Generated Customer ID: 1");
    test:assertEquals(outputs[4], "Updated Row count: 1");
    test:assertEquals(outputs[5], "Deleted Row count: 1");
    test:assertEquals(outputs[6], "Sample executed successfully!");
}
