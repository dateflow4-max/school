'use client';

import { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { getCurrentUser, getUserProfile, signOut } from '@/lib/auth-helpers';
import { validateStaffCredentials } from '@/lib/demo-data';
import AuthForm from '@/components/AuthForm';
import StaffDashboard from '@/components/StaffDashboard';

export default function StaffPortal() {
  const [authMode, setAuthMode] = useState<'email' | 'demo'>('email');
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  // Check if user is already logged in via Supabase
  useEffect(() => {
    checkAuth();
  }, []);

  async function checkAuth() {
    try {
      const user = await getCurrentUser();
      if (user) {
        const profile = await getUserProfile(user.id);
        if (profile.role === 'teacher' || profile.role === 'admin') {
          if (profile.is_approved) {
            setIsAuthenticated(true);
          } else {
            setError('Your account is pending approval. Please contact the administrator.');
          }
        }
      }
    } catch (err) {
      // User not logged in, that's fine
    } finally {
      setLoading(false);
    }
  }

  const handleDemoLogin = (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    const teacher = validateStaffCredentials(email, password);
    
    if (teacher) {
      setIsAuthenticated(true);
    } else {
      setError('Invalid credentials. Please try again.');
    }
  };

  const handleSignOut = async () => {
    try {
      await signOut();
      setIsAuthenticated(false);
    } catch (err) {
      console.error('Sign out error:', err);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="animate-spin h-8 w-8 border-4 border-emerald-600 border-t-transparent rounded-full"></div>
      </div>
    );
  }

  if (isAuthenticated) {
    return <StaffDashboard onSignOut={handleSignOut} />;
  }

  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center p-4">
      <div className="max-w-md w-full">
        {/* Logo */}
        <motion.div
          initial={{ scale: 0.8, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ duration: 0.5 }}
          className="flex justify-center mb-8"
        >
          <div className="flex items-end gap-1">
            <div className="w-2 h-8 bg-black"></div>
            <div className="w-2 h-12 bg-emerald-600"></div>
            <div className="w-2 h-16 bg-black"></div>
          </div>
        </motion.div>

        {/* Auth Mode Toggle */}
        <div className="flex gap-2 mb-6 bg-white border border-gray-200 rounded-lg p-1">
          <button
            onClick={() => setAuthMode('email')}
            className={`flex-1 py-2 px-4 rounded-md text-sm font-medium transition-colors ${
              authMode === 'email'
                ? 'bg-emerald-50 text-emerald-600'
                : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            Supabase Auth
          </button>
          <button
            onClick={() => setAuthMode('demo')}
            className={`flex-1 py-2 px-4 rounded-md text-sm font-medium transition-colors ${
              authMode === 'demo'
                ? 'bg-emerald-50 text-emerald-600'
                : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            Demo Mode
          </button>
        </div>

        {authMode === 'email' ? (
          <AuthForm mode="staff" onSuccess={checkAuth} />
        ) : (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.4 }}
            className="bg-white border border-gray-200 rounded-lg p-8"
          >
            <h1 className="text-2xl font-semibold text-gray-900 mb-2">Staff Login (Demo)</h1>
            <p className="text-sm text-gray-600 mb-6">Access the school management workspace</p>

            <form onSubmit={handleDemoLogin} className="space-y-4">
              <div>
                <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-1">
                  Email Address
                </label>
                <input
                  type="email"
                  id="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent outline-none transition-all"
                  placeholder="teacher@school.ac.ke"
                  required
                />
              </div>

              <div>
                <label htmlFor="password" className="block text-sm font-medium text-gray-700 mb-1">
                  Password
                </label>
                <input
                  type="password"
                  id="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent outline-none transition-all"
                  placeholder="Enter your password"
                  required
                />
              </div>

              {error && (
                <motion.div
                  initial={{ opacity: 0, y: -10 }}
                  animate={{ opacity: 1, y: 0 }}
                  className="text-sm text-red-600 bg-red-50 border border-red-200 rounded-lg p-3"
                >
                  {error}
                </motion.div>
              )}

              <motion.button
                type="submit"
                whileHover={{ scale: 1.01 }}
                whileTap={{ scale: 0.99 }}
                className="w-full bg-emerald-600 text-white py-3 rounded-lg font-medium hover:bg-emerald-700 transition-colors"
              >
                Sign In
              </motion.button>
            </form>

            <div className="mt-6 pt-6 border-t border-gray-200">
              <p className="text-xs text-gray-500">
                Demo credentials: Any email with password <span className="font-mono font-semibold">demo123</span>
              </p>
            </div>
          </motion.div>
        )}
      </div>
    </div>
  );
}
