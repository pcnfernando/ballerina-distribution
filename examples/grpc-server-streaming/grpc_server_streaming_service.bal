// This is the server implementation for the server streaming scenario.
import ballerina/grpc;
import ballerina/log;

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR,
    descMap: getDescriptorMap()
}
service /HelloWorld on new grpc:Listener(9090) {

    isolated function lotsOfReplies(grpc:Caller caller, string name) {
        log:print("Server received hello from " + name);
        string[] greets = ["Hi", "Hey", "GM"];

        // Send multiple messages to the caller.
        foreach string greet in greets {
            string msg = greet + " " + name;
            grpc:Error? err = caller->send(msg);
            if (err is grpc:Error) {
                log:printError("Error from Connector: " + err.message());
            } else {
                log:print("Send reply: " + msg);
            }
        }

        // Once all the messages are sent, the server notifies the caller with a `complete` message.
        grpc:Error? result = caller->complete();
        if (result is grpc:Error) {
            log:printError("Error in sending completed notification to caller",
                err = result);
        }
    }
}
