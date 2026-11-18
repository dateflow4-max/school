-- ============================================
-- CREATE DEMO ACCOUNTS WITH AUTHENTICATION
-- ============================================
-- Run this in Supabase SQL Editor AFTER running 00-complete-setup.sql
-- This creates actual user accounts that can log in
--
-- IMPORTANT: Run 00-complete-setup.sql FIRST!
-- This script will fail if tables don't exist

-- ============================================
-- 1. CREATE PARENT ACCOUNTS
-- ============================================

-- Parent 1: For Amina Wanjiru (Fees Cleared)
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  recovery_token,
  email_change_token_new,
  email_change
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  gen_random_uuid(),
  'authenticated',
  'authenticated',
  'parent1@demo.school',
  crypt('parent123', gen_salt('bf')), -- Password: parent123
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Mary Wanjiru","role":"parent"}',
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
) ON CONFLICT (email) DO NOTHING;

-- Parent 2: For David Omondi (Fees NOT Cleared)
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  recovery_token,
  email_change_token_new,
  email_change
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  gen_random_uuid(),
  'authenticated',
  'authenticated',
  'parent2@demo.school',
  crypt('parent123', gen_salt('bf')), -- Password: parent123
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"John Omondi","role":"parent"}',
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
) ON CONFLICT (email) DO NOTHING;

-- Parent 3: For Grace Achieng (Fees Cleared)
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  recovery_token,
  email_change_token_new,
  email_change
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  gen_random_uuid(),
  'authenticated',
  'authenticated',
  'parent3@demo.school',
  crypt('parent123', gen_salt('bf')), -- Password: parent123
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Sarah Achieng","role":"parent"}',
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
) ON CONFLICT (email) DO NOTHING;

-- ============================================
-- 2. CREATE TEACHER/STAFF ACCOUNTS
-- ============================================

-- Teacher 1: Mathematics Teacher
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  recovery_token,
  email_change_token_new,
  email_change
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  gen_random_uuid(),
  'authenticated',
  'authenticated',
  'teacher@demo.school',
  crypt('teacher123', gen_salt('bf')), -- Password: teacher123
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"James Mutua","role":"teacher"}',
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
) ON CONFLICT (email) DO NOTHING;

-- Admin Account
INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  recovery_token,
  email_change_token_new,
  email_change
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  gen_random_uuid(),
  'authenticated',
  'authenticated',
  'admin@demo.school',
  crypt('admin123', gen_salt('bf')), -- Password: admin123
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Principal Jane Mwangi","role":"admin"}',
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
) ON CONFLICT (email) DO NOTHING;

-- ============================================
-- 3. LINK PARENTS TO STUDENTS
-- ============================================

-- Link Parent 1 to Amina Wanjiru
INSERT INTO public.parent_student_links (parent_id, student_id, relationship)
SELECT 
  (SELECT id FROM auth.users WHERE email = 'parent1@demo.school'),
  (SELECT id FROM public.students WHERE student_code = 'STU2024001'),
  'parent'
WHERE EXISTS (SELECT 1 FROM auth.users WHERE email = 'parent1@demo.school')
  AND EXISTS (SELECT 1 FROM public.students WHERE student_code = 'STU2024001')
ON CONFLICT (parent_id, student_id) DO NOTHING;

-- Link Parent 2 to David Omondi
INSERT INTO public.parent_student_links (parent_id, student_id, relationship)
SELECT 
  (SELECT id FROM auth.users WHERE email = 'parent2@demo.school'),
  (SELECT id FROM public.students WHERE student_code = 'STU2024002'),
  'parent'
WHERE EXISTS (SELECT 1 FROM auth.users WHERE email = 'parent2@demo.school')
  AND EXISTS (SELECT 1 FROM public.students WHERE student_code = 'STU2024002')
ON CONFLICT (parent_id, student_id) DO NOTHING;

-- Link Parent 3 to Grace Achieng
INSERT INTO public.parent_student_links (parent_id, student_id, relationship)
SELECT 
  (SELECT id FROM auth.users WHERE email = 'parent3@demo.school'),
  (SELECT id FROM public.students WHERE student_code = 'STU2024003'),
  'parent'
WHERE EXISTS (SELECT 1 FROM auth.users WHERE email = 'parent3@demo.school')
  AND EXISTS (SELECT 1 FROM public.students WHERE student_code = 'STU2024003')
ON CONFLICT (parent_id, student_id) DO NOTHING;

-- ============================================
-- 4. CREATE REPORT CARDS AND GRADES
-- ============================================

