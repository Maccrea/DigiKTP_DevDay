import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.3"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}
const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    status,
  })

serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const { nfc_uid, id_instansi, email_terpilih } = await req.json()
    if (!nfc_uid || !email_terpilih) {
      return json({ error: 'nfc_uid dan email_terpilih wajib diisi' }, 400)
    }

    const { data: wargaData, error: wargaError } = await supabase
      .from('users_warga')
      .select('nik, nama_lengkap')
      .eq('uid_nfc', nfc_uid)
      .maybeSingle()

    if (wargaError) return json({ error: `DB Error: ${wargaError.message}` }, 500)
    if (!wargaData) return json({ error: `KTP dengan UID ${nfc_uid} belum diregistrasi.` }, 404)

    const generatedOtp = Math.floor(100000 + Math.random() * 900000).toString()

    const { error: insertError } = await supabase
      .from('otp_requests')
      .insert({
        citizen_uid: nfc_uid,              // <-- sebelumnya wargaData.id (undefined)
        instansi_id: id_instansi || null,
        email_tujuan: email_terpilih,
        otp_code: generatedOtp,
        status: 'pending',
      })
    if (insertError) throw insertError

    const emailRes = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${Deno.env.get('RESEND_API_KEY')}`,
      },
      body: JSON.stringify({
        from: 'Pemerintah Digital <admin@nikkita-bos.id>',
        to: email_terpilih,
        subject: 'Kode OTP Konfirmasi Data KTP',
        html: `<p>Halo ${wargaData.nama_lengkap},</p><p>Anda diminta untuk memberikan persetujuan akses data KTP.</p><h2>Kode OTP Anda: ${generatedOtp}</h2><p>Berikan kode ini kepada petugas.</p>`,
      }),
    })
    if (!emailRes.ok) {
      throw new Error(`Gagal mengirim email: ${JSON.stringify(await emailRes.json())}`)
    }

    return json({ success: true, message: `OTP berhasil dibuat dan dikirim ke ${email_terpilih}.` })
  } catch (err) {
    return json({ success: false, error: (err as Error).message }, 500)
  }
})