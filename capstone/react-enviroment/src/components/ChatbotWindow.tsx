import { collection, getDocs, query, where } from 'firebase/firestore';
import { Loader2 } from 'lucide-react';
import React, { useCallback, useEffect, useRef, useState } from 'react';
import { db } from '../lib/firebase';
import './ChatbotWindow.css';

// Types and Interfaces
interface Fragrance {
    readonly fragranceName: string;
    readonly brandName: string;
    readonly brandImg: string;
    readonly description: string;
    readonly image: string;
    readonly perfumer: string;
    readonly accords: readonly string[];
    readonly combNotes: readonly string[];
    readonly notes: {
        readonly top_notes: readonly string[];
        readonly middle_notes: readonly string[];
        readonly base_notes: readonly string[];
    }
}

type FragranceInfoOption = 'Brand' | 'Notes' | 'Accords' | 'Description';
type MainMenuOption = 'Fragrance Information' | 'Recommend Fragrances';
type ResponseOption = 'Yes' | 'No';

type MessageOptions = MainMenuOption | FragranceInfoOption | ResponseOption;

interface RecommendationState {
    category: 'notes' | 'accords' | 'brand' | null;
    preferences: string[];
    currentPage: number;
    recommendations: Fragrance[];
}

interface ChatMessage {
    id: string;
    text: string;
    sender: 'bot' | 'user';
    options?: MessageOptions[];
    timestamp: number;
}

enum ErrorType {
    NETWORK = 'Network Error',
    DATABASE = 'Database Error',
    VALIDATION = 'Validation Error',
    TIMEOUT = 'Timeout Error',
    RATE_LIMIT = 'Rate Limit Error',
    DATA_FORMAT = 'Data Format Error'
}

class ChatbotError extends Error {
    constructor(public type: ErrorType, message: string) {
        super(message);
        this.name = 'ChatbotError';
    }
}
// Helper Components 
const TypingIndicator: React.FC = () => (
    <div className="typing-indicator">
        {[1, 2, 3].map((dot) => (
            <div key={dot} className={`typing-dot typing-dot-${dot}`} />
        ))}
    </div>
);

const ProgressBar: React.FC<{ progress: number }> = ({ progress }) => (
    <div className="progress-bar">
        <div 
            className="progress-bar-fill"
            data-progress={progress}
        />
    </div>
);

