'use client';

import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { demoStudents, getStudentReport, getSchoolMessages } from '@/lib/demo-data';

interface Props {
  studentId: string;
  onSignOut?: () => void;
}

export default function ParentDashboard({ studentId, onSignOut }: Props) {
  const [activeTab, setActiveTab] = useState<'overview' | 'messages' | 'report'>('overview');
  
  const student = demoStudents.find((s) => s.id === studentId);
  const report = getStudentReport(studentId);
  const messages = getSchoolMessages();

  if (!student || !report) {
    return <div>Student data not found</div>;
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Mobile Header */}
      <motion.div
        initial={{ y: -20, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        className="lg:hidden bg-white border-b border-gray-200 p-4"
      >
        <div className="flex items-center justify-between">
          <div className="flex items-end gap-1">
            <div className="w-1.5 h-6 bg-black"></div>
            <div className="w-1.5 h-8 bg-emerald-600"></div>
            <div className="w-1.5 h-10 bg-black"></div>
          </div>
          <div className="text-right flex items-center gap-3">
            <div>
              <div className="text-sm font-semibold text-gray-900">{student.fullName}</div>
              <div className="text-xs text-gray-500">{student.class} {student.stream}</div>
            </div>
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
      </motion.div>

      {/* Desktop Header */}
      <motion.div
        initial={{ y: -20, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        className="hidden lg:block bg-white border-b border-gray-200"
      >
        <div className="max-w-7xl mx-auto px-8 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className="flex items-end gap-1">
                <div className="w-2 h-8 bg-black"></div>
                <div className="w-2 h-12 bg-emerald-600"></div>
                <div className="w-2 h-16 bg-black"></div>
              </div>
              <div>
                <div className="text-lg font-semibold text-gray-900">{student.fullName}</div>
                <div className="text-sm text-gray-500">{student.class} {student.stream} • {student.studentCode}</div>
              </div>
            </div>
            <div className="flex items-center gap-6">
              <nav className="flex gap-6">
                <button
                  onClick={() => setActiveTab('overview')}
                  className={`text-sm font-medium pb-1 border-b-2 transition-colors ${
                    activeTab === 'overview'
                      ? 'text-emerald-600 border-emerald-600'
                      : 'text-gray-600 border-transparent hover:text-gray-900'
                  }`}
                >
                  Overview
                </button>
                <button
                  onClick={() => setActiveTab('messages')}
                  className={`text-sm font-medium pb-1 border-b-2 transition-colors ${
                    activeTab === 'messages'
                      ? 'text-emerald-600 border-emerald-600'
                      : 'text-gray-600 border-transparent hover:text-gray-900'
                  }`}
                >
                  Messages
                </button>
                <button
                  onClick={() => setActiveTab('report')}
                  className={`text-sm font-medium pb-1 border-b-2 transition-colors ${
                    activeTab === 'report'
                      ? 'text-emerald-600 border-emerald-600'
                      : 'text-gray-600 border-transparent hover:text-gray-900'
                  }`}
                >
                  Full Report
                </button>
              </nav>
              {onSignOut && (
                <button
                  onClick={onSignOut}
                  className="text-sm text-red-600 hover:text-red-700 font-medium"
                >
                  Sign Out
                </button>
              )}
            </div>
          </div>
        </div>
      </motion.div>

      {/* Content */}
      <div className="max-w-7xl mx-auto p-4 lg:p-8">
        <AnimatePresence mode="wait">
          {activeTab === 'overview' && (
            <motion.div
              key="overview"
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: 20 }}
              transition={{ duration: 0.3 }}
              className="space-y-4"
            >
            {/* Performance Card */}
            <div className="bg-white border border-gray-200 rounded-lg p-6">
              <h2 className="text-lg font-semibold text-gray-900 mb-4">{report.term} {report.year} Performance</h2>
              
              <div className="grid grid-cols-3 gap-4 mb-6">
                <div>
                  <div className="text-sm text-gray-600 mb-1">Overall Average</div>
                  <div className="text-3xl font-semibold text-gray-900 tabular-nums">{report.overallAverage}%</div>
                </div>
                <div>
                  <div className="text-sm text-gray-600 mb-1">Class Position</div>
                  <div className="text-3xl font-semibold text-gray-900 tabular-nums">{report.classRank}/{report.totalStudents}</div>
                </div>
                <div>
                  <div className="text-sm text-gray-600 mb-1">Attendance</div>
                  <div className="text-3xl font-semibold text-gray-900 tabular-nums">{report.attendance.present}/{report.attendance.total}</div>
                </div>
              </div>

              {/* Subject Performance */}
              <div className="space-y-3">
                <div className="text-sm font-medium text-gray-700">Subject Performance</div>
                {report.subjects.map((subject) => (
                  <div key={subject.subject} className="flex items-center justify-between py-2 border-b border-gray-100 last:border-0">
                    <div className="flex-1">
                      <div className="text-sm font-medium text-gray-900">{subject.subject}</div>
                    </div>
                    <div className="flex items-center gap-4">
                      <div className="text-sm tabular-nums text-gray-600">{subject.currentMark}%</div>
                      <div className="text-sm font-medium text-gray-900">{subject.grade}</div>
                      <div className={`text-sm tabular-nums ${
                        subject.change > 0 ? 'text-emerald-600' : subject.change < 0 ? 'text-red-600' : 'text-gray-500'
                      }`}>
                        {subject.change > 0 ? '+' : ''}{subject.change}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </motion.div>
        )}

        {activeTab === 'messages' && (
          <motion.div
            key="messages"
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: 20 }}
            transition={{ duration: 0.3 }}
            className="space-y-3"
          >
            {messages.map((message) => (
              <div key={message.id} className="bg-white border border-gray-200 rounded-lg p-4">
                <div className="flex items-start justify-between mb-2">
                  <div className="text-sm font-semibold text-gray-900">{message.title}</div>
                  <div className={`text-xs px-2 py-1 rounded ${
                    message.type === 'App' ? 'bg-emerald-100 text-emerald-700' :
                    message.type === 'SMS' ? 'bg-blue-100 text-blue-700' :
                    'bg-green-100 text-green-700'
                  }`}>
                    {message.type}
                  </div>
                </div>
                <div className="text-sm text-gray-600 mb-2">{message.message}</div>
                <div className="text-xs text-gray-500">{new Date(message.date).toLocaleDateString()}</div>
              </div>
            ))}
          </motion.div>
        )}

        {activeTab === 'report' && (
          <motion.div
            key="report"
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: 20 }}
            transition={{ duration: 0.3 }}
            className="bg-white border border-gray-200 rounded-lg p-6 lg:p-8"
          >
            <div className="text-center mb-8">
              <h1 className="text-2xl font-semibold text-gray-900">{report.term} {report.year} Report Card</h1>
              <div className="text-sm text-gray-600 mt-2">{student.fullName} • {student.class} {student.stream}</div>
            </div>

            <div className="overflow-x-auto mb-6">
              <table className="w-full">
                <thead>
                  <tr className="border-b-2 border-gray-900">
                    <th className="text-left py-2 text-sm font-semibold text-gray-900">Subject</th>
                    <th className="text-right py-2 text-sm font-semibold text-gray-900 tabular-nums">Mark</th>
                    <th className="text-right py-2 text-sm font-semibold text-gray-900">Grade</th>
                  </tr>
                </thead>
                <tbody>
                  {report.subjects.map((subject) => (
                    <tr key={subject.subject} className="border-b border-gray-200">
                      <td className="py-3 text-sm text-gray-900">{subject.subject}</td>
                      <td className="py-3 text-sm text-gray-900 text-right tabular-nums">{subject.currentMark}</td>
                      <td className="py-3 text-sm font-medium text-gray-900 text-right">{subject.grade}</td>
                    </tr>
                  ))}
                  <tr className="border-t-2 border-gray-900">
                    <td className="py-3 text-sm font-semibold text-gray-900">Overall Average</td>
                    <td className="py-3 text-sm font-semibold text-gray-900 text-right tabular-nums">{report.overallAverage}</td>
                    <td className="py-3 text-sm font-semibold text-gray-900 text-right">{calculateGrade(report.overallAverage)}</td>
                  </tr>
                </tbody>
              </table>
            </div>

            <div className="space-y-4">
              <div>
                <div className="text-sm font-semibold text-gray-900 mb-1">Class Teacher's Remarks</div>
                <div className="text-sm text-gray-700">{report.teacherRemarks}</div>
              </div>
              <div>
                <div className="text-sm font-semibold text-gray-900 mb-1">Principal's Remarks</div>
                <div className="text-sm text-gray-700">{report.principalRemarks}</div>
              </div>
            </div>
          </motion.div>
        )}
        </AnimatePresence>
      </div>

      {/* Mobile Bottom Navigation */}
      <div className="lg:hidden fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 px-2 py-2">
        <div className="flex justify-around">
          <button
            onClick={() => setActiveTab('overview')}
            className={`flex-1 py-3 text-xs font-medium rounded-lg ${
              activeTab === 'overview'
                ? 'text-emerald-600 bg-emerald-50'
                : 'text-gray-600'
            }`}
          >
            Overview
          </button>
          <button
            onClick={() => setActiveTab('messages')}
            className={`flex-1 py-3 text-xs font-medium rounded-lg ${
              activeTab === 'messages'
                ? 'text-emerald-600 bg-emerald-50'
                : 'text-gray-600'
            }`}
          >
            Messages
          </button>
          <button
            onClick={() => setActiveTab('report')}
            className={`flex-1 py-3 text-xs font-medium rounded-lg ${
              activeTab === 'report'
                ? 'text-emerald-600 bg-emerald-50'
                : 'text-gray-600'
            }`}
          >
            Report
          </button>
        </div>
      </div>
    </div>
  );
}

function calculateGrade(average: number): string {
  if (average >= 80) return 'A';
  if (average >= 75) return 'A-';
  if (average >= 70) return 'B+';
  if (average >= 65) return 'B';
  if (average >= 60) return 'B-';
  if (average >= 55) return 'C+';
  if (average >= 50) return 'C';
  if (average >= 45) return 'C-';
  if (average >= 40) return 'D+';
  if (average >= 35) return 'D';
  return 'E';
}
