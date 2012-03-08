#include <ctime>

class util {
public:
	void static NavigateToUrl(String url) {
		system("open http://www.intermediaware.com");
	}

	int static GetTimestamp() {
		return std::time(0);
	}
};