## About

This is simple demo app to show how to reverse a clip of audio file with `AVFoundation`, specifically, the `AVFAudio` part.

In this demo, I just use `AVAudioFile`/`AVAudioPCMBuffer`/`AVAudioFormat` to reverse a `m4a` audio file, besides, it illustrates how to use the `UnSafe` part of `Swift` :)

## Warning

Due to the implementation, which just read all the samples from origin audio file to memory PCM buffer, it' not an optimized solution to do so and probably would cause memory problem. In practice you should process segment by segment.

For this demo, I use a `m4a` file with `bit rate` of about `64 kb/s` and duration of `62 seconds` and the peak of memory use is about `13 MB` for the PCM buffer memory.

## Reference

[foundry's answer](http://stackoverflow.com/questions/35581531/cant-reverse-avasset-audio-properly-the-only-result-is-white-noise)
> I can't give a comment as I ain't got that much reputation to do so.

