// src/components/InfiniteScrollFragrances.tsx

import React, { useEffect, useState } from 'react';
import FragranceCard from './FragranceCard';
import useFragrances from '../hooks/useFragrances';
import { FragranceData } from '../types/FragranceTypes';
import './InfiniteScrollFragrances.css';

// InfiniteScrollFragrances Component
// This component renders a scrolling list of random fragrances.
// It displays 10 random fragrances and repeats them to create a visually continuous scrolling effect.
const InfiniteScrollFragrances: React.FC = () => {
  const { fragrances } = useFragrances(); // Use the `useFragrances` hook to fetch all fragrances.
  const [randomFragrances, setRandomFragrances] = useState<FragranceData[]>([]); // State to store random fragrances.

  useEffect(() => {
    if (fragrances.length > 0) {
      // Shuffle the list of fragrances to get a random order.
      const shuffled = [...fragrances].sort(() => 0.5 - Math.random());
      setRandomFragrances(shuffled.slice(0, 10)); // Get 10 random fragrances to display.
    }
  }, [fragrances]);

  return (
    <div className="scroll-container mt-10 pb-10">
      <div className="scroll-content">
        {/* Render each fragrance twice to create an infinite scrolling effect */}
        {randomFragrances.concat(randomFragrances).map((fragrance: FragranceData, index) => (
          <div
            key={index}
            className="snap-start mx-4 card-wrapper"
            style={{ height: '28rem', width: '18rem', display: 'flex', alignItems: 'stretch' }}
          >
            <FragranceCard fragrance={fragrance} />
          </div>
        ))}
      </div>
    </div>
  );
};

export default InfiniteScrollFragrances;

/*
Documentation Summary:
- `InfiniteScrollFragrances` is a React functional component that displays an infinitely scrolling list of fragrance cards.
- It uses the `useFragrances` hook to fetch fragrance data and selects 10 random fragrances to display.
- The component uses the `useEffect` hook to shuffle the fragrances when they are first fetched.
- The fragrances are rendered twice to create a visually continuous scrolling experience.
- Styling for the scroll container and content is handled by an external CSS file (`InfiniteScrollFragrances.css`).
*/
