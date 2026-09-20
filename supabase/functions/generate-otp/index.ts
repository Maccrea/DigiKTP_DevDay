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
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const { nfc_uid, id_instansi } = await req.json()

    if (!nfc_uid) {
      return new Response(JSON.stringify({ error: 'nfc_uid wajib diisi' }), { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 })
    }

    const { data: wargaData, error: wargaError } = await supabase
      .from('users_warga')
      .select('email, nama_lengkap, nik')
      .eq('uid_nfc', nfc_uid)
      .single()

    if (wargaError || !wargaData) {
      return new Response(JSON.stringify({ error: 'KTP tidak terdaftar di sistem' }), { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 404 })
    }

    const generatedOtp = Math.floor(100000 + Math.random() * 900000).toString()

    const { error: insertError } = await supabase
      .from('otp_requests')
      .insert({
        citizen_uid: wargaData.nik,
        instansi_id: id_instansi || null,
        otp_code: generatedOtp,
        status: 'pending'
      })

    if (insertError) throw insertError

    const resendApiKey = Deno.env.get('RESEND_API_KEY')
    const emailRes = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${resendApiKey}`
      },
      body: JSON.stringify({
        from: 'Pemerintah Digital <onboarding@resend.dev>',
        to: wargaData.email, 
        subject: 'Kode OTP Konfirmasi Data KTP',
        html: `<p>Halo ${wargaData.nama_lengkap},</p><p>Anda diminta untuk memberikan persetujuan akses data KTP.</p><h2>Kode OTP Anda: ${generatedOtp}</h2><p>Berikan kode ini kepada petugas.</p>`
      })
    })

    if (!emailRes.ok) {
      const emailErr = await emailRes.json()
      throw new Error(`Gagal mengirim email: ${JSON.stringify(emailErr)}`)
    }

    // 6. Berhasil
    return new Response(
      JSON.stringify({ success: true, message: 'OTP berhasil dibuat dan dikirim ke email.' }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
    )

  } catch (err) {
    return new Response(
      JSON.stringify({ success: false, error: (err as Error).message }), 
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }
})