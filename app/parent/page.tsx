'use client';

import { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { getCurrentUser, getLinkedStudents, signOut } from '@/lib/auth-helpers';
import { validateParentCredentials } from '@/lib/demo-data';
import AuthForm from '@/components/AuthForm';
import ParentDashboard from '@/components/ParentDashboard';

export default function ParentPortal() {
  const [authMode, setAuthMode] = useState<'email' | 'code'>('email');
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [studentId, setStudentId] = useState<string | null>(null);
  const [parentCode, setParentCode] = useState('');
  const [studentCode, setStudentCode] = useState('');
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
        const students = await getLinkedStudents(user.id);
        if (students && students.length > 0) {
          // Check if fees are cleared for first student
          if (students[0].fees_cleared) {
            setStudentId(students[0].id);
            setIsAuthenticated(true);
          } else {
            setError('Fee balance must be cleared to access reports. Please contact the school office.');
          }
        }
      }
    } catch (err) {
      // User not logged in, that's fine
    } finally {
      setLoading(false);
    }
  }

  const handleCodeLogin = (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    const student = validateParentCredentials(parentCode, studentCode);
    
    if (student) {
      if (!student.feesCleared) {
        setError('Fee balance must be cleared to access reports. Please contact the school office.');
        return;
      }
      setStudentId(student.id);
      setIsAuthenticated(true);
    } else {
      setError('Invalid parent code or student code. Please try again.');
    }
  };

  const handleSignOut = async () => {
    try {
      await signOut();
      setIsAuthenticated(false);
      setStudentId(null);
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

  if (isAuthenticated && studentId) {
    return <ParentDashboard studentId={studentId} onSignOut={handleSignOut} />;
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
            Email Login
          </button>
          <button
            onClick={() => setAuthMode('code')}
            className={`flex-1 py-2 px-4 rounded-md text-sm font-medium transition-colors ${
              authMode === 'code'
                ? 'bg-emerald-50 text-emerald-600'
                : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            Code Login
          </button>
        </div>

        {authMode === 'email' ? (
          <AuthForm mode="parent" onSuccess={checkAuth} />
        ) : (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.4 }}
            className="bg-white border border-gray-200 rounded-lg p-8"
          >
            <h1 className="text-2xl font-semibold text-gray-900 mb-2">Parent Login</h1>
            <p className="text-sm text-gray-600 mb-6">Enter your codes to view your child's academic progress</p>

            <form onSubmit={handleCodeLogin} className="space-y-4">
              <div>
                <label htmlFor="parentCode" className="block text-sm font-medium text-gray-700 mb-1">
                  Parent Code
                </label>
                <input
                  type="text"
                  id="parentCode"
                  value={parentCode}
                  onChange={(e) => setParentCode(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent outline-none transition-all"
                  placeholder="PAR2024001"
                  required
                />
              </div>

              <div>
                <label htmlFor="studentCode" className="block text-sm font-medium text-gray-700 mb-1">
                  Student Code
                </label>
                <input
                  type="text"
                  id="studentCode"
                  value={studentCode}
                  onChange={(e) => setStudentCode(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent outline-none transition-all"
                  placeholder="STU2024001"
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
                Access Report
              </motion.button>
            </form>

            <div className="mt-6 pt-6 border-t border-gray-200">
              <p className="text-xs text-gray-500">
                Demo credentials: Parent Code: <span className="font-mono font-semibold">PAR2024001</span>, Student Code: <span className="font-mono font-semibold">STU2024001</span>
              </p>
            </div>
          </motion.div>
        )}
      </div>
    </div>
  );
}
