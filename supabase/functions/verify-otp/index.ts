import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.3"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
    )

    const { 
      nfc_uid, 
      otp_code, 
      id_petugas, 
      id_instansi, 
      lokasi_tugas, 
      jenis_layanan 
    } = await req.json()

    if (!nfc_uid || !otp_code || !id_petugas || !id_instansi) {
      return new Response(
        JSON.stringify({ error: 'Data request tidak lengkap (butuh nfc_uid, otp_code, id_petugas, id_instansi)' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    const { data: otpData, error: otpError } = await supabaseClient
      .from('otp_requests')
      .select('*')
      .eq('citizen_uid', nfc_uid)
      .eq('otp_code', otp_code)
      .eq('status', 'pending')
      .single()

    if (otpError || !otpData) {
      return new Response(
        JSON.stringify({ error: 'Kode OTP tidak valid atau sudah kadaluarsa.' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    await supabaseClient
      .from('otp_requests')
      .update({ status: 'verified' })
      .eq('id', otpData.id)

    const { data: wargaData, error: wargaError } = await supabaseClient
      .from('warga')
      .select('nik, uid_nfc, nama_lengkap, email, no_hp, tempat_tanggal_lahir, jenis_kelamin, alamat, agama')
      .eq('uid_nfc', nfc_uid)
      .single()

    if (wargaError || !wargaData) {
      return new Response(
        JSON.stringify({ error: 'Data warga tidak ditemukan di sistem.' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 404 }
      )
    }

    const { data: logData, error: logError } = await supabaseClient
      .from('layanan_log')
      .insert({
        nik_warga: wargaData.nik,
        id_petugas: id_petugas,
        id_instansi: id_instansi,
        lokasi_tugas: lokasi_tugas || 'Lokasi tidak diketahui',
        jenis_layanan: jenis_layanan || 'Pemindaian KTP Digital',
        status_transaksi: 'SUCCESS'
      })
      .select()
      .single()

    if (logError) {
      throw new Error(`Gagal mencatat log layanan: ${logError.message}`)
    }

    return new Response(
      JSON.stringify({
        status: 'success',
        message: 'OTP Valid! Data berhasil diambil dan dicatat.',
        warga: wargaData,
        log: logData     
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
    )

} catch (error) {
    return new Response(
      JSON.stringify({ 
        error: 'Terjadi kesalahan pada server backend.', 
        detail: (error as Error).message 
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }})