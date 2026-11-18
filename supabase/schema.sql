-- School Management System - Complete Database Schema
-- Run this SQL in your Supabase SQL Editor
-- https://app.supabase.com/project/_/sql

-- ============================================
-- 1. PROFILES TABLE (extends auth.users)
-- ============================================
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  role TEXT NOT NULL CHECK (role IN ('parent', 'teacher', 'admin')),
  full_name TEXT NOT NULL,
  phone TEXT,
  email TEXT UNIQUE NOT NULL,
  is_approved BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Policies for profiles
CREATE POLICY "Users can view own profile"
  ON public.profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id);

-- ============================================
-- 2. STUDENTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.students (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  student_code TEXT UNIQUE NOT NULL,
  parent_code TEXT NOT NULL,
  full_name TEXT NOT NULL,
  current_class TEXT NOT NULL,
  stream TEXT NOT NULL,
  combination TEXT,
  date_of_birth DATE,
  gender TEXT CHECK (gender IN ('Male', 'Female')),
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'promoted', 'retained', 'transferred', 'suspended')),
  fees_cleared BOOLEAN DEFAULT false,
  fees_balance DECIMAL(10, 2) DEFAULT 0,
  schoolpay_code TEXT UNIQUE,
  photo_url TEXT,
  admission_date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;

-- Policies for students
CREATE POLICY "Teachers and admins can view all students"
  ON public.students FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role IN ('teacher', 'admin')
      AND profiles.is_approved = true
    )
  );

CREATE POLICY "Teachers and admins can insert students"
  ON public.students FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role IN ('teacher', 'admin')
      AND profiles.is_approved = true
    )
  );

CREATE POLICY "Teachers and admins can update students"
  ON public.students FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role IN ('teacher', 'admin')
      AND profiles.is_approved = true
    )
  );

-- ============================================
-- 3. PARENT-STUDENT LINKS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.parent_student_links (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  parent_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  student_id UUID REFERENCES public.students(id) ON DELETE CASCADE,
  relationship TEXT DEFAULT 'parent' CHECK (relationship IN ('parent', 'guardian', 'sponsor')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(parent_id, student_id)
);

ALTER TABLE public.parent_student_links ENABLE ROW LEVEL SECURITY;

-- Policies for parent-student links
CREATE POLICY "Parents can view their linked students"
  ON public.parent_student_links FOR SELECT
  USING (parent_id = auth.uid());

-- ============================================
-- 4. ACADEMIC TERMS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.academic_terms (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  year INTEGER NOT NULL,
  term_name TEXT NOT NULL,
  term_number INTEGER CHECK (term_number IN (1, 2, 3)),
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  is_current BOOLEAN DEFAULT false,
  is_published BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(year, term_number)
);

ALTER TABLE public.academic_terms ENABLE ROW LEVEL SECURITY;

-- Everyone can view published terms
CREATE POLICY "Anyone can view published terms"
  ON public.academic_terms FOR SELECT
  USING (is_published = true);

-- Only teachers/admins can manage terms
CREATE POLICY "Teachers and admins can manage terms"
  ON public.academic_terms FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role IN ('teacher', 'admin')
      AND profiles.is_approved = true
    )
  );

-- ============================================
-- 5. SUBJECTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.subjects (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  subject_code TEXT UNIQUE NOT NULL,
  subject_name TEXT UNIQUE NOT NULL,
  category TEXT CHECK (category IN ('compulsory', 'optional', 'elective')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.subjects ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Everyone can view subjects"
  ON public.subjects FOR SELECT
  USING (true);

-- ============================================
-- 6. REPORT CARDS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.report_cards (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  student_id UUID REFERENCES public.students(id) ON DELETE CASCADE NOT NULL,
  term_id UUID REFERENCES public.academic_terms(id) ON DELETE CASCADE NOT NULL,
  class_at_time TEXT NOT NULL,
  stream_at_time TEXT NOT NULL,
  overall_average DECIMAL(5, 2),
  total_marks INTEGER,
  possible_marks INTEGER,
  stream_rank INTEGER,
  class_rank INTEGER,
  total_students_in_class INTEGER,
  attendance_present INTEGER DEFAULT 0,
  attendance_total INTEGER DEFAULT 0,
  teacher_remarks TEXT,
  principal_remarks TEXT,
  generated_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(student_id, term_id)
);

ALTER TABLE public.report_cards ENABLE ROW LEVEL SECURITY;

-- Parents can view their children's reports (only if fees cleared)
CREATE POLICY "Parents can view their children's reports"
  ON public.report_cards FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.parent_student_links psl
      JOIN public.students s ON s.id = psl.student_id
      WHERE psl.parent_id = auth.uid()
      AND report_cards.student_id = s.id
      AND s.fees_cleared = true
    )
  );

-- Teachers and admins can view all reports
CREATE POLICY "Staff can view all reports"
  ON public.report_cards FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role IN ('teacher', 'admin')
      AND profiles.is_approved = true
    )
  );

-- Teachers and admins can manage reports
CREATE POLICY "Staff can manage reports"
  ON public.report_cards FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role IN ('teacher', 'admin')
      AND profiles.is_approved = true
    )
  );

