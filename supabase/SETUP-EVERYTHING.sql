-- ============================================
-- 🎓 SCHOOL MANAGEMENT SYSTEM - COMPLETE SETUP
-- ============================================
-- Run this ONE script in Supabase SQL Editor
-- It creates EVERYTHING: tables, policies, demo data, and user accounts
-- 
-- ⏱️ Takes about 10 seconds to run
-- ✅ After this, you're ready to login!
-- ============================================

-- ============================================
-- 1. CREATE ALL TABLES
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

CREATE TABLE IF NOT EXISTS public.parent_student_links (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  parent_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  student_id UUID REFERENCES public.students(id) ON DELETE CASCADE,
  relationship TEXT DEFAULT 'parent' CHECK (relationship IN ('parent', 'guardian', 'sponsor')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(parent_id, student_id)
);

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

CREATE TABLE IF NOT EXISTS public.subjects (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  subject_code TEXT UNIQUE NOT NULL,
  subject_name TEXT UNIQUE NOT NULL,
  category TEXT CHECK (category IN ('compulsory', 'optional', 'elective')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

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

-- ============================================
-- 2. ENABLE ROW LEVEL SECURITY
-- ============================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.students ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parent_student_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.academic_terms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.report_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.grades ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.school_messages ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 3. CREATE SECURITY POLICIES
-- ============================================

-- Profiles policies
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
CREATE POLICY "Users can view own profile" ON public.profiles FOR SELECT USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- Students policies
DROP POLICY IF EXISTS "Staff can view all students" ON public.students;
CREATE POLICY "Staff can view all students" ON public.students FOR SELECT
USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = auth.uid() AND profiles.role IN ('teacher', 'admin') AND profiles.is_approved = true));

DROP POLICY IF EXISTS "Staff can insert students" ON public.students;
CREATE POLICY "Staff can insert students" ON public.students FOR INSERT
WITH CHECK (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = auth.uid() AND profiles.role IN ('teacher', 'admin') AND profiles.is_approved = true));

DROP POLICY IF EXISTS "Staff can update students" ON public.students;
CREATE POLICY "Staff can update students" ON public.students FOR UPDATE
USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = auth.uid() AND profiles.role IN ('teacher', 'admin') AND profiles.is_approved = true));

-- Parent-student links policies
DROP POLICY IF EXISTS "Parents can view their links" ON public.parent_student_links;
CREATE POLICY "Parents can view their links" ON public.parent_student_links FOR SELECT USING (parent_id = auth.uid());

-- Academic terms policies
DROP POLICY IF EXISTS "Anyone can view published terms" ON public.academic_terms;
CREATE POLICY "Anyone can view published terms" ON public.academic_terms FOR SELECT USING (is_published = true);

DROP POLICY IF EXISTS "Staff can manage terms" ON public.academic_terms;
CREATE POLICY "Staff can manage terms" ON public.academic_terms FOR ALL
USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = auth.uid() AND profiles.role IN ('teacher', 'admin') AND profiles.is_approved = true));

-- Subjects policies
DROP POLICY IF EXISTS "Everyone can view subjects" ON public.subjects;
CREATE POLICY "Everyone can view subjects" ON public.subjects FOR SELECT USING (true);

-- Report cards policies
DROP POLICY IF EXISTS "Parents can view their children's reports" ON public.report_cards;
CREATE POLICY "Parents can view their children's reports" ON public.report_cards FOR SELECT
USING (EXISTS (
  SELECT 1 FROM public.parent_student_links psl
  JOIN public.students s ON s.id = psl.student_id
  WHERE psl.parent_id = auth.uid() AND report_cards.student_id = s.id AND s.fees_cleared = true
));

DROP POLICY IF EXISTS "Staff can view all reports" ON public.report_cards;
CREATE POLICY "Staff can view all reports" ON public.report_cards FOR SELECT
USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = auth.uid() AND profiles.role IN ('teacher', 'admin') AND profiles.is_approved = true));

DROP POLICY IF EXISTS "Staff can manage reports" ON public.report_cards;
CREATE POLICY "Staff can manage reports" ON public.report_cards FOR ALL
USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = auth.uid() AND profiles.role IN ('teacher', 'admin') AND profiles.is_approved = true));

