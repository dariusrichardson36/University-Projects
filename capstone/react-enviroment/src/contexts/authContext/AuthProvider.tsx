import React, { createContext, useContext, useEffect, useState, ReactNode } from 'react';
import { auth, db } from '../../lib/firebase';
import { onAuthStateChanged, signInWithPopup, signOut, GoogleAuthProvider, User } from 'firebase/auth';
import { doc, getDoc, setDoc, serverTimestamp, updateDoc } from 'firebase/firestore';

interface AuthContextType {
  user: User | null;
  loading: boolean;
  profilePicture: string | null;
  setProfilePicture: (newUrl: string) => void;
  login: () => Promise<void>;
  logout: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [profilePicture, setProfilePictureState] = useState<string | null>(null);
  const [loading, setLoading] = useState<boolean>(true);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, async (firebaseUser) => {
      if (firebaseUser) {
        await handleUserSignIn(firebaseUser);
        const userDocRef = doc(db, 'users', firebaseUser.email!);
        const userDoc = await getDoc(userDocRef);
        if (userDoc.exists()) {
          setProfilePictureState(userDoc.data().profilePicture || null);
        }
      } else {
        setProfilePictureState(null);
      }
      setUser(firebaseUser);
      setLoading(false);
    });
    return () => unsubscribe();
  }, []);

  const handleUserSignIn = async (user: User) => {
    const userDocRef = doc(db, 'users', user.email!);
    const userDoc = await getDoc(userDocRef);

    if (!userDoc.exists()) {
      await setDoc(userDocRef, {
        email: user.email,
        username: user.displayName || 'Anonymous',
        profilePicture: user.photoURL || '/assets/default-avatar.png',
        createdAt: serverTimestamp(),
        favorites: [],
        wishlists: {},
      });
    }
  };

  const setProfilePicture = async (newUrl: string) => {
    if (user?.email) {
      const userDocRef = doc(db, 'users', user.email);
      await updateDoc(userDocRef, { profilePicture: newUrl });
      setProfilePictureState(newUrl);
    }
  };

  const login = async () => {
    const provider = new GoogleAuthProvider();
    await signInWithPopup(auth, provider);
  };

  const logout = async () => {
    await signOut(auth);
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        loading,
        profilePicture,
        setProfilePicture,
        login,
        logout,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
