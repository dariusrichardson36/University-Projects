// src/components/FilteredList.tsx

import React, { useState, useMemo } from 'react';
import { Accordion, ListGroup, Form, InputGroup, FormControl } from 'react-bootstrap';
import Fuse from 'fuse.js';
import useFragrances from '../hooks/useFragrances';
import { FilterCriteria } from '../types/FragranceTypes';

// FilterSection Component
// This component is a memoized React functional component that represents each filterable section within the FilteredList component.
// Props:
// - title: The title of the section (e.g., "Brand", "Perfumer", etc.).
// - items: The array of filterable items (e.g., brands, perfumers, notes, etc.).
// - selectedItems: The items currently selected by the user for this section.
// - onChange: A callback function that updates the selected items when the user checks/unchecks a checkbox.
// - searchQuery: The current value of the search query for this filter section.
// - onSearchChange: A callback function that updates the search query value.
const FilterSection: React.FC<{ 
  title: string; 
  items: string[]; 
  selectedItems: string[]; 
  onChange: (item: string) => void; 
  searchQuery: string; 
  onSearchChange: (query: string) => void; 
}> = React.memo(({ title, items, selectedItems, onChange, searchQuery, onSearchChange }) => {
  // Initialize Fuse.js for searching items with a threshold of 0.4 and a distance of 100.
  const fuse = useMemo(() => new Fuse(items, { threshold: 0.4, distance: 100 }), [items]);
  // Filter items based on the search query. If there is a search query, use Fuse.js to get the relevant items.
  const filteredItems = searchQuery ? fuse.search(searchQuery).map(result => result.item) : items;

  return (
    <Accordion.Item eventKey={title}>
      <Accordion.Header>{title}</Accordion.Header>
      <Accordion.Body>
        <InputGroup className="mb-3">
          <FormControl
            placeholder={`Search ${title}`}
            value={searchQuery}
            onChange={(e) => onSearchChange(e.target.value)}
          />
        </InputGroup>
        <ListGroup className="overflow-auto" style={{ maxHeight: '150px' }}>
          {filteredItems.map((item, index) => (
            <ListGroup.Item key={index}>
              <Form.Check
                type="checkbox"
                label={item}
                checked={selectedItems.includes(item)}
                onChange={() => onChange(item)}
              />
            </ListGroup.Item>
          ))}
        </ListGroup>
      </Accordion.Body>
    </Accordion.Item>
  );
});

// FilteredList Component
// This component is responsible for rendering the entire filter section.
// Props:
// - onFilterChange: A callback function that passes the updated filter criteria to the parent component when changes are made.
// - onNameQueryChange: A callback function that updates the search query for the fragrance name.
const FilteredList: React.FC<{ onFilterChange: (criteria: FilterCriteria) => void; onNameQueryChange: (query: string) => void; }> = ({ onFilterChange, onNameQueryChange }) => {
  // useFragrances hook provides the fragrances data and the loading state.
  const { fragrances, loading } = useFragrances();

  // Memoized arrays for brands, perfumers, notes, and accords based on the fragrances data.
  const brands = useMemo(() => [...new Set(fragrances.map(f => f.brandName).filter(Boolean) as string[])], [fragrances]);
  const perfumers = useMemo(() => [...new Set(fragrances.map(f => f.perfumer).filter(Boolean) as string[])], [fragrances]);
  const notes = useMemo(() => [...new Set(fragrances.flatMap(f => f.combNotes || []))], [fragrances]);
  const accords = useMemo(() => [...new Set(fragrances.flatMap(f => f.accords ?? []))], [fragrances]);

  // State to keep track of the selected filter criteria.
  const [filterCriteria, setFilterCriteria] = useState<FilterCriteria>({ brands: [], perfumers: [], notes: [], accords: [] });
  // State to keep track of search queries for each filter section.
  const [searchQueries, setSearchQueries] = useState({ brands: '', perfumers: '', notes: '', accords: '' });
  // State to keep track of the fragrance name search query.
  const [nameQuery, setNameQuery] = useState('');

  // Function to handle the checkbox change in each filter section.
  const handleCheckboxChange = (type: keyof FilterCriteria, item: string) => {
    setFilterCriteria(prev => {
      const selectedItems = (prev[type] || []) as string[];
      const updatedItems = selectedItems.includes(item)
        ? selectedItems.filter(i => i !== item)
        : [...selectedItems, item];
      
      const updatedCriteria = { ...prev, [type]: updatedItems };
      onFilterChange(updatedCriteria);
      return updatedCriteria;
    });
  };

  // Function to handle the search query change in each filter section.
  const handleSearchChange = (type: keyof typeof searchQueries, query: string) => {
    setSearchQueries(prev => ({ ...prev, [type]: query }));
  };

  // Function to handle the fragrance name search query change.
  const handleNameQueryChange = (query: string) => {
    setNameQuery(query);
    onNameQueryChange(query);
  };

  if (loading) return <p>Loading fragrances...</p>;

  return (
    <div className="container mt-4">
      <h3 className="font-title text-3xl">Discover Your Fragrance</h3>
      {/* Fragrance Name Search Bar */}
      <InputGroup className="mb-3">
        <FormControl
          placeholder="Search Fragrance Names"
          value={nameQuery}
          onChange={(e) => handleNameQueryChange(e.target.value)}
        />
      </InputGroup>
      <div className="font-body text-black">
        <Accordion defaultActiveKey="0" alwaysOpen>
          <FilterSection
            title="Brand"
            items={brands}
            selectedItems={filterCriteria.brands}
            onChange={(item) => handleCheckboxChange('brands', item)}
            searchQuery={searchQueries.brands}
            onSearchChange={(query) => handleSearchChange('brands', query)}
          />
          <FilterSection
            title="Perfumer"
            items={perfumers}
            selectedItems={filterCriteria.perfumers}
            onChange={(item) => handleCheckboxChange('perfumers', item)}
            searchQuery={searchQueries.perfumers}
            onSearchChange={(query) => handleSearchChange('perfumers', query)}
          />
          <FilterSection
            title="Notes"
            items={notes}
            selectedItems={filterCriteria.notes}
            onChange={(item) => handleCheckboxChange('notes', item)}
            searchQuery={searchQueries.notes}
            onSearchChange={(query) => handleSearchChange('notes', query)}
          />
          <FilterSection
            title="Accords"
            items={accords}
            selectedItems={filterCriteria.accords}
            onChange={(item) => handleCheckboxChange('accords', item)}
            searchQuery={searchQueries.accords}
            onSearchChange={(query) => handleSearchChange('accords', query)}
          />
        </Accordion>
      </div>
    </div>
  );
};

export default FilteredList;
