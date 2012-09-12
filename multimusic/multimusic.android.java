
class MultiMusic {

    MediaPlayer[] music = new MediaPlayer[16];
    int state[] = new int[16];

    int LoadMusic(String path, int channel){
        if (channel > 15) return -1;
        StopMusic(channel);
        music[channel] = MonkeyData.openMedia( path );

        if (music == null) return -1;
        return 0;
    }

    void ClearAll()
    {
        for (int i = 0; i < 16; ++i) {
            StopMusic(i);
            FreeChannel(i);
        }
    }

    int FreeChannel(int channel) {
        if (channel > 15) return -1;
        state[channel] = 0;
        if( music[channel]==null ) return -1;
        music[channel].release();
        return 1;
    }

    int StopMusic(int channel) {
        if (channel > 15) return -1;
        if (state[channel] <= 0) return -1;
        state[channel] = 0;
        if( music[channel]==null ) return -1;
        music[channel].stop();
        return 1;
    }

    int PlayMusic( int channel,int flags ){
        if (channel > 15) return -1;
        if( music[channel]==null ) return -1;
        music[channel].setLooping( (flags&1)!=0 );
        music[channel].setVolume( 1,1 );
        music[channel].start();
        state[channel] = 1;
        return 0;
    }

    int UnmuteMusic(int channel) {
        if (channel > 15) return -1;
        if (music[channel]==null) return -1;
        music[channel].setVolume(1,1);
        return 1;
    }

    int MuteMusic(int channel) {
        if (channel > 15) return -1;
        if (music[channel]==null) return -1;
        music[channel].setVolume(0,0);
        return 1;
    }

    int MusicChannelState(int channel) {
        return state[channel];
    }

}
