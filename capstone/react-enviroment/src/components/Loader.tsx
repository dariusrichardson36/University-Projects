import React from 'react';

const Loader: React.FC = () => {
  return (
    <div className="flex flex-col items-center justify-center h-screen bg-gradient-to-r from-indigo-100 via-purple-100 to-indigo-100">
      {/* Logo Spinner */}
      <div className="relative w-20 h-20">
        <img
          src="/favicon.ico"
          alt="Loading..."
          className="w-full h-full animate-spin"
        />

        {/* Pulse Effect */}
        <div className="absolute top-0 left-0 w-20 h-20 bg-indigo-500 rounded-full opacity-30 animate-ping"></div>
      </div>

      {/* Loading Text */}
      <div className="mt-6">
        <p className="text-center text-lg text-indigo-700 font-semibold animate-bounce">
          Fetching the good stuff...
        </p>
      </div>
    </div>
  );
};

export default Loader;
