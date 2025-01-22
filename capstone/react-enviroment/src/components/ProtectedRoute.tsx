import React from 'react';
import { Navigate } from 'react-router-dom';
import { useAuth } from '../contexts/authContext/AuthProvider';
import Loader from './Loader';

interface ProtectedRouteProps {
  children: JSX.Element; // The component/page to render if the user is authenticated
}

const ProtectedRoute: React.FC<ProtectedRouteProps> = ({ children }) => {
  const { user, loading } = useAuth(); // Access user and loading state from AuthProvider

  // Show a loading state while checking authentication status
  if (loading) {
    return <Loader />;
  }

  // Redirect to the homepage (or login page) if the user is not authenticated
  if (!user) {
    return <Navigate to="/" replace />;
  }

  // Render the protected component if the user is authenticated
  return children;
};

export default ProtectedRoute;
