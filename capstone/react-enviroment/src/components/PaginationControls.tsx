// src/components/PaginationControls.tsx

import React from 'react';
import Pagination from 'react-bootstrap/Pagination';

// Define the props type for the PaginationControls component.
// - currentPage: The current active page number.
// - totalPages: The total number of pages available.
// - onPageChange: A callback function triggered when the page changes.
interface PaginationControlsProps {
  currentPage: number;
  totalPages: number;
  onPageChange: (pageNumber: number) => void;
}

// PaginationControls Component
// This component renders pagination controls to navigate through pages of data.
// Props:
// - currentPage: The current active page.
// - totalPages: The total number of pages to navigate through.
// - onPageChange: A function to call when changing pages.
const PaginationControls: React.FC<PaginationControlsProps> = ({ currentPage, totalPages, onPageChange }) => {
  return (
    <Pagination className="mt-4 justify-content-center">
      {/* Previous Button */}
      <Pagination.Prev
        onClick={() => onPageChange(Math.max(currentPage - 1, 1))}
        disabled={currentPage === 1}
      >
        Previous
      </Pagination.Prev>
      
      {/* Page Numbers */}
      {[...Array(totalPages)].map((_, index) => (
        <Pagination.Item
          key={index + 1}
          active={index + 1 === currentPage}
          onClick={() => onPageChange(index + 1)}
        >
          {index + 1}
        </Pagination.Item>
      ))}
      
      {/* Next Button */}
      <Pagination.Next
        onClick={() => onPageChange(currentPage + 1)}
        disabled={currentPage === totalPages}
      >
        Next
      </Pagination.Next>
    </Pagination>
  );
};

export default PaginationControls;

/*
Documentation Summary:
- `PaginationControls` is a React functional component used to render pagination controls for navigating between pages of content.
- It receives `currentPage` (the current active page), `totalPages` (the total number of pages available), and `onPageChange` (a callback function to handle page changes).
- The component uses Bootstrap's `Pagination` to render the controls, which include previous/next buttons and individual page number items.
- The previous button is disabled when on the first page, and the next button is disabled when on the last page.
*/