import { Disclosure } from '@headlessui/react';
import { Bars3Icon, XMarkIcon } from '@heroicons/react/24/outline';
import { Link, useLocation } from 'react-router-dom';
import { useAuth } from '../contexts/authContext/AuthProvider';
import { useState } from 'react';
import NavSearchBar from './NavSearchBar';

const navigation = [
  { name: 'Fragrances', href: '/fragrances' },
  { name: 'Aromas', href: '/aromas' },
  { name: 'About', href: '/about' },
];

function classNames(...classes: string[]) {
  return classes.filter(Boolean).join(' ');
}

export default function Navbar() {
  const location = useLocation();
  const { user, loading, login, logout, profilePicture } = useAuth();
  const [searchQuery, setSearchQuery] = useState('');

  return (
    <Disclosure as="nav" className="bg-white h-24">
      <div className="border-b-2 border-gray-400 w-full absolute left-0 top-0">
        <div className="mx-auto max-w-7xl px-2 sm:px-6 lg:px-8 relative">
          <div className="relative flex h-24 items-center justify-between">
            <div className="absolute inset-y-0 left-0 flex items-center sm:hidden">
              <Disclosure.Button className="group relative inline-flex items-center justify-center rounded-md p-2 text-gray-400 hover:bg-gray-700 hover:text-white focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white">
                <span className="sr-only">Open main menu</span>
                <Bars3Icon aria-hidden="true" className="block h-6 w-6 group-data-[open]:hidden" />
                <XMarkIcon aria-hidden="true" className="hidden h-6 w-6 group-data-[open]:block" />
              </Disclosure.Button>
            </div>

            {/* Home Link */}
            <div className="flex flex-1 items-center justify-center sm:items-stretch sm:justify-start">
              <Link to="/" className="flex flex-shrink-0 items-center">
                <span className="text-4xl mr-5 font-semibold text-black font-title hover:bg-gray-200 p-2 rounded-md">
                  SCENTOPEDIA
                </span>
              </Link>
              <div className="hidden sm:ml-6 sm:flex sm:space-x-4 items-center">
                {/* Navigation Links */}
                <div className="flex space-x-4">
                  {navigation.map((item) => (
                    <Link
                      key={item.name}
                      to={item.href}
                      className={classNames(
                        location.pathname === item.href
                          ? 'bg-gray-900 text-white'
                          : 'text-gray-900 hover:bg-gray-500 hover:text-white',
                        'rounded-md px-3 py-2 text-xl font-medium font-title transition duration-150 ease-in-out'
                      )}
                    >
                      {item.name}
                    </Link>
                  ))}

                  {/* Show 'Your Lists' link only if user is logged in */}
                  {user && (
                    <Link
                      to="/your-lists"
                      className={classNames(
                        location.pathname === '/your-lists'
                          ? 'bg-gray-900 text-white'
                          : 'text-gray-900 hover:bg-gray-500 hover:text-white',
                        'rounded-md px-3 py-2 text-xl font-medium font-title transition duration-150 ease-in-out'
                      )}
                    >
                      Your Lists
                    </Link>
                  )}
                </div>
              </div>

              {/* Nav Search Bar */}
              <NavSearchBar searchQuery={searchQuery} setSearchQuery={setSearchQuery} />
            </div>

            {/* User Profile Section */}
            <div className="absolute inset-y-0 right-0 flex items-center pr-2 sm:static sm:inset-auto sm:ml-6 sm:pr-0">
              {loading ? (
                <span className="text-gray-900 font-semibold font-lg ml-10">Loading...</span>
              ) : user ? (
                <>
                  {profilePicture ? (
                    <Link to="/profile">
                      <img
                        src={profilePicture}
                        alt="Profile"
                        className="h-8 w-8 rounded-full cursor-pointer hover:ring-2 hover:ring-indigo-500 transition duration-150 ease-in-out"
                      />
                    </Link>
                  ) : (
                    <Link to="/profile">
                      <span className="text-gray-900 font-semibold font-lg">Profile</span>
                    </Link>
                  )}
                  <button
                    onClick={logout}
                    className="text-gray-900 font-semibold font-lg ml-4 px-3 py-2 bg-gray-100 rounded-md hover:bg-gray-300 transition duration-150 ease-in-out"
                  >
                    Sign Out
                  </button>
                </>
              ) : (
                <button
                  onClick={login}
                  className="text-gray-900 text-lg font-xl ml-10 px-3 font-title py-2 bg-gray-100 rounded-md hover:bg-gray-300 transition duration-150 ease-in-out"
                >
                  Login
                </button>
              )}
            </div>
          </div>
        </div>
      </div>
    </Disclosure>
  );
}
