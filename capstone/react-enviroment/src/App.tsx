// src/App.tsx

import 'bootstrap';
import { Route, BrowserRouter as Router, Routes } from 'react-router-dom';
import ChatApp from './ChatApp';
import Navbar from './components/Navbar';
import { AuthProvider } from './contexts/authContext/AuthProvider';
import About from './pages/About';
import FragrancePage from './pages/FragrancePage';
import Fragrances from './pages/Fragrances';
import Home from './pages/Home';
import YourListsPage from './pages/YourListsPage';
import Aromas from './pages/Aromas';
import AccordDetail from './pages/AccordDetail'; 
import UserProfilePage from './pages/UserProfilePage';
import ProtectedRoute from './components/ProtectedRoute';


// App Component
function App() {
  return (
    <AuthProvider>
      <Router>
        <Navbar />
        <Routes>
          {/* Public Routes */}
          <Route path="/" element={<Home />} />
          <Route path="/fragrances" element={<Fragrances />} />
          <Route path="/aromas" element={<Aromas />} />
          <Route path="/about" element={<About />} />
          <Route path="/profile-page" element={<UserProfilePage />}/>
          <Route path="/fragrance/:id" element={<FragrancePage />} />
          <Route path="/accord/:type" element={<AccordDetail />} />

          {/* Protected Routes */}
          <Route
            path="/your-lists"
            element={
              <ProtectedRoute>
                <YourListsPage />
              </ProtectedRoute>
          }/>

          <Route
            path="/profile"
            element={
              <ProtectedRoute>
                <UserProfilePage />
              </ProtectedRoute>
          }/>

        </Routes>
      </Router>
      <ChatApp />
    </AuthProvider>
  );
}

export default App;

/*
Documentation Summary:
- `App` is the root component of the application, responsible for setting up routing and the authentication context.
- The `AuthProvider` wraps the entire application to provide user authentication state.
- `Router` is used to define different application paths using `Routes` and `Route` components.
- The navigation bar (`Navbar`) is rendered at the top of all pages.
- The `ChatApp` component provides an interactive chat feature for users, rendered outside of routing to be available on all pages.
- The available routes include paths such as `/fragrances`, `/brands`, `/notes`, `/about`, `/your-lists`, and a dynamic route `/fragrance/:id` for individual fragrance details.
*/