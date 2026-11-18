import { NextResponse } from 'next/server';
import { createServerSupabaseClient } from '@/lib/supabase/server';

export async function POST(request: Request) {
  try {
    const supabase = await createServerSupabaseClient();
    
    // Check if user is authenticated and is staff
    const { data: { user }, error: authError } = await supabase.auth.getUser();
    
    if (authError || !user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const { data: profile } = await supabase
      .from('profiles')
      .select('role, is_approved')
      .eq('id', user.id)
      .single();

    if (!profile || !['teacher', 'admin'].includes(profile.role) || !profile.is_approved) {
      return NextResponse.json({ error: 'Forbidden' }, { status: 403 });
    }

    const body = await request.json();
    const { studentId, termId, subjectId, mark, grade, gradePoints } = body;

    // Check if report card exists for this student and term
    let { data: reportCard } = await supabase
      .from('report_cards')
      .select('id')
      .eq('student_id', studentId)
      .eq('term_id', termId)
      .single();

    // If no report card, create one
    if (!reportCard) {
      const { data: student } = await supabase
        .from('students')
        .select('current_class, stream')
        .eq('id', studentId)
        .single();

      const { data: newReportCard } = await supabase
        .from('report_cards')
        .insert({
          student_id: studentId,
          term_id: termId,
          class_at_time: student?.current_class || 'Unknown',
          stream_at_time: student?.stream || 'Unknown',
        })
        .select()
        .single();

      reportCard = newReportCard;
    }

    // Upsert the grade
    const { data, error } = await supabase
      .from('grades')
      .upsert({
        report_card_id: reportCard!.id,
        subject_id: subjectId,
        current_mark: mark,
        grade,
        grade_points: gradePoints,
      })
      .select()
      .single();

    if (error) {
      throw error;
    }

    return NextResponse.json({ grade: data });
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
