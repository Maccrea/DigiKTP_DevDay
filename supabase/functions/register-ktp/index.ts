import { createClient } from 'npm:@supabase/supabase-js'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const payload = await req.json();
    
    const { uid_nfc, nik, nama_lengkap, email, ...otherData } = payload;

    if (!uid_nfc || !nik || !nama_lengkap || !email) {
      return new Response(
        JSON.stringify({ 
          status: "error", 
          message: "Data tidak lengkap! uid_nfc, nik, nama_lengkap, dan email wajib diisi." 
        }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 400 }
      );
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    const { error: errWarga } = await supabase
      .from('users_warga')
      .insert({
        uid_nfc,
        nik,
        nama_lengkap,
        email,
        ...otherData 
      });
    
    if (errWarga) throw errWarga;

    const { error: errCitizens } = await supabase
      .from('citizens')
      .insert({ uid_nfc, nik, nama_lengkap });

    if (errCitizens) throw errCitizens;

    const { error: errAkun } = await supabase
      .from('citizen_accounts')
      .insert({
        citizen_uid: uid_nfc,
        email: email,
        is_primary: true
      });

    if (errAkun) throw errAkun;

    return new Response(
      JSON.stringify({ 
        status: "success", 
        message: "Registrasi KTP berhasil! Data sudah masuk ke sistem." 
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 200 }
    );

  } catch (err: any) {
    return new Response(
      JSON.stringify({ status: "error", message: err.message }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 500 }
    );
  }
});