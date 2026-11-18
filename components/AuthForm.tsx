'use client';

import { useState } from 'react';
import { motion } from 'framer-motion';
import { signInWithEmail, signUpWithEmail } from '@/lib/auth-helpers';
import { useRouter } from 'next/navigation';

interface AuthFormProps {
  mode: 'parent' | 'staff';
  onSuccess?: () => void;
}

export default function AuthForm({ mode, onSuccess }: AuthFormProps) {
  const [isSignUp, setIsSignUp] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [fullName, setFullName] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const router = useRouter();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      if (isSignUp) {
        await signUpWithEmail(
          email,
          password,
          fullName,
          mode === 'parent' ? 'parent' : 'teacher'
        );
        setError('Check your email to confirm your account!');
        setIsSignUp(false);
      } else {
        await signInWithEmail(email, password);
        onSuccess?.();
        router.refresh();
      }
    } catch (err: any) {
      setError(err.message || 'Authentication failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4 }}
      className="bg-white border border-gray-200 rounded-lg p-8"
    >
      <h1 className="text-2xl font-semibold text-gray-900 mb-2">
        {mode === 'parent' ? 'Parent' : 'Staff'} {isSignUp ? 'Sign Up' : 'Login'}
      </h1>
      <p className="text-sm text-gray-600 mb-6">
        {isSignUp
          ? 'Create your account'
          : mode === 'parent'
          ? 'View your child\'s academic progress'
          : 'Access the school management workspace'}
      </p>

      <form onSubmit={handleSubmit} className="space-y-4">
        {isSignUp && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            exit={{ opacity: 0, height: 0 }}
          >
            <label htmlFor="fullName" className="block text-sm font-medium text-gray-700 mb-1">
              Full Name
            </label>
            <input
              type="text"
              id="fullName"
              value={fullName}
              onChange={(e) => setFullName(e.target.value)}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent outline-none transition-all"
              placeholder="John Doe"
              required={isSignUp}
            />
          </motion.div>
        )}

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
            placeholder={mode === 'parent' ? 'parent@example.com' : 'teacher@school.ac.ke'}
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
            minLength={6}
          />
        </div>

        {error && (
          <motion.div
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            className={`text-sm ${
              error.includes('email')
                ? 'text-emerald-600 bg-emerald-50'
                : 'text-red-600 bg-red-50'
            } border ${
              error.includes('email') ? 'border-emerald-200' : 'border-red-200'
            } rounded-lg p-3`}
          >
            {error}
          </motion.div>
        )}

        <motion.button
          type="submit"
          disabled={loading}
          whileHover={{ scale: 1.01 }}
          whileTap={{ scale: 0.99 }}
          className="w-full bg-emerald-600 text-white py-3 rounded-lg font-medium hover:bg-emerald-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {loading ? (
            <span className="flex items-center justify-center gap-2">
              <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24">
                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
              </svg>
              {isSignUp ? 'Creating Account...' : 'Signing In...'}
            </span>
          ) : (
            <>{isSignUp ? 'Create Account' : 'Sign In'}</>
          )}
        </motion.button>
      </form>

      <div className="mt-6 pt-6 border-t border-gray-200">
        <button
          onClick={() => {
            setIsSignUp(!isSignUp);
            setError('');
          }}
          className="text-sm text-emerald-600 hover:text-emerald-700 font-medium"
        >
          {isSignUp ? 'Already have an account? Sign in' : "Don't have an account? Sign up"}
        </button>

        <div className="mt-4">
          <p className="text-xs text-gray-500">
            Demo credentials: <span className="font-mono font-semibold">
              {mode === 'parent' ? 'parent1@demo.school' : 'teacher@demo.school'}
            </span> / <span className="font-mono font-semibold">
              {mode === 'parent' ? 'parent123' : 'teacher123'}
            </span>
          </p>
        </div>
      </div>
    </motion.div>
  );
}
