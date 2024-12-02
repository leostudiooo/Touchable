//
//  MIDIVirtualDevice.swift
//  Touchable
//
//  Created by Leo Li on 2024/12/2.
//

import Foundation
import CoreMIDI

class MIDIVirtualDevice {
    var client: MIDIClientRef = 0
    var outputPort: MIDIPortRef = 0
    var virtualSource: MIDIEndpointRef = 0
    
    init(name: String) {
        createMIDIClient(name: name)
        createVirtualSource(name: name)
    }
    
    deinit {
        MIDIClientDispose(client)
    }
    
    func createMIDIClient(name: String) {
        let status = MIDIClientCreateWithBlock(name as CFString, &client) { notification in
            print("Received MIDI Notification: \(notification)")
        }
        if status != noErr {
            print("Error creating MIDI client: \(status)")
        }
    }
    
    func createVirtualSource(name: String) {
        let status = MIDISourceCreate(client, name as CFString, &virtualSource)
        if status != noErr {
            print("Error creating virtual source: \(status)")
        }
    }
    
    func sendControlChange(channel: UInt8, controller: UInt8, value: UInt8) {
        let statusByte: UInt8 = 0xB0 | (channel & 0x0F)  // 0xB0 表示 Control Change
        let eventData: [UInt8] = [statusByte, controller, value]

        // 创建一个 UInt32 数组来填充 64 个位置
        var words = [UInt32](repeating: 0, count: 64)
        
        // 将 MIDI 数据填充到 words 数组中
        eventData.withUnsafeBytes { eventPointer in
            let wordCount = (eventData.count + 3) / 4 // 计算所需的 32 位字数
            memcpy(&words, eventPointer.baseAddress!, eventData.count)
        }

        // 构建 MIDIEventPacket
        var packet = MIDIEventPacket(
            timeStamp: mach_absolute_time(),
            wordCount: UInt32((eventData.count + 3) / 4),
            words: (
                words[0], words[1], words[2], words[3],
                words[4], words[5], words[6], words[7],
                words[8], words[9], words[10], words[11],
                words[12], words[13], words[14], words[15],
                words[16], words[17], words[18], words[19],
                words[20], words[21], words[22], words[23],
                words[24], words[25], words[26], words[27],
                words[28], words[29], words[30], words[31],
                words[32], words[33], words[34], words[35],
                words[36], words[37], words[38], words[39],
                words[40], words[41], words[42], words[43],
                words[44], words[45], words[46], words[47],
                words[48], words[49], words[50], words[51],
                words[52], words[53], words[54], words[55],
                words[56], words[57], words[58], words[59],
                words[60], words[61], words[62], words[63]
            )
        )

        // 构建 MIDIEventList
        var eventList = MIDIEventList(
            protocol: MIDIProtocolID._1_0,
            numPackets: 1,
            packet: packet
        )

        // 使用 MIDIReceivedEventList 发送 MIDI 消息
        let status = MIDIReceivedEventList(virtualSource, &eventList)
        if status != noErr {
            print("Error sending MIDI event: \(status)")
        }
    }
}
