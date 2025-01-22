// firebase.ts

import { initializeApp } from 'firebase/app';
import { Auth, getAuth } from 'firebase/auth';
import { Firestore, getFirestore } from 'firebase/firestore';
import { FirebaseStorage, getStorage } from 'firebase/storage';

// Firebase configuration object containing API keys and project identifiers.
const firebaseConfig = {
    apiKey: "AIzaSyB2gistUGA6Z3wT32Dt7oZF5BP4-sBQcR0",
    authDomain: "scentopedia-ab22e.firebaseapp.com",
    projectId: "scentopedia-ab22e",
    storageBucket: "scentopedia-ab22e.firebasestorage.app",
    messagingSenderId: "295858152820",
    appId: "1:295858152820:web:70c7f452941191264cf821"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize Firebase services
export const auth: Auth = getAuth(app);
export const db: Firestore = getFirestore(app);
export const storage: FirebaseStorage = getStorage(app);

// Default export for db if needed
export default db;

/*
Documentation Summary:
- This module initializes the Firebase app using the provided configuration (`firebaseConfig`).
- It exports the following Firebase services for use throughout the application:
  1. `auth`: Firebase Authentication service (`getAuth`) - Used for user authentication and related functionalities.
  2. `db`: Firestore Database service (`getFirestore`) - Used to store and retrieve structured data.
  3. `storage`: Firebase Storage service (`getStorage`) - Used to store and manage user-generated content such as images.
*/