DO $$
DECLARE
  v_term_id UUID;
  v_student_id UUID;
  v_report_card_id UUID;
  v_math_id UUID;
  v_eng_id UUID;
  v_kis_id UUID;
  v_bio_id UUID;
  v_chem_id UUID;
  v_phy_id UUID;
  v_hist_id UUID;
  v_geo_id UUID;
BEGIN
  -- Get IDs
  SELECT id INTO v_term_id FROM public.academic_terms WHERE year = 2024 AND term_number = 2;
  SELECT id INTO v_student_id FROM public.students WHERE student_code = 'STU2024001';
  
  SELECT id INTO v_math_id FROM public.subjects WHERE subject_code = 'MATH';
  SELECT id INTO v_eng_id FROM public.subjects WHERE subject_code = 'ENG';
  SELECT id INTO v_kis_id FROM public.subjects WHERE subject_code = 'KIS';
  SELECT id INTO v_bio_id FROM public.subjects WHERE subject_code = 'BIO';
  SELECT id INTO v_chem_id FROM public.subjects WHERE subject_code = 'CHEM';
  SELECT id INTO v_phy_id FROM public.subjects WHERE subject_code = 'PHY';
  SELECT id INTO v_hist_id FROM public.subjects WHERE subject_code = 'HIST';
  SELECT id INTO v_geo_id FROM public.subjects WHERE subject_code = 'GEO';
  
  IF v_term_id IS NOT NULL AND v_student_id IS NOT NULL THEN
    -- Create report card for Amina
    INSERT INTO public.report_cards (
      student_id, term_id, class_at_time, stream_at_time,
      overall_average, total_marks, possible_marks,
      stream_rank, class_rank, total_students_in_class,
      attendance_present, attendance_total,
      teacher_remarks, principal_remarks
    ) VALUES (
      v_student_id, v_term_id, 'Form 3', 'East',
      78.5, 628, 800,
      2, 3, 45,
      58, 60,
      'Amina has shown excellent progress this term, particularly in Mathematics. Continue with the same dedication.',
      'Well done. Keep up the good work.'
    )
    ON CONFLICT (student_id, term_id) DO NOTHING
    RETURNING id INTO v_report_card_id;
    
    -- Insert grades
    IF v_report_card_id IS NOT NULL THEN
      INSERT INTO public.grades (report_card_id, subject_id, subject_name, current_mark, previous_mark, grade, grade_points) VALUES
        (v_report_card_id, v_math_id, 'Mathematics', 85, 78, 'A-', 11.0),
        (v_report_card_id, v_eng_id, 'English', 76, 72, 'B+', 10.0),
        (v_report_card_id, v_kis_id, 'Kiswahili', 82, 80, 'A-', 11.0),
        (v_report_card_id, v_bio_id, 'Biology', 74, 76, 'B', 9.0),
        (v_report_card_id, v_chem_id, 'Chemistry', 79, 74, 'B+', 10.0),
        (v_report_card_id, v_phy_id, 'Physics', 73, 75, 'B', 9.0),
        (v_report_card_id, v_hist_id, 'History', 80, 78, 'A-', 11.0),
        (v_report_card_id, v_geo_id, 'Geography', 77, 73, 'B+', 10.0)
      ON CONFLICT (report_card_id, subject_id) DO NOTHING;
    END IF;
  END IF;
END $$;

-- ============================================
-- 5. SUMMARY OF CREATED ACCOUNTS
-- ============================================

SELECT 
  '✅ Demo accounts created successfully!' AS status,
  '' AS blank_line
UNION ALL
SELECT 
  '📧 PARENT ACCOUNTS:', ''
UNION ALL
SELECT 
  '   Email: parent1@demo.school', '   Password: parent123'
UNION ALL
SELECT 
  '   Email: parent2@demo.school', '   Password: parent123'
UNION ALL
SELECT 
  '   Email: parent3@demo.school', '   Password: parent123'
UNION ALL
SELECT 
  '', ''
UNION ALL
SELECT 
  '👨‍🏫 STAFF ACCOUNTS:', ''
UNION ALL
SELECT 
  '   Email: teacher@demo.school', '   Password: teacher123'
UNION ALL
SELECT 
  '   Email: admin@demo.school', '   Password: admin123'
UNION ALL
SELECT 
  '', ''
UNION ALL
SELECT 
  '🔗 STUDENT CODES (for legacy code-based login):', ''
UNION ALL
SELECT 
  '   Parent: PAR2024001', '   Student: STU2024001 (Amina - Fees Cleared)'
UNION ALL
SELECT 
  '   Parent: PAR2024002', '   Student: STU2024002 (David - Fees NOT Cleared)'
UNION ALL
SELECT 
  '   Parent: PAR2024003', '   Student: STU2024003 (Grace - Fees Cleared)';

COMMIT;
