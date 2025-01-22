export interface Fragrance {
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

export const enum MessageOption {
    FragranceInfo = "Fragrance Information",
    FragranceFinder = "Fragrance Finder",
    RecommendFragrances = "Recommend Fragrances",
    Brand = "Brand",
    Notes = "Notes",
    Accords = "Accords",
    Description = "Description",
    Yes = "Yes",
    No = "No"
}

export interface ChatMessage {
    readonly text: string;
    readonly sender: 'bot' | 'user';
    readonly options?: readonly MessageOption[];
}

export const enum ErrorType {
    NETWORK = 'Network Error',
    DATABASE = 'Database Error',
    VALIDATION = 'Validation Error',
    TIMEOUT = 'Timeout Error',
    RATE_LIMIT = 'Rate Limit Error',
    DATA_FORMAT = 'Data Format Error'
}

export class ChatbotError extends Error {
    constructor(public type: ErrorType, message: string) {
        super(message);
        this.name = 'ChatbotError';
    }
}