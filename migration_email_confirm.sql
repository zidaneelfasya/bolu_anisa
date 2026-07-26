-- 1. Hapus fungsi yang lama jika ada (untuk menghindari konflik tipe data)
DROP FUNCTION IF EXISTS public.confirm_user_email(uuid);
DROP FUNCTION IF EXISTS public.confirm_user_email(text);

-- 2. Pastikan kolom email_confirmed sudah ada
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS email_confirmed BOOLEAN DEFAULT false;

-- 3. Paksa update semua data di profiles agar sinkron dengan auth.users
UPDATE public.profiles p
SET email_confirmed = (a.email_confirmed_at IS NOT NULL)
FROM auth.users a
WHERE p.id = a.id;

-- 4. Perbarui trigger pendaftaran
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, role, email_confirmed)
  VALUES (new.id, new.email, 'kasir', new.email_confirmed_at IS NOT NULL);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Buat ulang fungsi konfirmasi dengan parameter TEXT (menghindari error UUID dari API)
CREATE OR REPLACE FUNCTION public.confirm_user_email(user_id text)
RETURNS boolean AS $$
BEGIN
  -- Update auth.users
  UPDATE auth.users
  SET email_confirmed_at = NOW(),
      updated_at = NOW()
  WHERE id = user_id::uuid;
  
  -- Update profiles
  UPDATE public.profiles
  SET email_confirmed = true
  WHERE id = user_id::uuid;
  
  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 6. Beri izin akses eksplisit agar API bisa memanggil fungsi ini
GRANT EXECUTE ON FUNCTION public.confirm_user_email(text) TO authenticated;
GRANT EXECUTE ON FUNCTION public.confirm_user_email(text) TO anon;
GRANT EXECUTE ON FUNCTION public.confirm_user_email(text) TO service_role;

-- 7. Refresh schema cache PostgREST (Sangat Penting!)
NOTIFY pgrst, 'reload schema';
