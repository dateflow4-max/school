-- ============================================
-- CREATE DEMO ACCOUNTS WITH AUTHENTICATION
-- ============================================
-- Run this AFTER 00-complete-setup.sql
-- Creates actual user accounts that can log in

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
  crypt('parent123', gen_salt('bf')),
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
  crypt('parent123', gen_salt('bf')),
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
  crypt('parent123', gen_salt('bf')),
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

-- Teacher 1
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
  crypt('teacher123', gen_salt('bf')),
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
  crypt('admin123', gen_salt('bf')),
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
-- 3. APPROVE STAFF ACCOUNTS
-- ============================================

-- Approve teacher and admin accounts
UPDATE public.profiles
SET is_approved = true
WHERE email IN ('teacher@demo.school', 'admin@demo.school');

-- ============================================
-- 4. LINK PARENTS TO STUDENTS
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
-- 5. CREATE REPORT CARD FOR AMINA
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
      
      RAISE NOTICE '✅ Report card created for Amina Wanjiru';
    END IF;
  ELSE
    RAISE WARNING '⚠️ Could not find term or student. Make sure 00-complete-setup.sql was run first.';
  END IF;
END $$;

-- ============================================
-- 6. SUMMARY
-- ============================================

SELECT 
  '✅ Demo accounts created successfully!' AS status
UNION ALL
SELECT 
  ''
UNION ALL
SELECT 
  '📧 PARENT ACCOUNTS:'
UNION ALL
SELECT 
  '   parent1@demo.school / parent123 (Amina - Fees Cleared)'
UNION ALL
SELECT 
  '   parent2@demo.school / parent123 (David - Fees NOT Cleared)'
UNION ALL
SELECT 
  '   parent3@demo.school / parent123 (Grace - Fees Cleared)'
UNION ALL
SELECT 
  ''
UNION ALL
SELECT 
  '👨‍🏫 STAFF ACCOUNTS:'
UNION ALL
SELECT 
  '   teacher@demo.school / teacher123'
UNION ALL
SELECT 
  '   admin@demo.school / admin123';

COMMIT;