-- Grades policies
DROP POLICY IF EXISTS "Parents can view their children's grades" ON public.grades;
CREATE POLICY "Parents can view their children's grades" ON public.grades FOR SELECT
USING (EXISTS (
  SELECT 1 FROM public.report_cards rc
  JOIN public.students s ON s.id = rc.student_id
  JOIN public.parent_student_links psl ON psl.student_id = s.id
  WHERE psl.parent_id = auth.uid() AND grades.report_card_id = rc.id AND s.fees_cleared = true
));

DROP POLICY IF EXISTS "Staff can view all grades" ON public.grades;
CREATE POLICY "Staff can view all grades" ON public.grades FOR SELECT
USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = auth.uid() AND profiles.role IN ('teacher', 'admin') AND profiles.is_approved = true));

DROP POLICY IF EXISTS "Staff can manage grades" ON public.grades;
CREATE POLICY "Staff can manage grades" ON public.grades FOR ALL
USING (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = auth.uid() AND profiles.role IN ('teacher', 'admin') AND profiles.is_approved = true));

-- Messages policies
DROP POLICY IF EXISTS "Everyone can view messages" ON public.school_messages;
CREATE POLICY "Everyone can view messages" ON public.school_messages FOR SELECT USING (true);

DROP POLICY IF EXISTS "Staff can send messages" ON public.school_messages;
CREATE POLICY "Staff can send messages" ON public.school_messages FOR INSERT
WITH CHECK (EXISTS (SELECT 1 FROM public.profiles WHERE profiles.id = auth.uid() AND profiles.role IN ('teacher', 'admin') AND profiles.is_approved = true));

-- ============================================
-- 4. CREATE FUNCTIONS & TRIGGERS
-- ============================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, role, is_approved)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
    COALESCE(NEW.raw_user_meta_data->>'role', 'parent'),
    CASE WHEN COALESCE(NEW.raw_user_meta_data->>'role', 'parent') = 'parent' THEN true ELSE false END
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_updated_at ON public.profiles;
CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS set_updated_at ON public.students;
CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.students FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS set_updated_at ON public.report_cards;
CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.report_cards FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- ============================================
-- 5. CREATE INDEXES FOR PERFORMANCE
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
-- 6. INSERT DEMO DATA
-- ============================================

-- Subjects
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

-- Academic term
INSERT INTO public.academic_terms (year, term_name, term_number, start_date, end_date, is_current, is_published) VALUES
  (2024, 'Term 2', 2, '2024-05-01', '2024-08-15', true, true)
ON CONFLICT (year, term_number) DO NOTHING;

-- Students
INSERT INTO public.students (student_code, parent_code, full_name, current_class, stream, gender, fees_cleared, fees_balance, schoolpay_code, status, date_of_birth) VALUES
  ('STU2024001', 'PAR2024001', 'Amina Wanjiru', 'Form 3', 'East', 'Female', true, 0, 'SP-2024-001', 'active', '2008-03-15'),
  ('STU2024002', 'PAR2024002', 'David Omondi', 'Form 3', 'East', 'Male', false, 15000, 'SP-2024-002', 'active', '2008-07-22'),
  ('STU2024003', 'PAR2024003', 'Grace Achieng', 'Form 2', 'West', 'Female', true, 0, 'SP-2024-003', 'active', '2009-01-10')
ON CONFLICT (student_code) DO NOTHING;

-- School messages
INSERT INTO public.school_messages (message_type, title, message, target_audience)
SELECT 'App', 'Term 2 Results Released', 'Dear parent, Term 2 examination results are now available. Login to view your child''s report card.', 'parents'
WHERE NOT EXISTS (SELECT 1 FROM public.school_messages WHERE title = 'Term 2 Results Released');

INSERT INTO public.school_messages (message_type, title, message, target_audience)
SELECT 'SMS', 'Mid-term Break', 'School will close on Friday 23rd August for mid-term break. Students resume on Monday 2nd September.', 'all'
WHERE NOT EXISTS (SELECT 1 FROM public.school_messages WHERE title = 'Mid-term Break');

INSERT INTO public.school_messages (message_type, title, message, target_audience)
SELECT 'WhatsApp', 'Parent-Teacher Meeting', 'Parents are invited to a meeting on Saturday 7th September at 10 AM to discuss academic progress.', 'parents'
WHERE NOT EXISTS (SELECT 1 FROM public.school_messages WHERE title = 'Parent-Teacher Meeting');

