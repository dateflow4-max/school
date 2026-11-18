export interface Student {
  id: string;
  studentCode: string;
  parentCode: string;
  fullName: string;
  class: string;
  stream: string;
  feesCleared: boolean;
  feesBalance: number;
  schoolpayCode: string;
  photo: string;
}

export interface SubjectGrade {
  subject: string;
  currentMark: number;
  previousMark: number;
  grade: string;
  change: number;
}

export interface ReportCard {
  studentId: string;
  term: string;
  year: string;
  overallAverage: number;
  classRank: number;
  totalStudents: number;
  attendance: {
    present: number;
    total: number;
  };
  subjects: SubjectGrade[];
  teacherRemarks: string;
  principalRemarks: string;
}

export interface SchoolMessage {
  id: string;
  type: 'App' | 'SMS' | 'WhatsApp';
  title: string;
  message: string;
  date: string;
}

export interface Teacher {
  id: string;
  name: string;
  email: string;
  role: string;
}

// Demo students
export const demoStudents: Student[] = [
  {
    id: '1',
    studentCode: 'STU2024001',
    parentCode: 'PAR2024001',
    fullName: 'Amina Wanjiru',
    class: 'Form 3',
    stream: 'East',
    feesCleared: true,
    feesBalance: 0,
    schoolpayCode: 'SP-2024-001',
    photo: '/placeholder-student.jpg',
  },
  {
    id: '2',
    studentCode: 'STU2024002',
    parentCode: 'PAR2024002',
    fullName: 'David Omondi',
    class: 'Form 3',
    stream: 'East',
    feesCleared: false,
    feesBalance: 15000,
    schoolpayCode: 'SP-2024-002',
    photo: '/placeholder-student.jpg',
  },
  {
    id: '3',
    studentCode: 'STU2024003',
    parentCode: 'PAR2024003',
    fullName: 'Grace Achieng',
    class: 'Form 2',
    stream: 'West',
    feesCleared: true,
    feesBalance: 0,
    schoolpayCode: 'SP-2024-003',
    photo: '/placeholder-student.jpg',
  },
];

// Demo report cards
export const demoReports: ReportCard[] = [
  {
    studentId: '1',
    term: 'Term 2',
    year: '2024',
    overallAverage: 78.5,
    classRank: 3,
    totalStudents: 45,
    attendance: {
      present: 58,
      total: 60,
    },
    subjects: [
      { subject: 'Mathematics', currentMark: 85, previousMark: 78, grade: 'A-', change: 7 },
      { subject: 'English', currentMark: 76, previousMark: 72, grade: 'B+', change: 4 },
      { subject: 'Kiswahili', currentMark: 82, previousMark: 80, grade: 'A-', change: 2 },
      { subject: 'Biology', currentMark: 74, previousMark: 76, grade: 'B', change: -2 },
      { subject: 'Chemistry', currentMark: 79, previousMark: 74, grade: 'B+', change: 5 },
      { subject: 'Physics', currentMark: 73, previousMark: 75, grade: 'B', change: -2 },
      { subject: 'History', currentMark: 80, previousMark: 78, grade: 'A-', change: 2 },
      { subject: 'Geography', currentMark: 77, previousMark: 73, grade: 'B+', change: 4 },
    ],
    teacherRemarks: 'Amina has shown excellent progress this term, particularly in Mathematics. Continue with the same dedication.',
    principalRemarks: 'Well done. Keep up the good work.',
  },
];

// Demo messages
export const demoMessages: SchoolMessage[] = [
  {
    id: '1',
    type: 'App',
    title: 'Term 2 Results Released',
    message: 'Dear parent, Term 2 examination results are now available. Login to view your child\'s report card.',
    date: '2024-08-15',
  },
  {
    id: '2',
    type: 'SMS',
    title: 'Mid-term Break',
    message: 'School will close on Friday 23rd August for mid-term break. Students resume on Monday 2nd September.',
    date: '2024-08-20',
  },
  {
    id: '3',
    type: 'WhatsApp',
    title: 'Parent-Teacher Meeting',
    message: 'Parents are invited to a meeting on Saturday 7th September at 10 AM to discuss academic progress.',
    date: '2024-09-01',
  },
];

// Demo teachers
export const demoTeachers: Teacher[] = [
  {
    id: '1',
    name: 'Mr. James Mutua',
    email: 'j.mutua@school.ac.ke',
    role: 'Mathematics Teacher',
  },
  {
    id: '2',
    name: 'Mrs. Sarah Njeri',
    email: 's.njeri@school.ac.ke',
    role: 'English Teacher',
  },
];

// Authentication helpers
export function validateParentCredentials(parentCode: string, studentCode: string): Student | null {
  return demoStudents.find(
    (student) => student.parentCode === parentCode && student.studentCode === studentCode
  ) || null;
}

export function validateStaffCredentials(email: string, password: string): Teacher | null {
  // Demo: any email with password "demo123" works
  if (password === 'demo123') {
    return demoTeachers[0];
  }
  return null;
}

export function getStudentReport(studentId: string): ReportCard | null {
  return demoReports.find((report) => report.studentId === studentId) || null;
}

export function getSchoolMessages(): SchoolMessage[] {
  return demoMessages;
}

export function calculateGrade(mark: number): string {
  if (mark >= 80) return 'A';
  if (mark >= 75) return 'A-';
  if (mark >= 70) return 'B+';
  if (mark >= 65) return 'B';
  if (mark >= 60) return 'B-';
  if (mark >= 55) return 'C+';
  if (mark >= 50) return 'C';
  if (mark >= 45) return 'C-';
  if (mark >= 40) return 'D+';
  if (mark >= 35) return 'D';
  if (mark >= 30) return 'D-';
  return 'E';
}
