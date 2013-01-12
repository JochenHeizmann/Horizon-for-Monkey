#include <ctime>

#define HOST_NAME_MAX 1024

class util {
public:
    void static NavigateToUrl(String url) {
        system("open http://www.intermediaware.com");
    }

    int static GetTimestamp() {
        return std::time(0);
    }

    bool static IsTabletDevice()
    {
        return true;
    }

    String static GetHostname() {
        return "localhost";

        // char name[HOST_NAME_MAX + 1];
        // return gethostname(name, sizeof name) == -1 || printf("%s\n", name) < 0 ? EXIT_FAILURE : EXIT_SUCCESS;

        /*
        if( gethostname(name, sizeof name) == -1 ) {
            return printf("%s", name);
        } else {
            return "localhost";
        }
        */
    }
};
