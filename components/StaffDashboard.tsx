'use client';

import { useState } from 'react';
import { demoStudents, calculateGrade } from '@/lib/demo-data';

export default function StaffDashboard({ onSignOut }: { onSignOut?: () => void }) {
  const [activeTab, setActiveTab] = useState<'dashboard' | 'students' | 'marks' | 'send'>('dashboard');
  const [searchQuery, setSearchQuery] = useState('');
  
  // Marks entry state
  const [selectedClass, setSelectedClass] = useState('Form 3 East');
  const [selectedSubject, setSelectedSubject] = useState('Mathematics');
  const [marks, setMarks] = useState<{ [key: string]: number }>({
    '1': 85,
    '2': 72,
    '3': 68,
  });

  const filteredStudents = demoStudents.filter((student) =>
    student.fullName.toLowerCase().includes(searchQuery.toLowerCase()) ||
    student.studentCode.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const handleMarkChange = (studentId: string, value: string) => {
    const numValue = parseInt(value) || 0;
    setMarks({ ...marks, [studentId]: Math.min(100, Math.max(0, numValue)) });
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Desktop Sidebar */}
      <div className="hidden lg:flex">
        <div className="w-64 bg-white border-r border-gray-200 min-h-screen fixed">
          <div className="p-6">
            <div className="flex items-end gap-1 mb-8">
              <div className="w-2 h-8 bg-black"></div>
              <div className="w-2 h-12 bg-emerald-600"></div>
              <div className="w-2 h-16 bg-black"></div>
            </div>

            <nav className="space-y-1">
              <button
                onClick={() => setActiveTab('dashboard')}
                className={`w-full text-left px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                  activeTab === 'dashboard'
                    ? 'bg-emerald-50 text-emerald-600'
                    : 'text-gray-700 hover:bg-gray-100'
                }`}
              >
                Dashboard
              </button>
              <button
                onClick={() => setActiveTab('students')}
                className={`w-full text-left px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                  activeTab === 'students'
                    ? 'bg-emerald-50 text-emerald-600'
                    : 'text-gray-700 hover:bg-gray-100'
                }`}
              >
                Students
              </button>
              <button
                onClick={() => setActiveTab('marks')}
                className={`w-full text-left px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                  activeTab === 'marks'
                    ? 'bg-emerald-50 text-emerald-600'
                    : 'text-gray-700 hover:bg-gray-100'
                }`}
              >
                Marks Entry
              </button>
              <button
                onClick={() => setActiveTab('send')}
                className={`w-full text-left px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                  activeTab === 'send'
                    ? 'bg-emerald-50 text-emerald-600'
                    : 'text-gray-700 hover:bg-gray-100'
                }`}
              >
                Send Reports
              </button>
            </nav>

            {onSignOut && (
              <button
                onClick={onSignOut}
                className="w-full mt-6 px-4 py-2 text-sm text-red-600 hover:bg-red-50 rounded-lg font-medium transition-all"
              >
                Sign Out
              </button>
            )}
          </div>
        </div>

        <div className="ml-64 flex-1">
          <div className="p-8">
            {activeTab === 'dashboard' && <DashboardView />}
            {activeTab === 'students' && (
              <StudentsView
                students={filteredStudents}
                searchQuery={searchQuery}
                setSearchQuery={setSearchQuery}
              />
            )}
            {activeTab === 'marks' && (
              <MarksEntryView
                selectedClass={selectedClass}
                setSelectedClass={setSelectedClass}
                selectedSubject={selectedSubject}
                setSelectedSubject={setSelectedSubject}
                marks={marks}
                handleMarkChange={handleMarkChange}
              />
            )}
            {activeTab === 'send' && <SendReportsView />}
          </div>
        </div>
      </div>

      {/* Mobile View */}
      <div className="lg:hidden">
        <div className="bg-white border-b border-gray-200 p-4">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-end gap-1">
              <div className="w-1.5 h-6 bg-black"></div>
              <div className="w-1.5 h-8 bg-emerald-600"></div>
              <div className="w-1.5 h-10 bg-black"></div>
            </div>
            <div className="flex items-center gap-3">
              <div className="text-sm font-semibold text-gray-900">Staff Portal</div>
              {onSignOut && (
                <button
                  onClick={onSignOut}
                  className="text-xs text-red-600 hover:text-red-700"
                >
                  Sign Out
                </button>
              )}
            </div>
          </div>

          <div className="flex gap-2 overflow-x-auto">
            {['dashboard', 'students', 'marks', 'send'].map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab as any)}
                className={`px-4 py-2 rounded-lg text-sm font-medium whitespace-nowrap ${
                  activeTab === tab
                    ? 'bg-emerald-50 text-emerald-600'
                    : 'text-gray-700 bg-gray-100'
                }`}
              >
                {tab.charAt(0).toUpperCase() + tab.slice(1)}
              </button>
            ))}
          </div>
        </div>

        <div className="p-4">
          {activeTab === 'dashboard' && <DashboardView />}
          {activeTab === 'students' && (
            <StudentsView
              students={filteredStudents}
              searchQuery={searchQuery}
              setSearchQuery={setSearchQuery}
            />
          )}
          {activeTab === 'marks' && (
            <MarksEntryView
              selectedClass={selectedClass}
              setSelectedClass={setSelectedClass}
              selectedSubject={selectedSubject}
              setSelectedSubject={setSelectedSubject}
              marks={marks}
              handleMarkChange={handleMarkChange}
            />
          )}
          {activeTab === 'send' && <SendReportsView />}
        </div>
      </div>
    </div>
  );
}

