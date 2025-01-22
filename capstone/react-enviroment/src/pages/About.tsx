// src/pages/About.tsx

import React from 'react';
import './About.css';

// About Component
// This component renders information about Scentopedia, including its origins and purpose.
const About: React.FC = () => {
    return (
        <div className="about-container">
            <h2 className="about-heading">About Scentopedia</h2>
            <p className="about-text">
            Welcome to Scentopedia, a fragrance discovery platform created by five friends who are passionate about scents. We believe that every man deserves to find a signature scent that reflects his personality, style, and confidence. Our platform is designed to make discovering, exploring, and choosing the perfect fragrance an enjoyable and tailored experience, with options ranging from timeless classics to modern innovations.
            </p>
        </div>
    );
};

export default About;

/*
Documentation Summary:
- `About` is a React functional component that renders the "About Scentopedia" section.
- It includes a heading and a paragraph of text that introduces users to the Scentopedia platform.
- The component uses styles defined in the `About.css` file to style its content.
*/