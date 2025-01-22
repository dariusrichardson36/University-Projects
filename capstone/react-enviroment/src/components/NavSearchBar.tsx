// src/components/NavSearchBar.tsx

import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import useFragrances from '../hooks/useFragrances';
import { FragranceData } from '../types/FragranceTypes';
import Fuse from 'fuse.js';

// Define the props type for the NavSearchBar component.
// - searchQuery: The current search query value.
// - setSearchQuery: A function to update the search query.
interface NavSearchBarProps {
  searchQuery: string;
  setSearchQuery: (query: string) => void;
}

// NavSearchBar Component
// This component renders a search bar in the navigation bar that allows users to search for fragrances by name.
// Props:
// - searchQuery: The current search query input value.
// - setSearchQuery: Function to update the search query.
const NavSearchBar: React.FC<NavSearchBarProps> = ({ searchQuery, setSearchQuery }) => {
  const { fragrances } = useFragrances(); // Hook to get the fragrance data.
  const [suggestions, setSuggestions] = useState<FragranceData[]>([]); // State to store the list of suggestions.

  // Effect to update suggestions whenever the search query or fragrance data changes.
  useEffect(() => {
    if (searchQuery.trim() === '') {
      setSuggestions([]); // Clear suggestions if the search query is empty.
      return;
    }

    // Initialize Fuse.js for fuzzy search on fragrance names.
    const fuse = new Fuse(fragrances, {
      keys: ['fragranceName'],
      threshold: 0.4, // Adjust threshold for more or less fuzzy matches.
    });

    // Get top 3 results from Fuse.js search and set suggestions.
    const results = fuse.search(searchQuery);
    setSuggestions(results.slice(0, 3).map(result => result.item));
  }, [searchQuery, fragrances]);

  return (
    <div className="ml-10 pl-16 flex items-center font-body space-x-2 relative">
      {/* Search Input Field */}
      <input
        type="text"
        className="block w-64 px-4 py-2 border-2 border-gray-700 rounded-md text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-indigo-500"
        placeholder="Search fragrances..."
        value={searchQuery}
        onChange={(e) => setSearchQuery(e.target.value)}
      />
      {/* Search Button */}
      <button
        type="button"
        className="px-4 py-2 bg-white text-gray-900 rounded-md border-2 border-gray-700 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-150 ease-in-out"
      >
        Search
      </button>

      {/* Suggestions Dropdown */}
      {suggestions.length > 0 && (
        <div className="absolute top-full mt-2 w-full bg-white border border-gray-300 rounded-md shadow-lg z-10">
          {suggestions.map((suggestion, index) => (
            <Link
              key={index}
              to={`/fragrance/${suggestion.fragranceName}`}
              className="flex items-center px-4 py-2 hover:bg-gray-100 transition duration-150 ease-in-out"
            >
              {/* Fragrance Image */}
              <img
                src={suggestion.image || '/placeholder.jpg'}
                alt={suggestion.fragranceName}
                className="h-10 w-10 mr-4 rounded-md object-cover"
              />
              {/* Fragrance Name */}
              <span className="text-gray-900 text-sm font-medium">{suggestion.fragranceName}</span>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
};

export default NavSearchBar;

/*
Documentation Summary:
- `NavSearchBar` is a React functional component that renders a search bar in the navigation for searching fragrances.
- It uses `useFragrances` to fetch fragrance data and `Fuse.js` for fuzzy search functionality.
- The search bar includes an input field and a button.
- Suggestions are displayed in a dropdown beneath the search bar, showing up to three matching fragrances.
- Each suggestion includes the fragrance name and an image, linking to the respective fragrance details page.
*/