import { createClient } from './supabase/client';

export async function signInWithEmail(email: string, password: string) {
  const supabase = createClient();
  
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });

  if (error) {
    throw new Error(error.message);
  }

  return data;
}

export async function signUpWithEmail(
  email: string,
  password: string,
  fullName: string,
  role: 'parent' | 'teacher'
) {
  const supabase = createClient();

  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: {
        full_name: fullName,
        role: role,
      },
    },
  });

  if (error) {
    throw new Error(error.message);
  }

  return data;
}

export async function signOut() {
  const supabase = createClient();
  const { error } = await supabase.auth.signOut();
  
  if (error) {
    throw new Error(error.message);
  }
}

export async function getCurrentUser() {
  const supabase = createClient();
  const { data: { user }, error } = await supabase.auth.getUser();
  
  if (error) {
    throw new Error(error.message);
  }
  
  return user;
}

export async function getUserProfile(userId: string) {
  const supabase = createClient();
  
  const { data, error } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', userId)
    .single();

  if (error) {
    throw new Error(error.message);
  }

  return data;
}

export async function getLinkedStudents(parentId: string) {
  const supabase = createClient();
  
  const { data, error } = await supabase
    .from('parent_student_links')
    .select(`
      student:students (
        id,
        student_code,
        parent_code,
        full_name,
        current_class,
        stream,
        fees_cleared,
        fees_balance,
        schoolpay_code,
        photo_url
      )
    `)
    .eq('parent_id', parentId);

  if (error) {
    throw new Error(error.message);
  }

  return data.map(item => item.student);
}
