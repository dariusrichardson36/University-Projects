// src/components/FragranceCard.tsx

import React from 'react';
import { Card, Button } from 'react-bootstrap';
import { useNavigate } from 'react-router-dom';
import { FragranceData } from '../types/FragranceTypes';

// Define the props type for the FragranceCard component.
// - fragrance: Contains the data for a specific fragrance.
type FragranceCardProps = {
  fragrance: FragranceData;
};

// FragranceCard Component
// This component is a React functional component that displays a card containing details about a fragrance.
// Props:
// - fragrance: The fragrance data that includes properties such as fragranceName, brandName, and image.
const FragranceCard: React.FC<FragranceCardProps> = ({ fragrance }) => {
  // useNavigate hook is used to navigate to the detailed page of a fragrance.
  const navigate = useNavigate();

  // Function to handle the click event on the image, navigating to the fragrance details page.
  const handleImageClick = () => {
    navigate(`/fragrance/${fragrance.fragranceName}`); // Use document ID (fragranceName) for routing
  };

  return (
    <Card className="m-3 shadow-md font-title text-center" style={{ width: '18rem' }}>
      {/* Image Button */}
      <Button variant="link" onClick={handleImageClick} className="p-0 border-0">
        <Card.Img variant="top" src={fragrance.image || '/placeholder.jpg'} alt={fragrance.fragranceName} />
      </Button>
      <Card.Body>
        {/* Fragrance Name */}
        <Card.Title>{fragrance.fragranceName}</Card.Title>
        {/* Brand */}
        <p>{fragrance.brandName}</p>
      </Card.Body>
    </Card>
  );
};

export default FragranceCard;

/*
Documentation Summary:
- This component displays a single fragrance card, which includes an image, fragrance name, and brand name.
- When the user clicks on the image, they are navigated to a detailed page of the fragrance using React Router's `useNavigate` hook.
- The fragrance card uses Bootstrap components for styling, such as `Card` and `Button`.
- If no image is provided for the fragrance, a placeholder image is used instead.
*/
