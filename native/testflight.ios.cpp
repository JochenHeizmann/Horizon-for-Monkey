
#import "TestFlightSDK1/TestFlight.h"

class TestflightMonk
{
public:
    static void SetDeviceIdentifier()
    {
        [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    }

    static void TakeOff(String teamToken)
    {
        [TestFlight takeOff:teamToken.ToNSString()];
    }

    static void PassCheckpoint(String checkpointName)
    {     
        [TestFlight passCheckpoint:checkpointName.ToNSString()];
    }
};