// Soundex utility function
const soundex = (str: string): string => {
    if (!str) return '';
    const a = str.toLowerCase().split('');
    const f = a.shift() || '';
    const r = a.map((v) => {
        switch (v) {
            case 'b': case 'f': case 'p': case 'v': return '1';
            case 'c': case 'g': case 'j': case 'k': 
            case 'q': case 's': case 'x': case 'z': return '2';
            case 'd': case 't': return '3';
            case 'l': return '4';
            case 'm': case 'n': return '5';
            case 'r': return '6';
            default: return '';
        }
    }).join('');
    return `${f}${r.replace(/(\d)?\1+/g, '$1')}`
        .replace(/^(.{4})(.*)/, '$1')
        .padEnd(4, '0')
        .toUpperCase();
};
const ChatbotWindow: React.FC = () => {
    // State declarations
    const [messages, setMessages] = useState<ChatMessage[]>([]);
    const [currentInput, setCurrentInput] = useState('');
    const [selectedFragrance, setSelectedFragrance] = useState('');
    const [awaitingFragranceName, setAwaitingFragranceName] = useState(false);
    const [loading, setLoading] = useState(false);
    const [isTyping, setIsTyping] = useState(false);
    const [progress, setProgress] = useState(0);
    const [isInitializing, setIsInitializing] = useState(true);
    const [lastOptionsTimestamp, setLastOptionsTimestamp] = useState<number>(0);
    const [recommendationState, setRecommendationState] = useState<RecommendationState>({
        category: null,
        preferences: [],
        currentPage: 0,
        recommendations: []
    });
    const [awaitingPreferences, setAwaitingPreferences] = useState(false);
    
    const messagesEndRef = useRef<HTMLDivElement>(null);

    const scrollToBottom = useCallback(() => {
        messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    }, []);

    useEffect(() => {
        scrollToBottom();
    }, [messages, scrollToBottom]);

    const addMessage = useCallback((message: Omit<ChatMessage, 'id' | 'timestamp'>) => {
        const timestamp = Date.now();
        const newMessage = {
            ...message,
            id: timestamp.toString() + Math.random().toString(36).substr(2, 9),
            timestamp
        };
        setMessages(prev => [...prev, newMessage]);
        if (message.options) {
            setLastOptionsTimestamp(timestamp);
        }
    }, []);

    // Initialize chat
    useEffect(() => {
        let isMounted = true;

        const initializeChat = async () => {
            if (!isInitializing || !isMounted) return;
            
            setIsTyping(true);
            
            try {
                await new Promise(resolve => setTimeout(resolve, 500));
                if (!isMounted) return;
                
                addMessage({
                    text: "Hello. I am Scentopedia's virtual assistant. I am here to assist you in your fragrance search.",
                    sender: 'bot'
                });
                
                await new Promise(resolve => setTimeout(resolve, 1000));
                if (!isMounted) return;
                
                addMessage({
                    text: "How may I help you?",
                    sender: 'bot'
                });
                
                await new Promise(resolve => setTimeout(resolve, 1000));
                if (!isMounted) return;
                
                addMessage({
                    text: "Please select an option:",
                    sender: 'bot',
                    options: ["Fragrance Information", "Recommend Fragrances"]
                });
            } finally {
                if (isMounted) {
                    setIsTyping(false);
                    setIsInitializing(false);
                }
            }
        };

        initializeChat();

        return () => {
            isMounted = false;
        };
    }, [addMessage, isInitializing]);
    // Database and recommendation functions
    const handleDatabaseQuery = async (operation: () => Promise<any>, retryCount = 0): Promise<any> => {
        try {
            if (!navigator.onLine) {
                throw new ChatbotError(ErrorType.NETWORK, 'Please check your internet connection');
            }

            const timeoutPromise = new Promise((_, reject) => {
                setTimeout(() => reject(new ChatbotError(ErrorType.TIMEOUT, 'Request timed out')), 10000);
            });

            const progressInterval = setInterval(() => {
                setProgress(prev => Math.min(prev + 10, 90));
            }, 500);

            const result = await Promise.race([operation(), timeoutPromise]);
            
            clearInterval(progressInterval);
            setProgress(100);
            setTimeout(() => setProgress(0), 500);
            
            return result;

        } catch (err: any) {
            setProgress(0);

            if (err instanceof ChatbotError) {
                throw err;
            } else if (err.code === 'permission-denied') {
                throw new ChatbotError(ErrorType.DATABASE, 'Database access denied');
            } else if (err.code === 'resource-exhausted') {
                throw new ChatbotError(ErrorType.RATE_LIMIT, 'Too many requests, please try again later');
            } else if (err.code === 'invalid-argument') {
                throw new ChatbotError(ErrorType.DATA_FORMAT, 'Invalid data format');
            }

            if (retryCount < 3 && (err.type === ErrorType.NETWORK || err.type === ErrorType.TIMEOUT)) {
                await new Promise(resolve => setTimeout(resolve, 1000 * (retryCount + 1)));
                return handleDatabaseQuery(operation, retryCount + 1);
            }

            throw new ChatbotError(ErrorType.DATABASE, 'An unexpected error occurred');
        }
    };

    const validateAndProcessPreferences = (input: string): string[] => {
        const preferences = input
            .split(',')
            .map(pref => pref.trim())
            .filter(pref => pref.length > 0);
            console.log('Processed preferences:', preferences);

        if (recommendationState.category === 'brand' && preferences.length > 1) {
            throw new ChatbotError(
                ErrorType.VALIDATION, 
                "Please enter only one brand name. Which brand would you like recommendations for?"
            );
        }

        if ((recommendationState.category === 'notes' || recommendationState.category === 'accords') 
            && preferences.length > 5) {
            throw new ChatbotError(
                ErrorType.VALIDATION, 
                `Please enter no more than 5 ${recommendationState.category}. Which would you like to use?`
            );
        }

        return preferences;
    };

    const fetchRecommendations = async (preferences: string[]): Promise<Fragrance[]> => {
        try {
            const fragrancesRef = collection(db, 'Fragrance');
            let querySnapshot;
    
            if (!recommendationState.category) return [];
    
            switch (recommendationState.category) {
                case 'notes':
                    querySnapshot = await getDocs(fragrancesRef);
                    const normalizedPreferences = preferences.map(pref => 
                        pref.toLowerCase().trim()
                    );
                    
                    const noteResults = querySnapshot.docs
                        .map(doc => {
                            const data = doc.data() as Fragrance;
                            if (!data.combNotes || !Array.isArray(data.combNotes)) {
                                console.warn(`Invalid combNotes for fragrance: ${data.fragranceName}`);
                                return null;
                            }
                            return data;
                        })
                        .filter((fragrance): fragrance is Fragrance => {
                            if (!fragrance) return false;
    
                            const normalizedFragranceNotes = fragrance.combNotes.map(note => 
                                note.replace(/^"(.+)"$/, '$1').toLowerCase().trim()
                            );
    
                            console.log(`Checking ${fragrance.fragranceName}:`, {
                                normalizedNotes: normalizedFragranceNotes,
                                preferences: normalizedPreferences
                            });
    
                            // Return true if ANY of the preferred notes match
                            const hasMatch = normalizedPreferences.some(pref => 
                                normalizedFragranceNotes.includes(pref)
                            );
    
                            if (hasMatch) {
                                const matches = normalizedPreferences.filter(pref => 
                                    normalizedFragranceNotes.includes(pref)
                                );
                                console.log(`Found matches for ${fragrance.fragranceName}:`, matches);
                            }
    
                            return hasMatch;
                        });
    
                    console.log('Final results:', {
                        totalFound: noteResults.length,
                        preferences: normalizedPreferences
                    });
    
                    return noteResults;
    
                case 'accords':
                    querySnapshot = await getDocs(fragrancesRef);
                    const accordResults = querySnapshot.docs
                        .map(doc => doc.data() as Fragrance)
                        .filter(fragrance => 
                            preferences.some(preferredAccord => {
                                const normalizedPreferredAccord = preferredAccord.toLowerCase().trim();
                                return fragrance.accords.some(fragranceAccord => 
                                    fragranceAccord.toLowerCase().trim().includes(normalizedPreferredAccord)
                                );
                            })
                        );
                    console.log(`Found ${accordResults.length} matches for accords:`, preferences);
                    return accordResults;
    
                case 'brand':
                    const brandQuery = query(
                        fragrancesRef, 
                        where('brandName', '==', preferences[0])
                    );
                    querySnapshot = await getDocs(brandQuery);
                    const brandResults = querySnapshot.docs.map(doc => doc.data() as Fragrance);
                    console.log(`Found ${brandResults.length} matches for brand:`, preferences[0]);
                    return brandResults;
    
                default:
                    return [];
            }
        } catch (error) {
            console.error('Error in fetchRecommendations:', error);
            throw new ChatbotError(
                ErrorType.DATABASE,
                'There was an error searching the fragrance database. Please try again.'
            );
        }
    };

    // Update the displayRecommendations function to handle the flow better
    const displayRecommendations = async (
        recommendations: Fragrance[], 
        page: number = 0,
        preferences: string[]
    ) => {
        const pageSize = 5;
        const start = page * pageSize;
        const end = start + pageSize;
        const currentPageRecommendations = recommendations.slice(start, end);
        
        if (currentPageRecommendations.length === 0) {
            addMessage({
                text: "I've shown you all available recommendations.",
                sender: 'bot'
            });
            await askIfAnythingElse();
            return;
        }
    
        let recommendationText = `Here are your recommended fragrances based on your preferred ${recommendationState.category}:\n\n`;
        
        currentPageRecommendations.forEach((fragrance, index) => {
            if (recommendationState.category === 'brand') {
                // For brand category, just show the fragrance name
                recommendationText += `${index + 1}. ${fragrance.fragranceName}\n\n`;
            } else {
                // For notes and accords categories, show both fragrance name and brand
                recommendationText += `${index + 1}. ${fragrance.fragranceName} by ${fragrance.brandName}\n`;
        
                if (recommendationState.category === 'notes') {
                    const normalizedFragranceNotes = fragrance.combNotes.map(note => 
                        note.replace(/^"(.+)"$/, '$1').toLowerCase().trim()
                    );
                    
                    const normalizedPreferences = preferences.map(pref => 
                        pref.toLowerCase().trim()
                    );
        
                    const matchingNotes = normalizedPreferences.filter(pref => 
                        normalizedFragranceNotes.includes(pref)
                    );
        
                    let matchingNotesString = '';
                    if (matchingNotes.length === 1) {
                        matchingNotesString = matchingNotes[0];
                    } else if (matchingNotes.length === 2) {
                        matchingNotesString = `${matchingNotes[0]} and ${matchingNotes[1]}`;
                    } else if (matchingNotes.length > 2) {
                        matchingNotesString = matchingNotes.join(', ');
                    }
        
                    recommendationText += `   (Contains your preferred note(s): ${matchingNotesString})\n`;
                } else if (recommendationState.category === 'accords') {
                    const fragranceAccords = fragrance.accords.map(accord => 
                        accord.toLowerCase().trim()
                    );
                    
                    const normalizedPreferences = preferences.map(pref => 
                        pref.toLowerCase().trim()
                    );
        
                    const matchingAccords = fragranceAccords.filter(accord => 
                        normalizedPreferences.some(pref => accord.includes(pref))
                    );
        
                    if (matchingAccords.length > 0) {
                        let matchingAccordsString = '';
                        if (matchingAccords.length === 1) {
                            matchingAccordsString = matchingAccords[0];
                        } else if (matchingAccords.length === 2) {
                            matchingAccordsString = `${matchingAccords[0]} and ${matchingAccords[1]}`;
                        } else if (matchingAccords.length > 2) {
                            matchingAccordsString = matchingAccords.join(', ');
                        }
        
                        recommendationText += `   (Contains your preferred accord(s): ${matchingAccordsString})\n`;
                    }
                }
                recommendationText += '\n';
            }
        });
    
        addMessage({
            text: recommendationText,
            sender: 'bot'
        });
    
        if (recommendations.length > end) {
            addMessage({
                text: "Would you like to see more recommendations?",
                sender: 'bot',
                options: ['Yes', 'No']
            });
        } else {
            addMessage({
                text: "That's all the recommendations I have based on your preferences.",
                sender: 'bot'
            });
            await askIfAnythingElse();
        }
    };

    const handlePreferencesInput = async (input: string) => {
        setLoading(true);
        setIsTyping(true);
    
        try {
            const preferences = validateAndProcessPreferences(input);
            console.log('Initial preferences:', preferences);
            
            addMessage({
                text: input,
                sender: 'user'
            });
    
            // Store preferences in state
            await setRecommendationState(prev => ({
                ...prev,
                preferences,
                currentPage: 0
            }));
    
            const recommendations = await handleDatabaseQuery(() => 
                fetchRecommendations(preferences)
            );
    
            if (!recommendations || recommendations.length === 0) {
                addMessage({
                    text: `I couldn't find any fragrances containing "${input}". Would you like to try with different ${recommendationState.category}?`,
                    sender: 'bot',
                    options: ['Yes', 'No']
                });
                return;
            }
    
            // Pass both recommendations and preferences to displayRecommendations
            await displayRecommendations(recommendations, 0, preferences);
            setAwaitingPreferences(false);
    
        } catch (err) {
            console.error('Error processing preferences:', err);
            if (err instanceof ChatbotError) {
                addMessage({
                    text: err.message,
                    sender: 'bot'
                });
            }
        } finally {
            setLoading(false);
            setIsTyping(false);
            setCurrentInput('');
        }
    };    

    const findSimilarFragrances = async (searchName: string): Promise<Fragrance[]> => {
        try {
            const fragrancesRef = collection(db, 'Fragrance');
            const querySnapshot = await getDocs(fragrancesRef);
            
            const searchNameSoundex = soundex(searchName.toLowerCase());
            
            return querySnapshot.docs
                .map(doc => doc.data() as Fragrance)
                .filter(fragrance => 
                    soundex(fragrance.fragranceName.toLowerCase()) === searchNameSoundex
                );
        } catch (error) {
            console.error('Error finding similar fragrances:', error);
            throw error;
        }
    };

    const handleFragranceInfoRequest = async (fragranceName: string) => {
        setLoading(true);
        setIsTyping(true);
    
        try {
            if (!fragranceName.trim()) {
                throw new ChatbotError(ErrorType.VALIDATION, 'Please enter a fragrance name');
            }
    
            addMessage({
                text: fragranceName,
                sender: 'user'
            });
    
            const result = await handleDatabaseQuery(async () => {
                const fragrancesRef = collection(db, 'Fragrance');
                const q = query(fragrancesRef, where('fragranceName', '==', fragranceName));
                return getDocs(q);
            });
    
            if (!result.empty) {
                const fragranceData = result.docs[0].data() as Fragrance;
                setSelectedFragrance(fragranceData.fragranceName);
                // Wait for state to update
                await new Promise(resolve => setTimeout(resolve, 100));
                addMessage({
                    text: `Please choose what information you would like to know about ${fragranceData.fragranceName}.`,
                    sender: 'bot',
                    options: ['Brand', 'Notes', 'Accords', 'Description']
                });
            } else {
                const similarFragrances = await findSimilarFragrances(fragranceName);
                
                if (similarFragrances.length > 0) {
                    addMessage({
                        text: `Did you mean ${similarFragrances[0].fragranceName}?`,
                        sender: 'bot',
                        options: ['Yes', 'No']
                    });
                } else {
                    addMessage({
                        text: "I apologize. I was not able to find a fragrance with that name. Would you like to try entering the fragrance name again?",
                        sender: 'bot',
                        options: ['Yes', 'No']
                    });
                }
            }
        } catch (err) {
            if (err instanceof ChatbotError) {
                addMessage({
                    text: err.message,
                    sender: 'bot'
                });
            }
        } finally {
            setLoading(false);
            setIsTyping(false);
            setCurrentInput('');
        }
    };
    
    const askIfAnythingElse = async () => {
        await new Promise(resolve => setTimeout(resolve, 1000));
        addMessage({
            text: "Is there anything else you'd like help with?",
            sender: 'bot',
            options: ['Yes', 'No']
        });
    };
    
    const handleGetFragranceInfo = async (option: FragranceInfoOption) => {
        setLoading(true);
        setIsTyping(true);

        try {
            const result = await handleDatabaseQuery(async () => {
                const fragrancesRef = collection(db, 'Fragrance');
                const q = query(fragrancesRef, where('fragranceName', '==', selectedFragrance));
                return getDocs(q);
            });

            if (!result.empty) {
                const fragranceData = result.docs[0].data() as Fragrance;
                let responseText = '';

                switch (option) {
                    case 'Brand':
                        responseText = `Here is the brand for ${selectedFragrance}:\n\n${fragranceData.brandName}`;
                        break;
                    case 'Notes':
                        responseText = `Here are the notes for ${selectedFragrance}:\n\n` +
                                     `Top Notes: ${fragranceData.notes.top_notes.join(', ')}\n\n` +
                                     `Middle Notes: ${fragranceData.notes.middle_notes.join(', ')}\n\n` +
                                     `Base Notes: ${fragranceData.notes.base_notes.join(', ')}`;
                        break;
                    case 'Accords':
                        responseText = `Here are the accords for ${selectedFragrance}:\n\n${fragranceData.accords.join(', ')}`;
                        break;
                    case 'Description':
                        responseText = `Here is the description for ${selectedFragrance}:\n\n${fragranceData.description}`;
                        break;
                }

                addMessage({ text: responseText, sender: 'bot' });
                await askIfAnythingElse();
            }
        } catch (err) {
            if (err instanceof ChatbotError) {
                addMessage({
                    text: `Error: ${err.message}`,
                    sender: 'bot'
                });
            }
        } finally {
            setLoading(false);
            setIsTyping(false);
        }
    };
    const handleOptionClick = async (option: MessageOptions) => {
        addMessage({ text: option, sender: 'user' });
    
        switch (option) {
            case 'Fragrance Information':
                // Reset all states to ensure clean flow
                setAwaitingPreferences(false);
                setRecommendationState({
                    category: null,
                    preferences: [],
                    currentPage: 0,
                    recommendations: []
                });
                
                setAwaitingFragranceName(true);
                setIsTyping(true);
                await new Promise(resolve => setTimeout(resolve, 1000));
                addMessage({
                    text: "Please enter the name of the fragrance you would like information on.",
                    sender: 'bot'
                });
                setIsTyping(false);
                break;
    
            case 'Recommend Fragrances':
                setIsTyping(true);
                await new Promise(resolve => setTimeout(resolve, 1000));
                addMessage({
                    text: "Please choose a category to base recommendations on:",
                    sender: 'bot',
                    options: ["Notes", "Accords", "Brand"]
                });
                setIsTyping(false);
                break;
    
            case 'Notes':
            case 'Accords':
            case 'Brand':
                // Check which flow we're in
                if (selectedFragrance) {
                    // We're in the Fragrance Information flow
                    await handleGetFragranceInfo(option as FragranceInfoOption);
                } else {
                    // We're in the Recommend Fragrances flow
                    setIsTyping(true);
                    await new Promise(resolve => setTimeout(resolve, 1000));
                    
                    setRecommendationState(prev => ({ 
                        ...prev, 
                        category: option.toLowerCase() as 'notes' | 'accords' | 'brand' 
                    }));
                    setAwaitingPreferences(true);
    
                    const promptText = option === 'Brand'
                        ? "Please enter one brand name to get recommendations."
                        : `Please enter your preferred ${option.toLowerCase()} (you can enter up to 5 ${option.toLowerCase()}, separated by commas).`;
                    
                    addMessage({
                        text: promptText,
                        sender: 'bot'
                    });
                    setIsTyping(false);
                }
                break;
    
            case 'Description':
                await handleGetFragranceInfo(option);
                break;    
    
                case 'Yes':
    if (awaitingPreferences) {
        setIsTyping(true);
        await new Promise(resolve => setTimeout(resolve, 1000));
        const category = recommendationState.category;
        addMessage({
            text: category === 'brand'
                ? "Please enter one brand name to get recommendations."
                : `Please enter your preferred ${category}s (you can enter up to 5 ${category}s, separated by commas).`,
            sender: 'bot'
        });
        setIsTyping(false);
    } else if (messages[messages.length - 1]?.text === "Would you like to see more recommendations?") {
        // We know there are more recommendations because we only show this message if there are more
        const nextPage = recommendationState.currentPage + 1;
        setRecommendationState(prev => ({ ...prev, currentPage: nextPage }));
        await displayRecommendations(
            recommendationState.recommendations,
            nextPage,
            recommendationState.preferences
        );
    } else if (messages[messages.length - 1]?.text.startsWith("Did you mean")) {
        // Handle similar fragrance flow
        const fragranceName = messages[messages.length - 1]?.text.replace("Did you mean ", "").replace("?", "");
        setSelectedFragrance(fragranceName);
        addMessage({
            text: `Please choose what information you would like to know about ${fragranceName}.`,
            sender: 'bot',
            options: ['Brand', 'Notes', 'Accords', 'Description']
        });
    } else {
        // Must be responding to "Is there anything else I can help you with?"
        setAwaitingFragranceName(false);
        setSelectedFragrance('');
        setAwaitingPreferences(false);
        setRecommendationState({
            category: null,
            preferences: [],
            currentPage: 0,
            recommendations: []
        });
        
        setIsTyping(true);
        await new Promise(resolve => setTimeout(resolve, 1000));
        addMessage({
            text: "Please select an option:",
            sender: 'bot',
            options: ["Fragrance Information", "Recommend Fragrances"]
        });
        setIsTyping(false);
    }
    break;

    case 'No':
    // Check if we're responding to "Would you like to see more recommendations?"
    if (messages[messages.length - 1]?.text === "Would you like to see more recommendations?") {
        await askIfAnythingElse();
    } 
    // Check if we're responding to "Is there anything else you'd like help with?"
    // Note: The exact message text must match what's in askIfAnythingElse()
    else if (messages[messages.length - 1]?.text === "Is there anything else you'd like help with?") {
        setAwaitingFragranceName(false);
        setSelectedFragrance('');
        setAwaitingPreferences(false);
        setRecommendationState({
            category: null,
            preferences: [],
            currentPage: 0,
            recommendations: []
        });
        setIsTyping(true);
        await new Promise(resolve => setTimeout(resolve, 1000));
        addMessage({
            text: "Very well. Hopefully you found my help to be beneficial.",
            sender: 'bot'
        });
        await new Promise(resolve => setTimeout(resolve, 1000));
        addMessage({
            text: "Please feel free to close this chat now. Have a great day!",
            sender: 'bot'
        });
        setIsTyping(false);
    }
    // Handle any other "No" responses (like from fragrance info flow)
    else {
        setAwaitingFragranceName(false);
        setSelectedFragrance('');
        setAwaitingPreferences(false);
        setRecommendationState({
            category: null,
            preferences: [],
            currentPage: 0,
            recommendations: []
        });
        await askIfAnythingElse();
    }
    break;
        }
    };
    return (
        <div className="message-container">
            <div className="messages-list">
                {messages.map((message) => (
                    <div
                        key={message.id}
                        className={`message-row ${message.sender === 'bot' ? 'message-row-bot' : 'message-row-user'}`}
                    >
                        <div
                            className={`message-bubble ${
                                message.sender === 'bot' ? 'message-bubble-bot' : 'message-bubble-user'
                            }`}
                        >
                            <p className="message-text">{message.text}</p>
                            {message.options && (
                                <div className="message-options">
                                    {message.options.map((option, optionIndex) => (
                                        <button
                                            key={optionIndex}
                                            onClick={() => handleOptionClick(option)}
                                            disabled={loading || message.timestamp !== lastOptionsTimestamp}
                                            className={`message-option-button ${
                                                loading || message.timestamp !== lastOptionsTimestamp 
                                                    ? 'button-disabled' 
                                                    : ''
                                            }`}
                                        >
                                            {option}
                                        </button>
                                    ))}
                                </div>
                            )}
                        </div>
                    </div>
                ))}
                
                {isTyping && <TypingIndicator />}
                {progress > 0 && <ProgressBar progress={progress} />}
                <div ref={messagesEndRef} />
            </div>

            {(awaitingFragranceName || awaitingPreferences) && (
                <div className="input-container">
                    <input
                        type="text"
                        value={currentInput}
                        onChange={(e: React.ChangeEvent<HTMLInputElement>) => setCurrentInput(e.target.value)}
                        className="text-input"
                        placeholder={awaitingFragranceName ? "Enter fragrance name..." : "Enter your preferences..."}
                        disabled={loading}
                        onKeyPress={(e: React.KeyboardEvent<HTMLInputElement>) => {
                            if (e.key === 'Enter' && !loading) {
                                if (awaitingFragranceName) {
                                    handleFragranceInfoRequest(currentInput);
                                } else if (awaitingPreferences) {
                                    handlePreferencesInput(currentInput);
                                }
                            }
                        }}
                    />
                    <button
                        onClick={() => {
                            if (awaitingFragranceName) {
                                handleFragranceInfoRequest(currentInput);
                            } else if (awaitingPreferences) {
                                handlePreferencesInput(currentInput);
                            }
                        }}
                        disabled={loading}
                        className={`send-button ${loading ? 'button-disabled' : 'button-enabled'}`}
                        aria-label="Send message"
                    >
                        {loading ? (
                            <div className="button-loading">
                                <Loader2 className="loader-icon" />
                                <span>Processing...</span>
                            </div>
                        ) : (
                            'Send'
                        )}
                    </button>
                </div>
            )}
        </div>
    );
};

export default ChatbotWindow;