//
//  WindowController.swift
//  TouchbarTimer
//
//  Created by Mikołaj Knysak on 01/11/2018.
//  Copyright © 2018 Mikołaj Knysak. All rights reserved.
//

import Cocoa

fileprivate extension NSTouchBarItem.Identifier {
    static let controlStripButton = NSTouchBarItem.Identifier(
        rawValue: "com.mikolajknysak.TouchBarItem.controlStripButton"
    )
}

class WindowController: NSWindowController {
    
    // --- OUTLETS --- //
    
    @IBOutlet weak var touchButton: NSButton!
    @IBOutlet weak var inputPreview: NSTextField!
    
    // --- ATTRIBUTES --- //
    
    let controlStripItem = NSControlStripTouchBarItem(identifier: .controlStripButton)
    var inputTime = Date()
    var timer = Timer()
    var isRunning = false
    var diff = 0
    
    var controlStripButton: NSButton? {
        set {
            // This will replace the ControlStripItem by the view given
            controlStripItem.view = newValue!
        }
        get {
            return controlStripItem.view as? NSButton
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // --- OVERRIDES --- //
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        DFRSystemModalShowsCloseBoxWhenFrontMost(true)
        createControlStripButton()
        
        // Need to be performed after the creation of ControlStripButton
        
        controlStripItem.isPresentInControlStrip = true;
        updateInputTime()
    }
    
    // --- ACTIONS --- //
    
    @IBAction func decrementDay(_ sender: Any) {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: inputTime)
        components.day = components.day! - 1
        inputTime = calendar.date(from: components)!
        updateInputTime()
    }
    
    @IBAction func incrementDay(_ sender: Any) {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: inputTime)
        components.day = components.day! + 1
        inputTime = calendar.date(from: components)!
        updateInputTime()
    }
    
    @IBAction func decrementHour(_ sender: Any) {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: inputTime)
        components.hour = components.hour! - 1
        inputTime = calendar.date(from: components)!
        updateInputTime()
    }
    
    @IBAction func incrementHour(_ sender: Any) {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: inputTime)
        components.hour = components.hour! + 1
        inputTime = calendar.date(from: components)!
        updateInputTime()
    }
    
    @IBAction func decrementMinute(_ sender: Any) {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: inputTime)
        components.minute = components.minute! - 1
        inputTime = calendar.date(from: components)!
        updateInputTime()
    }
    
    @IBAction func incrementMinute(_ sender: Any) {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: inputTime)
        components.minute = components.minute! + 1
        inputTime = calendar.date(from: components)!
        updateInputTime()
    }
    
    @IBAction func startButton(_ sender: Any) {
        diff = calcTimeDiff(currentTimeInSeconds: getCurrentTimeInSeconds(currentTime: Date()), inputTimeInSeconds: getInputTimeInSeconds(inputTime: inputTime))
        controlStripButton?.bezelColor = NSColor.systemYellow
        controlStripButton?.title = convertTimeDiffToString(timeDiff: diff)
        isRunning = true
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        touchBar?.minimizeSystemModal()
    }
    
    @IBAction func exitButton(_ sender: Any) {
        NSApp.terminate(self)
    }
    
    // --- PRIVATE METHODS --- //
    
    @objc func presentModalTouchBar() {
        touchBar?.presentAsSystemModal(for: controlStripItem)
    }
    
    func createControlStripButton() {
        controlStripButton = NSButton(
            title: "⌛︎",
            target: self,
            action: #selector(controlStripButtonPress))
    }
    
    @objc func controlStripButtonPress() {
        if(isRunning) {
            timer.invalidate()
            isRunning = false
        }
        
        inputTime = Date()
        updateInputTime()
        presentModalTouchBar()
        controlStripButton?.title = "⌛︎"
        controlStripButton?.bezelColor = NSColor.controlColor
    }
    
    @objc func updateTimer() {
        diff = calcTimeDiff(currentTimeInSeconds: getCurrentTimeInSeconds(currentTime: Date()), inputTimeInSeconds: getInputTimeInSeconds(inputTime: inputTime))
        controlStripButton?.title = convertTimeDiffToString(timeDiff: diff)
        
        if(diff <= 0) {
            controlStripButton?.bezelColor = NSColor.systemGreen
            controlStripButton?.title = "✔︎"
            timer.invalidate()
            isRunning = false
        }
    }
    
    func updateInputTime() {
        inputPreview.stringValue = getTimeString(time: inputTime)
    }
    
    func getTimeString(time: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: time)
        let month = calendar.component(.month, from: time)
        let day = calendar.component(.day, from: time)
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        
        return String(format: "%0.4d/%0.2d/%0.2d %0.2d:%0.2d:00", year, month, day, hour, minute)
    }
    
    func getCurrentTimeInSeconds(currentTime: Date) -> Int {
        let timeInSeconds = currentTime.timeIntervalSince1970
        
        return Int(timeInSeconds)
    }
    
    func getInputTimeInSeconds(inputTime: Date) -> Int {
        let timeInSeconds = inputTime.timeIntervalSince1970
        
        return Int(timeInSeconds)
    }
    
    func calcTimeDiff(currentTimeInSeconds: Int, inputTimeInSeconds: Int) -> Int {
        let result = inputTimeInSeconds - currentTimeInSeconds
        
        return result
    }
    
    func convertTimeDiffToString(timeDiff: Int) -> String {
        let hours = timeDiff / 3600
        let minutes = (timeDiff / 60) % 60
        let seconds = timeDiff % 60
        
        return String(format: "%0.1d:%0.2d:%0.2d", hours, minutes, seconds);
    }

}