-- ============================================
-- 7. CREATE DEMO USER ACCOUNTS
-- ============================================

-- Parent 1: For Amina (Fees Cleared)
INSERT INTO auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change)
VALUES ('00000000-0000-0000-0000-000000000000', gen_random_uuid(), 'authenticated', 'authenticated', 'parent1@demo.school', crypt('parent123', gen_salt('bf')), NOW(), '{"provider":"email","providers":["email"]}', '{"full_name":"Mary Wanjiru","role":"parent"}', NOW(), NOW(), '', '', '', '')
ON CONFLICT (email) DO NOTHING;

-- Parent 2: For David (Fees NOT Cleared)
INSERT INTO auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change)
VALUES ('00000000-0000-0000-0000-000000000000', gen_random_uuid(), 'authenticated', 'authenticated', 'parent2@demo.school', crypt('parent123', gen_salt('bf')), NOW(), '{"provider":"email","providers":["email"]}', '{"full_name":"John Omondi","role":"parent"}', NOW(), NOW(), '', '', '', '')
ON CONFLICT (email) DO NOTHING;

-- Parent 3: For Grace (Fees Cleared)
INSERT INTO auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change)
VALUES ('00000000-0000-0000-0000-000000000000', gen_random_uuid(), 'authenticated', 'authenticated', 'parent3@demo.school', crypt('parent123', gen_salt('bf')), NOW(), '{"provider":"email","providers":["email"]}', '{"full_name":"Sarah Achieng","role":"parent"}', NOW(), NOW(), '', '', '', '')
ON CONFLICT (email) DO NOTHING;

-- Teacher Account
INSERT INTO auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change)
VALUES ('00000000-0000-0000-0000-000000000000', gen_random_uuid(), 'authenticated', 'authenticated', 'teacher@demo.school', crypt('teacher123', gen_salt('bf')), NOW(), '{"provider":"email","providers":["email"]}', '{"full_name":"James Mutua","role":"teacher"}', NOW(), NOW(), '', '', '', '')
ON CONFLICT (email) DO NOTHING;

-- Admin Account
INSERT INTO auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change)
VALUES ('00000000-0000-0000-0000-000000000000', gen_random_uuid(), 'authenticated', 'authenticated', 'admin@demo.school', crypt('admin123', gen_salt('bf')), NOW(), '{"provider":"email","providers":["email"]}', '{"full_name":"Principal Jane Mwangi","role":"admin"}', NOW(), NOW(), '', '', '', '')
ON CONFLICT (email) DO NOTHING;

-- ============================================
-- 8. APPROVE STAFF ACCOUNTS
-- ============================================

UPDATE public.profiles SET is_approved = true WHERE email IN ('teacher@demo.school', 'admin@demo.school');

-- ============================================
-- 9. LINK PARENTS TO STUDENTS
-- ============================================

INSERT INTO public.parent_student_links (parent_id, student_id, relationship)
SELECT (SELECT id FROM auth.users WHERE email = 'parent1@demo.school'), (SELECT id FROM public.students WHERE student_code = 'STU2024001'), 'parent'
WHERE EXISTS (SELECT 1 FROM auth.users WHERE email = 'parent1@demo.school') AND EXISTS (SELECT 1 FROM public.students WHERE student_code = 'STU2024001')
ON CONFLICT (parent_id, student_id) DO NOTHING;

INSERT INTO public.parent_student_links (parent_id, student_id, relationship)
SELECT (SELECT id FROM auth.users WHERE email = 'parent2@demo.school'), (SELECT id FROM public.students WHERE student_code = 'STU2024002'), 'parent'
WHERE EXISTS (SELECT 1 FROM auth.users WHERE email = 'parent2@demo.school') AND EXISTS (SELECT 1 FROM public.students WHERE student_code = 'STU2024002')
ON CONFLICT (parent_id, student_id) DO NOTHING;

INSERT INTO public.parent_student_links (parent_id, student_id, relationship)
SELECT (SELECT id FROM auth.users WHERE email = 'parent3@demo.school'), (SELECT id FROM public.students WHERE student_code = 'STU2024003'), 'parent'
WHERE EXISTS (SELECT 1 FROM auth.users WHERE email = 'parent3@demo.school') AND EXISTS (SELECT 1 FROM public.students WHERE student_code = 'STU2024003')
ON CONFLICT (parent_id, student_id) DO NOTHING;

