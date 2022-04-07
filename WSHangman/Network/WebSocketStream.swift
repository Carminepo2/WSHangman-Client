//
//  WebSocketStream.swift
//  WSHangman
//
//  Created by Carmine Porricelli on 23/03/22.
//
import os
import Foundation


// An AsyncSequence type provides asynchronous, sequential, iterated access to its elements.
// We can then read the message of the socket in a for loop concurrently.

// for try await message in socket {
//     // stuff to do...
// }

class WebSocketStream: AsyncSequence {
    
    typealias Element = URLSessionWebSocketTask.Message
    typealias AsyncIterator = AsyncThrowingStream<URLSessionWebSocketTask.Message, Error>.Iterator
    
    private lazy var logger = Logger(subsystem: "developer.academy.WSHangman.WebSocketStream", category: "WebSocketStream")
    private lazy var jsonDecoder = JSONDecoder()
    private lazy var jsonEncoder = JSONEncoder()
    
    private let url: URL
    private let session: URLSession
    private var stream: AsyncThrowingStream<Element, Error>?
    
    private var continuation: AsyncThrowingStream<Element, Error>.Continuation?
    private var socket: URLSessionWebSocketTask
    private var pingTimer: Timer?
    
    // The initializer takes in a url string and a URLSession object which we use to build a URLSessionWebSocketTask to listen and process web socket messages.
    init(url: URL, session: URLSession = URLSession.shared) {
        
        self.session = session
        self.url = url
        socket = session.webSocketTask(with: url)
        
        stream = AsyncThrowingStream { continuation in
            self.continuation = continuation
            self.continuation?.onTermination = { @Sendable [socket] _ in
                socket.cancel()
                self.pingTimer?.invalidate()
            }
        }
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        guard let stream = stream else {
            fatalError("Stream was not initialized")
        }
        socket.resume()
        listenForMessages()
        return stream.makeAsyncIterator()
    }
    
    private func listenForMessages() {
        socket.receive { [unowned self] result in
            switch result {
            case .success(let message):
                continuation?.yield(message)
                listenForMessages()
            case .failure(let error):
                continuation?.finish(throwing: error)
            }
        }
    }
    
    func sendMessage<T>(data: T) async where T: Encodable {
        guard let jsonData = try? JSONEncoder().encode(data),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
                  logger.error("❌ Error: Trying to convert WSMessage to JSON data")
                  return
              }
        
        do {
            try await socket.send(.data(jsonData))
            self.logger.log("✅ Success sending message data \(jsonString)")
        } catch {
            self.logger.error("❌ Error sending message data \(jsonString): \(error.localizedDescription)")
        }
    }
    
    func sendMessage(string: String) async {
        do {
            try await socket.send(.string(string))
            self.logger.log("✅ Success sending message string \(string)")
            
        } catch {
            self.logger.error("❌ Error sending a message string: \(error.localizedDescription)")
            
        }
    }
    
    func ping(interval: TimeInterval = 25.0) {
        pingTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.ping()
        }
    }
    
    func ping() {
        self.socket.sendPing { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func reconnect() {
        self.socket = session.webSocketTask(with: url)
    }
    
}
