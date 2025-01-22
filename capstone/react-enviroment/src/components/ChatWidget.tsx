import { MessageCircle, X } from 'lucide-react';
import React, { useState } from 'react';
import ChatbotWindow from './ChatbotWindow';
import './ChatWidget.css';

const ChatWidget: React.FC = () => {
    const [isOpen, setIsOpen] = useState(false);

    return (
        <div className="chat-widget-container">
            {!isOpen && (
                <div className="chat-prompt">
                    Need help? Chat now!
                </div>
            )}
            
            {isOpen && (
                <div className="chat-window-container">
                    <div className="chat-window-inner">
                        <div className="chat-header">
                            <h3 className="chat-title">Scentopedia Assistant</h3>
                            <button
                                onClick={() => setIsOpen(false)}
                                aria-label="Close chat"
                                className="close-button"
                            >
                                <X className="chat-icon" color="black" />
                            </button>
                        </div>
                        <ChatbotWindow />
                    </div>
                </div>
            )}

            <button
                onClick={() => setIsOpen(!isOpen)}
                aria-label={isOpen ? "Close chat" : "Open chat"}
                className={`chat-toggle-button ${
                    isOpen ? 'chat-toggle-button-open' : 'chat-toggle-button-closed'
                }`}
            >
                <MessageCircle className="chat-icon" />
            </button>
        </div>
    );
};

export default ChatWidget;