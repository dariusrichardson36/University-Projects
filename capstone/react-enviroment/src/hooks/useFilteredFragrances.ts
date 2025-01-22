// src/hooks/useFilteredFragrances.ts

import { useMemo } from 'react';
import { FilterCriteria, FragranceData } from '../types/FragranceTypes';

// Hook to filter fragrance data based on user criteria and name query.
// This hook provides a memoized list of filtered fragrances based on the provided filter criteria and search query.
// It also returns the total count of the filtered fragrances.
const useFilteredFragrances = (
  fragrances: FragranceData[], 
  filterCriteria: FilterCriteria, 
  nameQuery: string
) => {
  // Use useMemo to filter the fragrances only when `fragrances`, `filterCriteria`, or `nameQuery` change.
  const filteredFragrances = useMemo(() => {
    return fragrances.filter(f => {
      const matchesName = f.fragranceName?.toLowerCase().includes(nameQuery.toLowerCase()) ?? true;
      const matchesBrand = filterCriteria.brands.length === 0 || filterCriteria.brands.includes(f.brandName || '');
      const matchesPerfumer = filterCriteria.perfumers.length === 0 || filterCriteria.perfumers.includes(f.perfumer || '');
      const matchesNotes = filterCriteria.notes.length === 0 || filterCriteria.notes.every(note => (f.combNotes || []).includes(note));
      const matchesAccords = filterCriteria.accords.length === 0 || filterCriteria.accords.every(accord => (f.accords || []).includes(accord));

      return matchesName && matchesBrand && matchesPerfumer && matchesNotes && matchesAccords;
    });
  }, [fragrances, filterCriteria, nameQuery]);

  // Return the filtered fragrance data and the total count of filtered items.
  return {
    filteredFragrances,
    totalFilteredItems: filteredFragrances.length
  };
};

export default useFilteredFragrances;

/*
Documentation Summary:
- This custom React hook, `useFilteredFragrances`, is used to filter an array of fragrance data based on user-provided criteria and a search query.
- The filtering criteria include `brand`, `perfumer`, `notes`, `accords`, and `nameQuery`.
- The hook uses `useMemo` to memoize the filtered results, ensuring efficient filtering whenever the dependencies (`fragrances`, `filterCriteria`, or `nameQuery`) change.
- The hook returns an object containing the `filteredFragrances` array and the `totalFilteredItems` to indicate the number of filtered fragrances.
*/
