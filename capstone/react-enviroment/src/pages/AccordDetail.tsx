// src/pages/AccordDetail.tsx

import React from 'react';
import { useParams } from 'react-router-dom';
import './Accords.css'; // Import the CSS file

const AccordDetail: React.FC = () => {
  const { type } = useParams<{ type: string }>();

  // Define data for different accord types
  const accordData: Record<string, { title: string; description: string; videoSrc: string }> = {
    aquatic: {
      title: 'Aquatic Accord',
      description: `Aquatic accords capture the refreshing, revitalizing essence of ocean waves, coastal breezes, and the crisp, invigorating scent of fresh water. 
      These accords often blend ozonic, watery notes with hints of citrus or floral to evoke a feeling of serenity and boundless horizons. 
      The aquatic family aims to remind us of the sea's tranquility, its mystery, and its endless expanses—combining gentle marine facets with 
      a slightly salty minerality that resonates with the idea of a clean, pure environment. Such fragrances are perfect for those seeking 
      a calm yet exhilarating sensation that can transform any day into a breezy ocean escape.`,
      videoSrc: '/AquaticAccord.mp4',
    },
    woody: {
      title: 'Woody Accord',
      description: 'Woody accords evoke a sense of grounding and natural warmth, embodying the essence of majestic forests and sunlit groves. They blend rich, earthy notes from woods like cedarwood, sandalwood, and patchouli, creating a comforting and timeless aroma that lingers gently in the air. Woody scents are often deep, resinous, and slightly smoky, conjuring feelings of coziness and rustic elegance. Perfect for those seeking a connection to nature’s heart, woody accords bring balance, depth, and a hint of mystery, enveloping you in the tranquil embrace of the wilderness.',
      videoSrc: '/WoodAccord.mp4',
    },
    citrus: {
        title: 'Citrus Accord',
        description: 'Citrus accords are bright, fresh, and invigorating, capturing the zestiness of sun-ripened fruits like lemons, oranges, and bergamot. They are known for their sparkling, uplifting quality that energizes the senses, evoking the crispness of a summer morning. These accords bring a clean and lively aroma, perfect for those who seek a burst of freshness and radiance in their fragrance.',
        videoSrc: '/CitrusAccord.mp4',
      },
    floral: {
        title: 'Floral Accord',
        description: 'Floral accords are romantic and enchanting, featuring the delicate fragrance of blossoms like rose, jasmine, lily, and peony. These accords range from soft and powdery to sweet and lush, encapsulating the timeless elegance of blooming gardens. Perfect for those who cherish the beauty of nature, floral scents evoke grace and a gentle charm, making them an enduring favorite in perfumery.',
        videoSrc: '/FloralAccord.mp4',
      },
    green: {
        title: 'Green Accord',
        description: 'Green accords are crisp, natural, and refreshing, reminiscent of freshly cut grass, leaves, and herbs. They embody the lively vibrancy of nature, evoking the essence of lush forests and tranquil meadows. With their clean and slightly aromatic quality, green accords offer a sense of renewal and balance, perfect for those who enjoy a connection to the outdoors and a breath of fresh air.',
        videoSrc: '/GreenAccord.mp4',
      },
    herbal: {
        title: 'Herbal Accord',
        description: 'Herbal accords are aromatic, calming, and earthy, featuring the scents of natural herbs like sage, thyme, basil, and rosemary. They evoke the soothing essence of an herb garden, blending slightly spicy, fresh, and green notes. Herbal accords are perfect for those who appreciate the comforting, natural aromas that bring to mind both culinary delights and the tranquility of nature, offering a sense of relaxation and well-being.',
        videoSrc: '/HerbalAccord.mp4',
      },
    gourmand: {
        title: 'Gourmand Accord',
        description: 'Gourmand accords are rich, indulgent, and delectable, evoking the comforting aromas of desserts and sweet treats. Featuring notes like vanilla, caramel, chocolate, and honey, these accords bring a sense of warmth and deliciousness, often with a hint of spice. Gourmand fragrances are perfect for those who want to embrace a cozy, mouthwatering scent that feels like a delightful indulgence, capturing the essence of sweet confections and culinary delights.',
        videoSrc: '/GourmandAccord.mp4',
      },
    oriental: {
        title: 'Oriental Accord',
        description: 'Oriental accords are warm, exotic, and captivating, blending rich spices, resins, and luxurious florals. These accords often feature notes like amber, vanilla, musk, and incense, creating an opulent and sensual fragrance that lingers. Oriental scents evoke the allure of far-off lands and the mystery of ancient rituals, perfect for those who appreciate a bold, enveloping aroma that embodies both sophistication and passion.',
        videoSrc: '/OrientalAccord.mp4',
      },
  };

  const accord = accordData[type || ''];

  if (!accord) {
    return (
      <div className="container mx-auto py-10 px-4 text-center text-black bg-white min-h-screen">
        <h2 className="text-4xl font-bold">Accord Not Found</h2>
        <p className="text-lg">Sorry, the accord you are looking for does not exist.</p>
      </div>
    );
  }

  return (
    <div className="relative w-full min-h-screen overflow-hidden">
      {/* Video Background */}
      <video
        className="video-background fade-in-video"
        autoPlay
        loop
        muted
        playsInline
      >
        <source src={accord.videoSrc} type="video/mp4" />
        Your browser does not support the video tag.
      </video>

      {/* Content Overlay */}
      <div className="container mx-auto py-6 px-4 text-center">
        <div className="p-6 border-gradient-to-r from-purple-400 via-pink-500 to-red-500 rounded-lg shadow-lg backdrop-blur-md mx-auto mt-20 max-w-4xl border border-white border-opacity-50">
          <h2 className="text-4xl font-bold text-white mb-4">{accord.title}</h2>
          <p className="text-lg text-white font-bold">{accord.description}</p>
        </div>
      </div>
    </div>
  );
};

export default AccordDetail;
