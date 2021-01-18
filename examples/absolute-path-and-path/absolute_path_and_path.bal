import ballerina/http;
import ballerina/log;

// The `absolute resource path` identifier represents the absolute path to the service.  When bound to a listener
// endpoint, the service will be accessible at the specified path. If the path is omitted, then it defaults to `/`.
// A string literal also can represent the absolute path. E.g., `"/foo"`.
// The `type descriptor` represents the respective type of the service. E.g., `http:Service`.
service http:Service /foo on new http:Listener(9090) {

    // The `resource method name` identifier (`post`) confines the resource to the specified HTTP methods. In this
    // instance, only `POST` requests are allowed. The `default` accessor name can be used to match with all methods
    // including standard HTTP methods and custom methods.
    // The `resource path` identifier associates the relative path to the service object's path. E.g., `bar`.
    resource function post bar(http:Caller caller, http:Request req) {
        // This method retrieves the request payload as a JSON.
        var payload = req.getJsonPayload();
        http:Response res = new;
        if (payload is json) {
            // Since the JSON is known to be valid, `untaint` the data denoting that the data is trusted and set the JSON to the response.
            res.setJsonPayload(<@untainted>payload);
        } else {
            res.statusCode = 500;
            res.setPayload(<@untainted>payload.message());
        }
        // Reply to the client with the response.
        var result = caller->respond(res);
        if (result is error) {
           log:printError("Error in responding", err = result);
        }
    }
}
