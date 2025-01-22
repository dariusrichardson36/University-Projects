// src/index.tsx

import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import App from './App.tsx';
import 'bootstrap/dist/css/bootstrap.css';
import './index.css';

// Entry point of the application
// This file sets up the root of the React app and applies global styles.
createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>,
);

/*
Documentation Summary:
- This is the main entry point for the React application.
- It imports the `StrictMode` component from React to help highlight potential issues in the application.
- The `createRoot` function from `react-dom/client` is used to create and render the root element.
- The `App` component is the root component of the application, which is wrapped with `StrictMode` for additional checks during development.
- Global styles are applied through imports of Bootstrap and a custom `index.css` file.
*/