-- ============================================
-- 7. GRADES TABLE (Individual subject grades)
-- ============================================
CREATE TABLE IF NOT EXISTS public.grades (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  report_card_id UUID REFERENCES public.report_cards(id) ON DELETE CASCADE NOT NULL,
  subject_id UUID REFERENCES public.subjects(id) ON DELETE CASCADE NOT NULL,
  subject_name TEXT NOT NULL,
  current_mark INTEGER CHECK (current_mark >= 0 AND current_mark <= 100),
  previous_mark INTEGER CHECK (previous_mark >= 0 AND previous_mark <= 100),
  grade TEXT,
  grade_points DECIMAL(3, 1),
  remarks TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(report_card_id, subject_id)
);

ALTER TABLE public.grades ENABLE ROW LEVEL SECURITY;

-- Parents can view grades for their children (if fees cleared)
CREATE POLICY "Parents can view their children's grades"
  ON public.grades FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.report_cards rc
      JOIN public.students s ON s.id = rc.student_id
      JOIN public.parent_student_links psl ON psl.student_id = s.id
      WHERE psl.parent_id = auth.uid()
      AND grades.report_card_id = rc.id
      AND s.fees_cleared = true
    )
  );

-- Staff can view all grades
CREATE POLICY "Staff can view all grades"
  ON public.grades FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role IN ('teacher', 'admin')
      AND profiles.is_approved = true
    )
  );

-- Staff can manage grades
CREATE POLICY "Staff can manage grades"
  ON public.grades FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role IN ('teacher', 'admin')
      AND profiles.is_approved = true
    )
  );

-- ============================================
-- 8. SCHOOL MESSAGES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.school_messages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  message_type TEXT NOT NULL CHECK (message_type IN ('App', 'SMS', 'WhatsApp')),
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  target_audience TEXT DEFAULT 'all' CHECK (target_audience IN ('all', 'parents', 'teachers', 'specific_class')),
  target_class TEXT,
  sent_by UUID REFERENCES public.profiles(id),
  sent_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.school_messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Everyone can view messages"
  ON public.school_messages FOR SELECT
  USING (true);

CREATE POLICY "Staff can send messages"
  ON public.school_messages FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role IN ('teacher', 'admin')
      AND profiles.is_approved = true
    )
  );

-- ============================================
-- 9. FUNCTIONS & TRIGGERS
-- ============================================

-- Function to automatically create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, role, is_approved)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
    COALESCE(NEW.raw_user_meta_data->>'role', 'parent'),
    CASE
      WHEN COALESCE(NEW.raw_user_meta_data->>'role', 'parent') = 'parent' THEN true
      ELSE false
    END
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile on user signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at triggers
CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.students
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.report_cards
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- ============================================
-- 10. INDEXES FOR PERFORMANCE
-- ============================================
CREATE INDEX IF NOT EXISTS idx_students_code ON public.students(student_code);
CREATE INDEX IF NOT EXISTS idx_students_parent_code ON public.students(parent_code);
CREATE INDEX IF NOT EXISTS idx_students_fees ON public.students(fees_cleared);
CREATE INDEX IF NOT EXISTS idx_report_cards_student ON public.report_cards(student_id);
CREATE INDEX IF NOT EXISTS idx_report_cards_term ON public.report_cards(term_id);
CREATE INDEX IF NOT EXISTS idx_grades_report ON public.grades(report_card_id);
CREATE INDEX IF NOT EXISTS idx_parent_links_parent ON public.parent_student_links(parent_id);
CREATE INDEX IF NOT EXISTS idx_parent_links_student ON public.parent_student_links(student_id);

-- ============================================
-- 11. INSERT DEMO DATA
-- ============================================

-- Insert subjects
INSERT INTO public.subjects (subject_code, subject_name, category) VALUES
  ('MATH', 'Mathematics', 'compulsory'),
  ('ENG', 'English', 'compulsory'),
  ('KIS', 'Kiswahili', 'compulsory'),
  ('BIO', 'Biology', 'optional'),
  ('CHEM', 'Chemistry', 'optional'),
  ('PHY', 'Physics', 'optional'),
  ('HIST', 'History', 'elective'),
  ('GEO', 'Geography', 'elective')
ON CONFLICT (subject_code) DO NOTHING;

-- Insert academic term
INSERT INTO public.academic_terms (year, term_name, term_number, start_date, end_date, is_current, is_published) VALUES
  (2024, 'Term 2', 2, '2024-05-01', '2024-08-15', true, true)
ON CONFLICT (year, term_number) DO NOTHING;

-- Insert demo students
INSERT INTO public.students (
  student_code, parent_code, full_name, current_class, stream, gender,
  fees_cleared, fees_balance, schoolpay_code, status, date_of_birth
) VALUES
  ('STU2024001', 'PAR2024001', 'Amina Wanjiru', 'Form 3', 'East', 'Female', true, 0, 'SP-2024-001', 'active', '2008-03-15'),
  ('STU2024002', 'PAR2024002', 'David Omondi', 'Form 3', 'East', 'Male', false, 15000, 'SP-2024-002', 'active', '2008-07-22'),
  ('STU2024003', 'PAR2024003', 'Grace Achieng', 'Form 2', 'West', 'Female', true, 0, 'SP-2024-003', 'active', '2009-01-10')
ON CONFLICT (student_code) DO NOTHING;

-- Note: Report cards and grades will be inserted after you create parent accounts
-- This is because they need proper linking to work with RLS policies

COMMIT;
