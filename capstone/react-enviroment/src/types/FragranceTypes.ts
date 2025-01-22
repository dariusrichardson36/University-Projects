// src/types/types.ts

// Define the structure of fragrance data used in the application.
export interface FragranceData {
  fragranceName?: string;       // The name of the fragrance.
  brandName?: string;           // The brand of the fragrance.
  perfumer?: string;            // The perfumer who created the fragrance.
  accords?: string[];           // Array of accords associated with the fragrance.
  brandImg?: string;            // URL for the brand's image.
  image?: string;               // URL for the fragrance's image.
  description?: string;         // Description of the fragrance.
  notes?: {                     // Object containing various note categories of the fragrance.
    base_notes?: string[];      // Array of base notes.
    middle_notes?: string[];    // Array of middle notes.
    top_notes?: string[];       // Array of top notes.
  };
  combNotes?: string[];         // Combined list of all notes.
}

// Define the structure for the filter criteria used in filtering fragrances.
export interface FilterCriteria {
  brands: string[];                // Array of selected brands for filtering.
  perfumers: string[];             // Array of selected perfumers for filtering.
  notes: string[];                 // Array of selected notes for filtering.
  accords: string[];               // Array of selected accords for filtering.
  priceRange?: [number, number];   // Optional price range for filtering (min and max values).
}

/*
Documentation Summary:
- `FragranceData` interface defines the structure of a fragrance object used in the application, including properties like `fragranceName`, `brandName`, `image`, `accords`, and categorized notes.
- `FilterCriteria` interface is used to define the structure of filter options available for users, including arrays for selected `brands`, `perfumers`, `notes`, `accords`, and an optional `priceRange`.
*/
