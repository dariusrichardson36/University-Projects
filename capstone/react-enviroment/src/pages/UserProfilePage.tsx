import React, { useState, useEffect } from 'react';
import { useAuth } from '../contexts/authContext/AuthProvider';
import { db, storage } from '../lib/firebase';
import { doc, getDoc, updateDoc } from 'firebase/firestore';
import { ref, uploadBytes, getDownloadURL } from 'firebase/storage';
import {
  AppBar,
  Toolbar,
  Typography,
  Card,
  CardContent,
  Avatar,
  TextField,
  Button,
  Box,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
} from '@mui/material';
import toast, { Toaster } from 'react-hot-toast';

const UserProfilePage: React.FC = () => {
  const { user, setProfilePicture, profilePicture } = useAuth();
  const [username, setUsername] = useState('');
  const [newUsername, setNewUsername] = useState('');
  const [newProfilePicture, setNewProfilePicture] = useState<File | null>(null);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [previewPicture, setPreviewPicture] = useState<string | null>(null);

  // Fetch the existing user data from Firestore
  useEffect(() => {
    const fetchUserData = async () => {
      if (user) {
        const userDocRef = doc(db, 'users', user.email);
        const userDoc = await getDoc(userDocRef);
        if (userDoc.exists()) {
          const userData = userDoc.data();
          setUsername(userData.username || '');
        }
      }
    };
    fetchUserData();
  }, [user]);

  // Handle username updates
  const handleUsernameUpdate = async () => {
    if (!user || !newUsername.trim()) return;
    const userDocRef = doc(db, 'users', user.email);
    try {
      await updateDoc(userDocRef, { username: newUsername });
      setUsername(newUsername);
      setNewUsername('');
      toast.success('Username updated successfully!');
    } catch (error) {
      console.error('Error updating username:', error);
      toast.error('Failed to update username.');
    }
  };

  // Handle profile picture updates
  const handleProfilePictureUpdate = async () => {
    if (!user || !newProfilePicture) return;
    const storageRef = ref(storage, `profilePictures/${user.email}`);
    try {
      await uploadBytes(storageRef, newProfilePicture);
      const downloadURL = await getDownloadURL(storageRef);

      const userDocRef = doc(db, 'users', user.email);
      await updateDoc(userDocRef, { profilePicture: downloadURL });

      setProfilePicture(downloadURL);
      setNewProfilePicture(null);
      setPreviewPicture(null);
      toast.success('Profile picture updated successfully!');
    } catch (error) {
      console.error('Error updating profile picture:', error);
      toast.error('Failed to update profile picture.');
    }
  };

  const handleSaveChanges = () => {
    if (newUsername.trim()) handleUsernameUpdate();
    if (newProfilePicture) handleProfilePictureUpdate();
    setDialogOpen(false);
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      setNewProfilePicture(e.target.files[0]);
      setPreviewPicture(URL.createObjectURL(e.target.files[0]));
    }
  };

  return (
    <div>
      <Toaster />
      {/* Header */}
      <AppBar position="static" elevation={0} sx={{ bgcolor: 'transparent', boxShadow: 'none' }}>
        <Toolbar>
          <Typography
            variant="h4"
            align="center"
            sx={{
              flexGrow: 1,
              fontFamily: 'Roboto Condensed',
              fontWeight: 'bold',
              color: 'black', // Header text color
            }}
          >
            User Profile
          </Typography>
        </Toolbar>
      </AppBar>

      {/* Profile Card */}
      <Box display="flex" justifyContent="center" alignItems="center" height="100vh" px={2}>
        <Card sx={{ maxWidth: 500, width: '100%' }}>
          <CardContent>
            <Box display="flex" justifyContent="center" mb={2}>
              <Avatar
                src={previewPicture || profilePicture || '/default-avatar.png'}
                alt="Profile Picture"
                sx={{ width: 100, height: 100 }}
              />
            </Box>

            <Box mb={3}>
              <Typography
                variant="h6"
                align="center"
                sx={{ fontFamily: 'Roboto Condensed', fontWeight: 'bold' }}
              >
                Current Username: {username}
              </Typography>
            </Box>

            {/* Profile Picture Input */}
            <Box mb={3}>
              <Button
                variant="outlined"
                component="label"
                fullWidth
                sx={{
                  mb: 1,
                  fontFamily: 'Roboto Condensed',
                  color: '#4F46E5',
                  borderColor: '#4F46E5',
                }}
              >
                Upload New Profile Picture
                <input type="file" hidden onChange={handleFileChange} />
              </Button>
              {previewPicture && (
                <Typography
                  variant="caption"
                  display="block"
                  align="center"
                  sx={{ fontFamily: 'Roboto Condensed', color: '#6B7280' }}
                >
                  Preview: {newProfilePicture?.name}
                </Typography>
              )}
            </Box>

            {/* Username Input */}
            <Box mb={3}>
              <TextField
                label="New Username"
                variant="outlined"
                fullWidth
                value={newUsername}
                onChange={(e) => setNewUsername(e.target.value)}
                sx={{
                  fontFamily: 'Roboto Condensed',
                  '& .MuiInputLabel-root': { fontFamily: 'Roboto Condensed' },
                  '& .MuiInputBase-input': { fontFamily: 'Roboto Condensed' },
                }}
              />
            </Box>

            {/* Save Changes Button */}
            <Button
              variant="contained"
              color="primary"
              fullWidth
              onClick={() => setDialogOpen(true)}
              sx={{
                fontFamily: 'Roboto Condensed',
                bgcolor: '#4338CA',
                '&:hover': { bgcolor: '#3730A3' },
              }}
            >
              Save Changes
            </Button>
          </CardContent>
        </Card>
      </Box>

      {/* Confirmation Dialog */}
      <Dialog open={dialogOpen} onClose={() => setDialogOpen(false)}>
        <DialogTitle sx={{ fontFamily: 'Roboto Condensed' }}>Confirm Changes</DialogTitle>
        <DialogContent>
          <Typography sx={{ fontFamily: 'Roboto Condensed' }}>
            Are you sure you want to save the changes you made to your profile?
          </Typography>
        </DialogContent>
        <DialogActions>
          <Button
            onClick={() => setDialogOpen(false)}
            color="secondary"
            sx={{ fontFamily: 'Roboto Condensed', color: '#6B7280' }}
          >
            Cancel
          </Button>
          <Button
            onClick={handleSaveChanges}
            sx={{
              fontFamily: 'Roboto Condensed',
              bgcolor: '#4338CA',
              color: 'white', // Save button text color
              '&:hover': { bgcolor: '#3730A3' },
            }}
          >
            Save
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
};

export default UserProfilePage;
