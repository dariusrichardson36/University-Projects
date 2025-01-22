# Pages Folder

## Purpose

This folder contains all the individual page components for the Scentopedia application.
Each file in this folder represents a different page that users can navigate to based on the URL path (e.g., `/about`, `/notes`, etc.).
The components here are used in conjunction with React Router to define routes and render specific content based on user navigation.

## Structure

- Each file corresponds to a single page component (e.g., `About.tsx` for the About page, `Notes.tsx` for the Notes page).
- Page components are imported into `App.tsx` and mapped to routes using React Router.

## Guidelines

- When adding a new page, create a new `.tsx` file in this folder with the page's name.
- Ensure that the new page component is imported into `App.tsx` and a corresponding route is defined using `<Route>`.
- Keep each page component focused on its specific purpose. 
    If shared components or utilities are needed across pages, they should be placed in the `components` or `utils` folder, respectively.

## Example

If you want to create a new page called `Contact`, follow these steps:
1. Create a file named `Contact.tsx` in this folder.
2. Define the component structure, style it, and add relevant content.
3. Import the component into `App.tsx` and add a new route:
   ```tsx
   <Route path="/contact" element={<Contact />} />
