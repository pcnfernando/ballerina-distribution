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

import ballerina/mime;
import ballerina/test;

@test:Config {}
function testMimeFunctions() {
    mime:Entity entity = new;
    string entityBody = "Hello Ballerina!";
    entity.setBody(entityBody);
    var stringPayload = entity.getText();
    if stringPayload is string {
        test:assertEquals(stringPayload, entityBody, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Found unexpected output type");
    }

    entity = new;
    json jsonContent = {code:123};
    entity.setHeader("content-type", "application/yang-patch+json");
    entity.setJson(jsonContent);
    var JsonPayload = entity.getJson();
    if JsonPayload is json {
        test:assertEquals(JsonPayload, jsonContent, msg = "Found unexpected output");
    } else {
        test:assertFail(msg = "Found unexpected output type");
    }
    
    string headerName = "Content-Type";
    string headerValue = "application/json";
    string headerNameToBeUsedForRetrieval = "Content-Type";
    entity = new;
    entity.addHeader(headerName, headerValue);
    string returnVal = checkpanic entity.getHeader(headerNameToBeUsedForRetrieval);

    test:assertEquals(returnVal, headerValue, msg = "Found unexpected output");

}
