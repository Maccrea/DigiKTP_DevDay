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
    const { nip, password } = payload;

    if (!nip || !password) {
      return new Response(
        JSON.stringify({ 
          status: "error", 
          message: "NIP dan password wajib diisi!" 
        }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 400 }
      );
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '' 
    );

    const { data: petugas, error } = await supabase
      .from('users_petugas')
      .select('*')
      .eq('nip', nip)
      .single();

    if (error || !petugas) {
      return new Response(
        JSON.stringify({ status: "error", message: "Akun petugas tidak ditemukan!" }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 404 }
      );
    }

    if (petugas.password !== password) {
      return new Response(
        JSON.stringify({ status: "error", message: "Password salah!" }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 401 }
      );
    }

delete petugas.password;

    const formattedData = {
      id_petugas: (petugas.id_petugas || petugas.id).toString(),
      nip: petugas.nip,
      nama: petugas.nama,
      email: petugas.email,
      id_instansi: petugas.id_instansi,
      lokasi_layanan: petugas.lokasi_layanan || petugas.current_location || "" 
    };

    return new Response(
      JSON.stringify({ 
        status: "success", 
        message: "Login berhasil!",
        petugas: formattedData, // Ubah 'data' menjadi 'petugas' agar terbaca oleh Flutter
        token: "token-sementara-bypass" // AuthService membutuhkan key token ini
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