-- ============================================
-- 10. CREATE REPORT CARD FOR AMINA
-- ============================================

DO $$
DECLARE
  v_term_id UUID;
  v_student_id UUID;
  v_report_card_id UUID;
BEGIN
  SELECT id INTO v_term_id FROM public.academic_terms WHERE year = 2024 AND term_number = 2;
  SELECT id INTO v_student_id FROM public.students WHERE student_code = 'STU2024001';
  
  IF v_term_id IS NOT NULL AND v_student_id IS NOT NULL THEN
    INSERT INTO public.report_cards (student_id, term_id, class_at_time, stream_at_time, overall_average, total_marks, possible_marks, stream_rank, class_rank, total_students_in_class, attendance_present, attendance_total, teacher_remarks, principal_remarks)
    VALUES (v_student_id, v_term_id, 'Form 3', 'East', 78.5, 628, 800, 2, 3, 45, 58, 60, 'Amina has shown excellent progress this term, particularly in Mathematics. Continue with the same dedication.', 'Well done. Keep up the good work.')
    ON CONFLICT (student_id, term_id) DO NOTHING
    RETURNING id INTO v_report_card_id;
    
    IF v_report_card_id IS NOT NULL THEN
      INSERT INTO public.grades (report_card_id, subject_id, subject_name, current_mark, previous_mark, grade, grade_points) VALUES
        (v_report_card_id, (SELECT id FROM public.subjects WHERE subject_code = 'MATH'), 'Mathematics', 85, 78, 'A-', 11.0),
        (v_report_card_id, (SELECT id FROM public.subjects WHERE subject_code = 'ENG'), 'English', 76, 72, 'B+', 10.0),
        (v_report_card_id, (SELECT id FROM public.subjects WHERE subject_code = 'KIS'), 'Kiswahili', 82, 80, 'A-', 11.0),
        (v_report_card_id, (SELECT id FROM public.subjects WHERE subject_code = 'BIO'), 'Biology', 74, 76, 'B', 9.0),
        (v_report_card_id, (SELECT id FROM public.subjects WHERE subject_code = 'CHEM'), 'Chemistry', 79, 74, 'B+', 10.0),
        (v_report_card_id, (SELECT id FROM public.subjects WHERE subject_code = 'PHY'), 'Physics', 73, 75, 'B', 9.0),
        (v_report_card_id, (SELECT id FROM public.subjects WHERE subject_code = 'HIST'), 'History', 80, 78, 'A-', 11.0),
        (v_report_card_id, (SELECT id FROM public.subjects WHERE subject_code = 'GEO'), 'Geography', 77, 73, 'B+', 10.0)
      ON CONFLICT (report_card_id, subject_id) DO NOTHING;
    END IF;
  END IF;
END $$;

-- ============================================
-- ✅ SUCCESS! DISPLAY SUMMARY
-- ============================================

SELECT '🎉 SETUP COMPLETE!' AS status
UNION ALL SELECT ''
UNION ALL SELECT '📧 LOGIN CREDENTIALS:'
UNION ALL SELECT ''
UNION ALL SELECT '👨‍👩‍👧 PARENTS (view reports):'
UNION ALL SELECT '  parent1@demo.school / parent123  →  Amina (Fees Cleared ✓)'
UNION ALL SELECT '  parent2@demo.school / parent123  →  David (Fees NOT Cleared ✗)'
UNION ALL SELECT '  parent3@demo.school / parent123  →  Grace (Fees Cleared ✓)'
UNION ALL SELECT ''
UNION ALL SELECT '👨‍🏫 STAFF (manage students):'
UNION ALL SELECT '  teacher@demo.school / teacher123'
UNION ALL SELECT '  admin@demo.school / admin123'
UNION ALL SELECT ''
UNION ALL SELECT '🔗 LEGACY CODE LOGIN (demo mode):'
UNION ALL SELECT '  PAR2024001 / STU2024001'
UNION ALL SELECT ''
UNION ALL SELECT '✅ Database ready! Deploy your app to Vercel now!';

COMMIT;
