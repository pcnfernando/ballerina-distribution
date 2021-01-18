// The Ballerina WebSub Subscriber service, which subscribes to notifications at the Hub.
import ballerina/log;
import ballerina/websub;

// The endpoint to which the subscriber service is bound.
listener websub:Listener websubEP = new (8181);

// Annotations specifying the subscription parameters for the order management service.
// A subscription request would be sent to the hub with the topic discovered at the
// resource URL specified.
@websub:SubscriberServiceConfig {
    subscribeOnStartUp: true,
    target: "http://localhost:9090/ordermgt/order",
    leaseSeconds: 3600,
    secret: "Kslk30SNF2AChs2"
}
service websub:SubscriberService /ordereventsubscriber on websubEP {
    // Defines the remote function, which accepts the content delivery requests.
    remote function onNotification(websub:Notification notification) {
        var payload = notification.getTextPayload();
        if (payload is string) {
            log:print("WebSub Notification Received: " + payload);
        } else {
            log:printError("Error retrieving payload as string",
                              err = payload);
        }
    }
}
