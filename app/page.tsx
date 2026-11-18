'use client';

import Link from 'next/link';

export default function HomePage() {
  return (
    <div className="min-h-screen bg-white flex items-center justify-center p-4">
      <div className="max-w-md w-full space-y-8">
        {/* Logo */}
        <div className="flex justify-center">
          <div className="flex items-end gap-1">
            <div className="w-2 h-8 bg-black"></div>
            <div className="w-2 h-12 bg-emerald-600"></div>
            <div className="w-2 h-16 bg-black"></div>
          </div>
        </div>

        {/* Title */}
        <div className="text-center">
          <h1 className="text-3xl font-semibold text-gray-900">School Management</h1>
          <p className="mt-2 text-sm text-gray-600">Select your portal to continue</p>
        </div>

        {/* Portal Selection */}
        <div className="space-y-3">
          <Link 
            href="/parent"
            className="block w-full py-4 px-6 bg-white border border-gray-200 rounded-lg hover:border-emerald-600 hover:shadow-sm transition-all text-center group"
          >
            <div className="text-lg font-medium text-gray-900 group-hover:text-emerald-600">Parent Portal</div>
            <div className="text-sm text-gray-500 mt-1">View your child's academic progress</div>
          </Link>

          <Link 
            href="/faculty-access"
            className="block w-full py-4 px-6 bg-white border border-gray-200 rounded-lg hover:border-emerald-600 hover:shadow-sm transition-all text-center group"
          >
            <div className="text-lg font-medium text-gray-900 group-hover:text-emerald-600">Staff Portal</div>
            <div className="text-sm text-gray-500 mt-1">Manage students and academic records</div>
          </Link>
        </div>
      </div>
    </div>
  );
}
