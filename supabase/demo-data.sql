-- Demo Report Card Data
-- Run this AFTER creating parent accounts and linking students
-- Replace the UUIDs with your actual term_id and student_id from your database

-- First, get your term_id:
-- SELECT id FROM public.academic_terms WHERE year = 2024 AND term_number = 2;

-- Get your student_id:
-- SELECT id FROM public.students WHERE student_code = 'STU2024001';

-- Example: Insert report card for Amina Wanjiru
-- Replace 'YOUR_TERM_ID' and 'YOUR_STUDENT_ID' with actual UUIDs

DO $$
DECLARE
  v_term_id UUID;
  v_student_id UUID;
  v_report_card_id UUID;
  v_math_subject_id UUID;
  v_eng_subject_id UUID;
  v_kis_subject_id UUID;
  v_bio_subject_id UUID;
  v_chem_subject_id UUID;
  v_phy_subject_id UUID;
  v_hist_subject_id UUID;
  v_geo_subject_id UUID;
BEGIN
  -- Get the term ID
  SELECT id INTO v_term_id FROM public.academic_terms WHERE year = 2024 AND term_number = 2 LIMIT 1;
  
  -- Get student ID
  SELECT id INTO v_student_id FROM public.students WHERE student_code = 'STU2024001' LIMIT 1;
  
  -- Get subject IDs
  SELECT id INTO v_math_subject_id FROM public.subjects WHERE subject_code = 'MATH';
  SELECT id INTO v_eng_subject_id FROM public.subjects WHERE subject_code = 'ENG';
  SELECT id INTO v_kis_subject_id FROM public.subjects WHERE subject_code = 'KIS';
  SELECT id INTO v_bio_subject_id FROM public.subjects WHERE subject_code = 'BIO';
  SELECT id INTO v_chem_subject_id FROM public.subjects WHERE subject_code = 'CHEM';
  SELECT id INTO v_phy_subject_id FROM public.subjects WHERE subject_code = 'PHY';
  SELECT id INTO v_hist_subject_id FROM public.subjects WHERE subject_code = 'HIST';
  SELECT id INTO v_geo_subject_id FROM public.subjects WHERE subject_code = 'GEO';
  
  -- Insert report card
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
  RETURNING id INTO v_report_card_id;
  
  -- Insert individual subject grades
  INSERT INTO public.grades (report_card_id, subject_id, subject_name, current_mark, previous_mark, grade, grade_points) VALUES
    (v_report_card_id, v_math_subject_id, 'Mathematics', 85, 78, 'A-', 11.0),
    (v_report_card_id, v_eng_subject_id, 'English', 76, 72, 'B+', 10.0),
    (v_report_card_id, v_kis_subject_id, 'Kiswahili', 82, 80, 'A-', 11.0),
    (v_report_card_id, v_bio_subject_id, 'Biology', 74, 76, 'B', 9.0),
    (v_report_card_id, v_chem_subject_id, 'Chemistry', 79, 74, 'B+', 10.0),
    (v_report_card_id, v_phy_subject_id, 'Physics', 73, 75, 'B', 9.0),
    (v_report_card_id, v_hist_subject_id, 'History', 80, 78, 'A-', 11.0),
    (v_report_card_id, v_geo_subject_id, 'Geography', 77, 73, 'B+', 10.0);
    
  RAISE NOTICE 'Demo report card created successfully!';
END $$;

-- Insert demo messages
INSERT INTO public.school_messages (message_type, title, message, target_audience) VALUES
  ('App', 'Term 2 Results Released', 'Dear parent, Term 2 examination results are now available. Login to view your child''s report card.', 'parents'),
  ('SMS', 'Mid-term Break', 'School will close on Friday 23rd August for mid-term break. Students resume on Monday 2nd September.', 'all'),
  ('WhatsApp', 'Parent-Teacher Meeting', 'Parents are invited to a meeting on Saturday 7th September at 10 AM to discuss academic progress.', 'parents')
ON CONFLICT DO NOTHING;

COMMIT;
