import React, { useMemo } from 'react';
import { Row, Col } from 'react-bootstrap';
import Fuse from 'fuse.js';
import FragranceCard from './FragranceCard';
import useFragrances from '../hooks/useFragrances';
import { FilterCriteria, FragranceData } from '../types/FragranceTypes';

type FragranceGridProps = {
  filterCriteria: FilterCriteria;
  nameQuery: string;
  currentPage: number;
  itemsPerPage: number;
};

const FragranceGrid: React.FC<FragranceGridProps> = ({ filterCriteria, nameQuery, currentPage, itemsPerPage }) => {
  const { fragrances, loading } = useFragrances();

  // Fuse.js instance for fuzzy searching fragrance names.
  const nameFuse = useMemo(() => new Fuse(fragrances, { keys: ['fragranceName'], threshold: 0.4, distance: 100 }), [fragrances]);

  // Apply fuzzy search if a name query exists, otherwise use the original list.
  const filteredByName = nameQuery
    ? nameFuse.search(nameQuery).map(result => result.item)
    : fragrances;

  // Filter the fragrances based on the filter criteria.
  const filteredFragrances = filteredByName.filter(f => {
    const matchesBrand = filterCriteria.brands.length === 0 || filterCriteria.brands.includes(f.brandName || '');
    const matchesPerfumer = filterCriteria.perfumers.length === 0 || filterCriteria.perfumers.includes(f.perfumer || '');
    const matchesNotes = filterCriteria.notes.length === 0 || filterCriteria.notes.every(note => (f.combNotes || []).includes(note));
    const matchesAccords = filterCriteria.accords.length === 0 || filterCriteria.accords.every(accord => (f.accords || []).includes(accord));

    return matchesBrand && matchesPerfumer && matchesNotes && matchesAccords;
  });

  // Determine the items to display for the current page.
  const startIndex = (currentPage - 1) * itemsPerPage;
  const endIndex = startIndex + itemsPerPage;
  const paginatedFragrances = filteredFragrances.slice(startIndex, endIndex);

  if (loading) return <p>Loading fragrances...</p>;

  return (
    <Row className="gx-4 gy-4" style={{ alignItems: 'stretch' }}>
      {paginatedFragrances.map((fragrance: FragranceData, index) => (
        <Col key={index} sm={6} md={4} lg={3} className="d-flex">
          <FragranceCard fragrance={fragrance} />
        </Col>
      ))}
    </Row>
  );
};

export default FragranceGrid;
