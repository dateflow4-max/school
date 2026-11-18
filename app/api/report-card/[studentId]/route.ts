import { NextResponse } from 'next/server';
import { createServerSupabaseClient } from '@/lib/supabase/server';

export async function GET(
  request: Request,
  { params }: { params: { studentId: string } }
) {
  try {
    const supabase = await createServerSupabaseClient();
    
    // Check if user is authenticated
    const { data: { user }, error: authError } = await supabase.auth.getUser();
    
    if (authError || !user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const { studentId } = params;

    // Get user profile
    const { data: profile } = await supabase
      .from('profiles')
      .select('role, is_approved')
      .eq('id', user.id)
      .single();

    // If parent, check if they have access to this student and fees are cleared
    if (profile?.role === 'parent') {
      const { data: link } = await supabase
        .from('parent_student_links')
        .select('student:students(id, fees_cleared)')
        .eq('parent_id', user.id)
        .eq('student_id', studentId)
        .single();

      if (!link) {
        return NextResponse.json({ error: 'Not your child' }, { status: 403 });
      }

      if (!link.student.fees_cleared) {
        return NextResponse.json({ error: 'Fees not cleared' }, { status: 403 });
      }
    }

    // Fetch report card with grades
    const { data: reportCard, error: reportError } = await supabase
      .from('report_cards')
      .select(`
        *,
        term:academic_terms(*),
        grades(
          *,
          subject:subjects(*)
        )
      `)
      .eq('student_id', studentId)
      .order('created_at', { ascending: false })
      .limit(1)
      .single();

    if (reportError) {
      throw reportError;
    }

    // Fetch student info
    const { data: student, error: studentError } = await supabase
      .from('students')
      .select('*')
      .eq('id', studentId)
      .single();

    if (studentError) {
      throw studentError;
    }

    return NextResponse.json({ reportCard, student });
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
