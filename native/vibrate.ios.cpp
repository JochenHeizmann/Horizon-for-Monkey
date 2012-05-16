#import <AudioToolbox/AudioServices.h>

void Vibrate()
{
// only sdk 4.0+
  AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}
