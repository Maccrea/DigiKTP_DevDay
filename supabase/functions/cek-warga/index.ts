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
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
    )

    const { nfc_uid } = await req.json()

    if (!nfc_uid) {
      return new Response(
        JSON.stringify({ error: 'nfc_uid wajib dikirim!' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 400 }
      )
    }

    const { data: biodata, error: errBiodata } = await supabase
      .from('users_warga')
      .select('nik, nama_lengkap, link_foto')
      .eq('uid_nfc', nfc_uid)
      .single()

    if (errBiodata || !biodata) {
      return new Response(
        JSON.stringify({ error: 'Data KTP tidak terdaftar.' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 404 }
      )
    }

    const { data: accounts, error: errAccounts } = await supabase
      .from('citizen_accounts')
      .select('email, is_primary')
      .eq('citizen_uid', nfc_uid)

    return new Response(
      JSON.stringify({
        status: 'success',
        warga: biodata,
        kontak: accounts || []
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 200 }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ error: 'Terjadi kesalahan server.', detail: (error as Error).message }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' }, status: 500 }
    )
  }
})