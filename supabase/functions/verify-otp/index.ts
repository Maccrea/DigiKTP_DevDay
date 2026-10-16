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

    const { nfc_uid, otp_code, id_petugas, id_instansi, lokasi_tugas, jenis_layanan } =
      await req.json()

    if (!nfc_uid || !otp_code || !id_petugas || !id_instansi) {
      return json({ error: 'Data request tidak lengkap' }, 400)
    }

    const { data: wargaData, error: wargaError } = await supabase
      .from('users_warga')
      .select('*')
      .eq('uid_nfc', nfc_uid)
      .maybeSingle()

    if (wargaError || !wargaData) {
      return json({ error: 'Data warga tidak ditemukan di sistem.' }, 404)
    }

    // klaim OTP secara atomik + batas 2 menit
    const twoMinutesAgo = new Date(Date.now() - 2 * 60 * 1000).toISOString()
    const { data: claimed, error: claimError } = await supabase
      .from('otp_requests')
      .update({ status: 'verified' })
      .eq('otp_code', String(otp_code).trim())
      .eq('citizen_uid', nfc_uid)          // <-- sebelumnya wargaData.id (undefined)
      .eq('status', 'pending')
      .gte('created_at', twoMinutesAgo)
      .select()

    if (claimError || !claimed || claimed.length === 0) {
      return json({ error: 'Kode OTP salah, sudah dipakai, atau kadaluarsa.' }, 400)
    }
    const otpData = claimed[0]

    const randomNum = Math.floor(1000000 + Math.random() * 9000000)
    const dateCode = new Date().toISOString().slice(5, 10).replace('-', '')
    const generatedLogId = `TX-${randomNum}-${dateCode}-DKI`

    const { data: logData, error: logError } = await supabase
      .from('layanan_logs')
      .insert({
        id_log: generatedLogId,
        nik_warga: wargaData.nik,
        id_petugas,
        id_instansi,
        lokasi_tugas: lokasi_tugas || 'Lokasi tidak diketahui',
        jenis_layanan: jenis_layanan || 'Pemindaian KTP Digital',
        status_transaksi: 'SUCCESS',
      })
      .select()
      .single()

    if (logError) {
      // kembalikan OTP supaya bisa dicoba lagi
      await supabase.from('otp_requests').update({ status: 'pending' }).eq('id', otpData.id)
      throw new Error(`Gagal mencatat log layanan: ${logError.message}`)
    }

    return json({
      status: 'success',
      message: 'OTP Valid! Data berhasil diambil dan dicatat.',
      warga: wargaData,
      log: logData,
    })
  } catch (error) {
    return json(
      { error: 'Terjadi kesalahan pada server backend.', detail: (error as Error).message },
      500
    )
  }
})