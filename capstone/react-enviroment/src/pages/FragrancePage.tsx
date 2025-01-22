import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import useFragrances from '../hooks/useFragrances';
import { Box, Tabs, Tab, Dialog, DialogTitle, DialogContent, DialogActions, Checkbox, FormControlLabel, Button } from '@mui/material';
import { useAuth } from '../contexts/authContext/AuthProvider';
import { doc, getDoc, updateDoc, arrayUnion } from 'firebase/firestore';
import { db } from '../lib/firebase';

function TabPanel(props: { children?: React.ReactNode; index: number; value: number }) {
  const { children, value, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`tabpanel-${index}`}
      aria-labelledby={`tab-${index}`}
      {...other}
    >
      {value === index && <Box sx={{ p: 3 }}>{children}</Box>}
    </div>
  );
}

const FragrancePage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const { fragrances } = useFragrances();
  const { user } = useAuth();

  const [value, setValue] = useState(0);
  const [modalOpen, setModalOpen] = useState(false);
  const [wishlists, setWishlists] = useState<{ [key: string]: string[] }>({});
  const [selectedWishlists, setSelectedWishlists] = useState<{ [key: string]: boolean }>({});

  // Fetch user's wishlists
  useEffect(() => {
    const fetchWishlists = async () => {
      if (user) {
        const userDocRef = doc(db, 'users', user.email);
        const userDoc = await getDoc(userDocRef);
        if (userDoc.exists()) {
          const userData = userDoc.data();
          setWishlists(userData.wishlists || {});
        }
      }
    };
    fetchWishlists();
  }, [user]);

  // Ensure fragrance exists
  const fragrance = fragrances.find((f) => f.fragranceName === id);

  const handleChange = (_: React.SyntheticEvent, newValue: number) => {
    setValue(newValue);
  };

  const handleModalOpen = () => setModalOpen(true);
  const handleModalClose = () => {
    setModalOpen(false);
    setSelectedWishlists({});
  };

  const handleCheckboxChange = (wishlistName: string) => {
    setSelectedWishlists((prev) => ({
      ...prev,
      [wishlistName]: !prev[wishlistName],
    }));
  };

  // Function to add fragrance to wishlists
  const addToWishlists = async () => {
    if (!user || !id) return;

    const userDocRef = doc(db, 'users', user.email);

    try {
      // Add to selected wishlists
      for (const wishlistName in selectedWishlists) {
        if (selectedWishlists[wishlistName]) {
          await updateDoc(userDocRef, {
            [`wishlists.${wishlistName}`]: arrayUnion(id),
          });
        }
      }

      alert('Fragrance added to selected wishlists!');
    } catch (error) {
      console.error('Error adding fragrance to wishlists:', error);
      alert('Failed to add fragrance. Please try again.');
    } finally {
      handleModalClose();
    }
  };

  // Function to add fragrance to favorites
  const addToFavorites = async () => {
    if (!user || !id) return;

    const userDocRef = doc(db, 'users', user.email);

    try {
      await updateDoc(userDocRef, {
        favorites: arrayUnion(id),
      });

      alert('Fragrance added to favorites!');
    } catch (error) {
      console.error('Error adding fragrance to favorites:', error);
      alert('Failed to add fragrance. Please try again.');
    }
  };

  // Render loading or error state before rendering fragrance details
  if (!id) {
    return <p>Invalid fragrance ID</p>;
  }
  if (!fragrance) {
    return <p>Fragrance not found</p>;
  }

  return (
    <div className="">
      {/* Header Section */}
      <div className="flex items-center w-full mr-32 justify-center">
        <div className="w-1/2 h-full flex items-center justify-center overflow-hidden rounded-lg">
          <img
            src={fragrance.image || '/placeholder.png'}
            alt={fragrance.fragranceName}
            className=""
          />
        </div>
        <div className="mb-32 mt-20 mr-5">
          <h1 className="font-bold text-6xl font-title">{fragrance.fragranceName}</h1>
          <h2 className="text-xl text-gray-600 font-body pb-10 pl-1 pt-2">by {fragrance.brandName}</h2>

          {/* Notes Section */}
          <div className="bg-red-50 w-96 rounded-lg mx-auto outline shadow-2xl">
            {fragrance.notes?.top_notes?.length ? (
              <>
                <div className="pl-1 text-center font-title text-2xl">Top Notes</div>
                <div className="text-center font-body text-gray-500 pt-4 text-lg">
                  {fragrance.notes.top_notes.join(', ')}
                </div>
              </>
            ) : (
              <div className="text-center text-gray-500 pt-4 text-lg">No top notes available.</div>
            )}
            {fragrance.notes?.middle_notes?.length ? (
              <>
                <div className="pl-1 pt-10 text-center font-title text-2xl">Middle Notes</div>
                <div className="text-center font-body text-gray-500 pt-4 text-lg">
                  {fragrance.notes.middle_notes.join(', ')}
                </div>
              </>
            ) : (
              <div className="text-center text-gray-500 pt-4 text-lg">No middle notes available.</div>
            )}
            {fragrance.notes?.base_notes?.length ? (
              <>
                <div className="pl-1 pt-10 text-center font-title text-2xl">Base Notes</div>
                <div className="text-center font-body text-gray-500 pt-4 text-lg">
                  {fragrance.notes.base_notes.join(', ')}
                </div>
              </>
            ) : (
              <div className="text-center text-gray-500 pt-4 text-lg">No base notes available.</div>
            )}
          </div>

          {/* Add to List Buttons */}
          {user && (
            <div className="mt-4">
              <Button
                variant="contained"
                color="secondary"
                onClick={addToFavorites}
                sx={{ mr: 2 }}
              >
                Add to Favorites
              </Button>

              <Button
                variant="contained"
                color="primary"
                onClick={handleModalOpen}
              >
                Add to Wishlists
              </Button>
            </div>
          )}
        </div>
      </div>

      {/* Tabs Section */}
      <div className="mt-10 w-full border-t-2 font-body border-gray-500 bg-gray-100">
        <Box sx={{ width: '100%' }}>
          <Tabs value={value} onChange={handleChange} centered>
            <Tab label="Description" sx={{ fontFamily: 'Roboto Condensed', fontSize: '1.1rem', fontWeight: 'md' }} />
            <Tab label="Where to Buy" sx={{ fontFamily: 'Roboto Condensed', fontSize: '1.1rem', fontWeight: 'md' }} />
          </Tabs>

          <TabPanel value={value} index={0}>            <h1 className="text-center font-bold mt-10 font-title text-4xl">Description</h1>
            <div className="text-center text-xl font-body mt-6 max-w-screen mx-auto px-4">{fragrance.description}</div>
            {/* Perfumer Section */}
            {fragrance.perfumer ? (
              <>
                <h3 className="text-4xl text-center font-title font-bold text-gray-800 mt-10">Perfumer</h3>
                <div className="text-center text-2xl mt-6 font-body text-gray-800">{fragrance.perfumer}</div>
              </>
            ) : (
              <div className="text-center text-gray-500 pt-4 text-lg">No perfumers available.</div>
            )}
            {/* Accords Section */}
            {fragrance.accords?.length ? (
              <>
                <h3 className="text-4xl text-center font-title font-bold text-gray-800 mt-10">Accords</h3>
                <div className="text-center text-2xl mt-6 font-body text-gray-800">
                  {fragrance.accords.map((accord) => accord.charAt(0).toUpperCase() + accord.slice(1)).join(', ')}
                </div>
              </>
            ) : (
              <div className="text-center text-gray-500 pt-4 text-lg">No accords available.</div>
            )}
          </TabPanel>
          <TabPanel value={value} index={1}>
            <div className="text-center text-xl font-body mt-6">Where to Buy content will go here.</div>
          </TabPanel>
        </Box>
      </div>
      {/* Modal for Adding Fragrance to Lists */}
      <Dialog open={modalOpen} onClose={handleModalClose}>
        <DialogTitle>Add "{fragrance.fragranceName}" to Your Wishlists</DialogTitle>
        <DialogContent>
          {Object.keys(wishlists).length === 0 ? (
            <p>No wishlists found. Create one first.</p>
          ) : (
            Object.keys(wishlists).map((wishlistName) => (
              <FormControlLabel
                key={wishlistName}
                control={
                  <Checkbox
                    checked={!!selectedWishlists[wishlistName]}
                    onChange={() => handleCheckboxChange(wishlistName)}
                    color="primary"
                  />
                }
                label={wishlistName}
              />
            ))
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={handleModalClose} color="secondary">
            Cancel
          </Button>
          <Button onClick={addToWishlists} color="primary">
            Add to Wishlists
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
};

export default FragrancePage;
