//
//  ViewController.swift
//  AudioReverse
//
//  Created by tomisacat on 12/05/2017.
//  Copyright © 2017 tomisacat. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("start time: \(Date())")
        let fromUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "guitar", ofType: "m4a")!)
        guard let outputUrl = reverse(fromUrl: fromUrl) else {
            return
        }
        
        print("done time: \(Date()), output url: \(outputUrl)")
    }

    func reverse(fromUrl: URL) -> URL? {
        do {
            let inFile: AVAudioFile = try AVAudioFile(forReading: fromUrl)
            let format: AVAudioFormat = inFile.processingFormat
            let frameCount: AVAudioFrameCount = UInt32(inFile.length)
            let outSettings = [AVNumberOfChannelsKey: format.channelCount,
                               AVSampleRateKey: format.sampleRate,
                               AVLinearPCMBitDepthKey: 16,
                               AVFormatIDKey: kAudioFormatMPEG4AAC] as [String : Any]
            let outputPath = NSTemporaryDirectory() + "/" + "reverse.m4a"
            let outputUrl = URL(fileURLWithPath: outputPath)
            let outFile: AVAudioFile = try AVAudioFile(forWriting: outputUrl, settings: outSettings)
            let forwardBuffer: AVAudioPCMBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)
            let reverseBuffer: AVAudioPCMBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)
            
            try inFile.read(into: forwardBuffer)
            let frameLength = forwardBuffer.frameLength
            reverseBuffer.frameLength = frameLength
            let audioStride = forwardBuffer.stride
            
            for channelIdx in 0..<forwardBuffer.format.channelCount {
                let forwardChannelData = forwardBuffer.floatChannelData?.advanced(by: Int(channelIdx)).pointee
                let reverseChannelData = reverseBuffer.floatChannelData?.advanced(by: Int(channelIdx)).pointee
                
                var reverseIdx: Int = 0
                for idx in stride(from: frameLength, to: 0, by: -1) {
                    memcpy(reverseChannelData?.advanced(by: reverseIdx * audioStride), forwardChannelData?.advanced(by: Int(idx) * audioStride), MemoryLayout<Float>.size)
                    reverseIdx += 1
                }
            }
            
            try outFile.write(from: reverseBuffer)
            
            return outputUrl
        } catch let error {
            print(error.localizedDescription)
            
            return nil
        }
    }
}

