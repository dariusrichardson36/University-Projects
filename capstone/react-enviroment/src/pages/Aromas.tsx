// src/pages/Aromas.tsx

import React from 'react';
import { useNavigate } from 'react-router-dom';
import './Accords.css'; // Import the existing CSS for styles

interface Accord {
  id: string;
  title: string;
  description: string;
  gradient: string;
}

const accords: Accord[] = [
  {
    id: 'aquatic',
    title: 'Aquatic Accord',
    description: 'Aquatic accords capture the freshness of the sea and water elements.',
    gradient: 'from-purple-400 via-pink-500 to-red-500',
  },
  {
    id: 'woody',
    title: 'Woody Accord',
    description: 'Woody accords evoke warmth and natural richness.',
    gradient: 'from-green-400 to-blue-500',
  },
  {
    id: 'citrus',
    title: 'Citrus Accord',
    description: 'Citrus accords are bright, fresh, and invigorating, featuring zesty notes from lemons, oranges, and bergamot.',
    gradient: 'from-yellow-400 to-orange-500',
  },
  {
    id: 'floral',
    title: 'Floral Accord',
    description: 'Floral accords are romantic and captivating, featuring blooms like rose, jasmine, and lily for a delicate touch.',
    gradient: 'from-pink-400 to-purple-500',
  },
  {
    id: 'green',
    title: 'Green Accord',
    description: 'Green accords are crisp and refreshing, capturing the natural essence of freshly cut grass, leaves, and herbs.',
    gradient: 'from-green-500 to-teal-400',
  },
  {
    id: 'herbal',
    title: 'Herbal Accord',
    description: 'Herbal accords are aromatic and earthy, featuring the fresh scents of herbs like sage and rosemary.',
    gradient: 'from-green-600 to-lime-400',
  },
  {
    id: 'gourmand',
    title: 'Gourmand Accord',
    description: 'Gourmand accords are rich and indulgent, evoking sweet aromas like vanilla, caramel, and chocolate.',
    gradient: 'from-amber-500 to-yellow-400',
  },
  {
    id: 'oriental',
    title: 'Oriental Accord',
    description: 'Oriental accords are warm and exotic, blending rich spices, amber, and musk for a sensual fragrance.',
    gradient: 'from-orange-600 to-red-500',
  }  
];

const Aromas: React.FC = () => {
  const navigate = useNavigate();

  // Navigate to the Accord Detail page
  const goToAccordDetail = (accord: string) => {
    navigate(`/accord/${accord}`);
  };

  return (
    <div className="relative w-full min-h-screen overflow-hidden">
      {/* Video Background */}
      <video className="video-background fade-in-video" autoPlay loop muted playsInline>
        <source src="/AromaAbstract.mp4" type="video/mp4" />
        Your browser does not support the video tag.
      </video>

      {/* Content Overlay */}
      <div className="container mx-auto py-6 px-4 text-center">
        <h2 className="text-4xl font-bold mb-6 text-white drop-shadow-lg">Explore Your Aromas</h2>
        <div className="row g-5 justify-content-center">
          {accords.map((accord) => (
            <div className="col-md-4" key={accord.id}>
              <div
                className={`p-6 border border-gradient-to-r ${accord.gradient} rounded-lg shadow-lg hover:shadow-xl transition-transform transform hover:scale-105 h-full cursor-pointer backdrop-blur-md bg-white bg-opacity-10`}
                onClick={() => goToAccordDetail(accord.id)}
              >
                <h5 className="text-2xl font-bold mb-4 text-white">{accord.title}</h5>
                <p className="text-base font-light text-gray-200">{accord.description}</p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Aromas;
