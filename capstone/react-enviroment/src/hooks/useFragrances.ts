// src/hooks/useFragrances.ts

import { useState, useEffect } from 'react';
import { collection, getDocs } from 'firebase/firestore';
import { db } from '../lib/firebase';
import { FragranceData } from '../types/FragranceTypes';

// Hook to fetch fragrance data from Firestore
// This hook provides an easy way to fetch the fragrance data from the Firestore database.
// It manages the loading state and provides the fetched fragrance data as output.
const useFragrances = () => {
  const [fragrances, setFragrances] = useState<FragranceData[]>([]); // State to store the fetched fragrance data.
  const [loading, setLoading] = useState(true); // State to manage the loading state of the data fetching.

  useEffect(() => {
    // Function to fetch fragrances from Firestore.
    const fetchFragrances = async () => {
      try {
        const fragrancesCollection = collection(db, 'Fragrance'); // Reference to the 'Fragrance' collection in Firestore.
        const fragranceSnapshot = await getDocs(fragrancesCollection); // Fetch all documents from the collection.
        
        // Map documents into FragranceData structure directly.
        const fragranceData = fragranceSnapshot.docs.map(doc => doc.data() as FragranceData);
        
        setFragrances(fragranceData); // Update state with the fetched fragrance data.
        setLoading(false); // Set loading to false once the data is fetched.
      } catch (error) {
        console.error("Error fetching fragrance data:", error); // Log any error that occurs during fetching.
        setLoading(false); // Ensure loading state is set to false even if an error occurs.
      }
    };

    fetchFragrances(); // Call the fetch function when the component mounts.
  }, []);

  // Return the fetched fragrance data and the loading state.
  return { fragrances, loading };
};

export default useFragrances;

/*
Documentation Summary:
- This custom React hook, `useFragrances`, is used to fetch fragrance data from a Firestore database.
- It maintains two states: `fragrances` to store the fetched data, and `loading` to indicate the loading status.
- The hook uses the `useEffect` hook to initiate the fetching process on component mount.
- If fetching is successful, `fragrances` is updated with the data; otherwise, an error message is logged.
- The hook returns an object containing both the `fragrances` array and the `loading` boolean to indicate if the data is still being fetched.
*/
