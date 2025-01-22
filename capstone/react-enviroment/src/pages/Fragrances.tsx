// src/pages/Fragrances.tsx
import React, { useState } from 'react';
import FilteredList from '../components/FilteredList';
import FragranceGrid from '../components/FragranceGrid';
import PaginationControls from '../components/PaginationControls';
import { FilterCriteria } from '../types/FragranceTypes';
import useFragrances from '../hooks/useFragrances';
import useFilteredFragrances from '../hooks/useFilteredFragrances';

const Fragrances: React.FC = () => {
  const [filterCriteria, setFilterCriteria] = useState<FilterCriteria>({ brands: [], perfumers: [], notes: [], accords: [] });
  const [nameQuery, setNameQuery] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 8;
  const { fragrances, loading } = useFragrances();

  const { filteredFragrances, totalFilteredItems } = useFilteredFragrances(fragrances, filterCriteria, nameQuery);
  const totalPages = Math.ceil(totalFilteredItems / itemsPerPage);

  const handleFilterChange = (criteria: FilterCriteria) => {
    setFilterCriteria(criteria);
    setCurrentPage(1);  // Reset to the first page when filters are changed
  };

  const handlePageChange = (pageNumber: number) => {
    setCurrentPage(pageNumber);
  };

  return (
    <div className="w-full mx-auto px-4 py-10">
      <h2 className="text-4xl mb-8 font-title text-center">Fragrances</h2>
      
      <div className="flex flex-col md:flex-row">
        {/* Filter Sidebar */}
        <div className="md:w-1/4 mb-8 md:mb-0 md:mr-8 sticky top-4 self-start">
          <FilteredList 
            onFilterChange={handleFilterChange}
            onNameQueryChange={setNameQuery}
          />
        </div>
        
        {/* Fragrance Grid and Pagination */}
        <div className="md:w-3/4">
          <FragranceGrid 
            filterCriteria={filterCriteria} 
            nameQuery={nameQuery} 
            currentPage={currentPage}
            itemsPerPage={itemsPerPage}
          />

          {!loading && totalPages > 1 && (
            <PaginationControls 
              currentPage={currentPage}
              totalPages={totalPages}
              onPageChange={handlePageChange}
            />
          )}
        </div>
      </div>
    </div>
  );
};

export default Fragrances;