function DashboardView() {
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-semibold text-gray-900">School Overview</h1>

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="bg-white border border-gray-200 rounded-lg p-4">
          <div className="text-sm text-gray-600 mb-1">Total Students</div>
          <div className="text-3xl font-semibold text-gray-900 tabular-nums">342</div>
        </div>
        <div className="bg-white border border-gray-200 rounded-lg p-4">
          <div className="text-sm text-gray-600 mb-1">Total Teachers</div>
          <div className="text-3xl font-semibold text-gray-900 tabular-nums">28</div>
        </div>
        <div className="bg-white border border-gray-200 rounded-lg p-4">
          <div className="text-sm text-gray-600 mb-1">Classes</div>
          <div className="text-3xl font-semibold text-gray-900 tabular-nums">12</div>
        </div>
        <div className="bg-white border border-gray-200 rounded-lg p-4">
          <div className="text-sm text-gray-600 mb-1">Attendance</div>
          <div className="text-3xl font-semibold text-gray-900 tabular-nums">94%</div>
        </div>
      </div>

      <div className="bg-white border border-gray-200 rounded-lg p-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Recent Admissions</h2>
        <div className="space-y-3">
          {demoStudents.slice(0, 3).map((student) => (
            <div key={student.id} className="flex items-center justify-between py-2 border-b border-gray-100 last:border-0">
              <div>
                <div className="text-sm font-medium text-gray-900">{student.fullName}</div>
                <div className="text-xs text-gray-500">{student.studentCode}</div>
              </div>
              <div className="text-sm text-gray-600">{student.class} {student.stream}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

function StudentsView({
  students,
  searchQuery,
  setSearchQuery,
}: {
  students: typeof demoStudents;
  searchQuery: string;
  setSearchQuery: (q: string) => void;
}) {
  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-semibold text-gray-900">Student Directory</h1>

      <input
        type="text"
        value={searchQuery}
        onChange={(e) => setSearchQuery(e.target.value)}
        placeholder="Search by name or student code..."
        className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent outline-none"
      />

      <div className="bg-white border border-gray-200 rounded-lg divide-y divide-gray-200">
        {students.map((student) => (
          <div key={student.id} className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <div className="text-sm font-semibold text-gray-900">{student.fullName}</div>
                <div className="text-xs text-gray-500 mt-1">{student.studentCode}</div>
              </div>
              <div className="text-right">
                <div className="text-sm text-gray-900">{student.class} {student.stream}</div>
                <div className={`text-xs mt-1 ${student.feesCleared ? 'text-emerald-600' : 'text-red-600'}`}>
                  {student.feesCleared ? 'Fees Cleared' : `Balance: ${student.feesBalance} KES`}
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function MarksEntryView({
  selectedClass,
  setSelectedClass,
  selectedSubject,
  setSelectedSubject,
  marks,
  handleMarkChange,
}: {
  selectedClass: string;
  setSelectedClass: (c: string) => void;
  selectedSubject: string;
  setSelectedSubject: (s: string) => void;
  marks: { [key: string]: number };
  handleMarkChange: (id: string, value: string) => void;
}) {
  const students = demoStudents.filter((s) => `${s.class} ${s.stream}` === selectedClass);

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-semibold text-gray-900">Marks Entry</h1>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Class</label>
          <select
            value={selectedClass}
            onChange={(e) => setSelectedClass(e.target.value)}
            className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent outline-none"
          >
            <option>Form 3 East</option>
            <option>Form 2 West</option>
          </select>
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Subject</label>
          <select
            value={selectedSubject}
            onChange={(e) => setSelectedSubject(e.target.value)}
            className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent outline-none"
          >
            <option>Mathematics</option>
            <option>English</option>
            <option>Kiswahili</option>
            <option>Biology</option>
            <option>Chemistry</option>
            <option>Physics</option>
          </select>
        </div>
      </div>

      <div className="bg-white border border-gray-200 rounded-lg overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50">
              <tr className="border-b border-gray-200">
                <th className="text-left py-3 px-4 text-sm font-semibold text-gray-900">Student</th>
                <th className="text-left py-3 px-4 text-sm font-semibold text-gray-900">Code</th>
                <th className="text-right py-3 px-4 text-sm font-semibold text-gray-900">Mark</th>
                <th className="text-right py-3 px-4 text-sm font-semibold text-gray-900">Grade</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {students.map((student) => {
                const mark = marks[student.id] || 0;
                const grade = calculateGrade(mark);
                return (
                  <tr key={student.id}>
                    <td className="py-3 px-4 text-sm text-gray-900">{student.fullName}</td>
                    <td className="py-3 px-4 text-sm text-gray-600 font-mono">{student.studentCode}</td>
                    <td className="py-3 px-4 text-right">
                      <input
                        type="number"
                        min="0"
                        max="100"
                        value={mark}
                        onChange={(e) => handleMarkChange(student.id, e.target.value)}
                        className="w-20 px-3 py-1 border border-gray-300 rounded text-sm text-right tabular-nums focus:ring-2 focus:ring-emerald-500 focus:border-transparent outline-none"
                      />
                    </td>
                    <td className="py-3 px-4 text-sm font-medium text-gray-900 text-right">{grade}</td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>

      <button className="w-full lg:w-auto px-6 py-3 bg-emerald-600 text-white rounded-lg font-medium hover:bg-emerald-700 transition-colors">
        Save Marks
      </button>
    </div>
  );
}

function SendReportsView() {
  const [selectedMethod, setSelectedMethod] = useState<'push' | 'sms' | 'whatsapp'>('push');

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-semibold text-gray-900">Send Reports</h1>

      <div className="bg-white border border-gray-200 rounded-lg p-6">
        <div className="mb-6">
          <label className="block text-sm font-medium text-gray-700 mb-3">Select Method</label>
          <div className="flex gap-3">
            {['push', 'sms', 'whatsapp'].map((method) => (
              <button
                key={method}
                onClick={() => setSelectedMethod(method as any)}
                className={`flex-1 py-3 px-4 rounded-lg border text-sm font-medium ${
                  selectedMethod === method
                    ? 'border-emerald-600 bg-emerald-50 text-emerald-600'
                    : 'border-gray-300 text-gray-700 hover:border-gray-400'
                }`}
              >
                {method === 'push' ? 'App Push' : method === 'sms' ? 'SMS' : 'WhatsApp'}
              </button>
            ))}
          </div>
        </div>

        <div className="mb-6">
          <label className="block text-sm font-medium text-gray-700 mb-1">Recipients</label>
          <select className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent outline-none">
            <option>All Parents (Form 3 East)</option>
            <option>All Parents (School)</option>
            <option>Parents with Outstanding Fees</option>
          </select>
        </div>

        <div className="mb-6">
          <label className="block text-sm font-medium text-gray-700 mb-1">Message</label>
          <textarea
            rows={4}
            className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent outline-none"
            placeholder="Enter your message here..."
            defaultValue="Dear parent, your child's Term 2 examination results are now available. Login to view the full report card."
          />
        </div>

        <button className="w-full lg:w-auto px-6 py-3 bg-emerald-600 text-white rounded-lg font-medium hover:bg-emerald-700 transition-colors">
          Send to 45 Parents
        </button>
      </div>
    </div>
  );
}
