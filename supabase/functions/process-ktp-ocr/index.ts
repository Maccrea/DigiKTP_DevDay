// @ts-nocheck
import { createClient } from 'npm:@supabase/supabase-js'
import Jimp from 'npm:jimp@0.16.13'
import { Buffer } from 'node:buffer';

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
    const { uid_nfc, base64_image } = payload;

    if (!uid_nfc || !base64_image) {
      return new Response(
        JSON.stringify({ status: "error", message: "UID NFC dan foto KTP (base64) wajib dikirim!" }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 400 }
      );
    }

    const groqApiKey = Deno.env.get('GROQ_API_KEY');
    if (!groqApiKey) throw new Error("GROQ_API_KEY belum diatur di Supabase Secrets");

    const groqResponse = await fetch('https://api.groq.com/openai/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${groqApiKey}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        model: "qwen/qwen3.8-27b",
        messages: [
          {
            role: "user",
            content: [
              {
                type: "text",
                text: "Ekstrak informasi dari gambar KTP ini. Kembalikan HANYA dalam format objek JSON murni dengan key: nik, nama_lengkap, alamat. Jangan gunakan markdown block (seperti ```json) atau teks pengantar apa pun."
              },
              {
                type: "image_url",
                image_url: {
                  url: `data:image/jpeg;base64,${base64_image}`
                }
              }
            ]
          }
        ],
        temperature: 0.1,
        max_tokens: 1000
      })
    });

    if (!groqResponse.ok) {
      const errData = await groqResponse.json();
      throw new Error(`Gagal menghubungi Groq API: ${JSON.stringify(errData)}`);
    }

    const groqData = await groqResponse.json();
    const textResult = groqData.choices[0].message.content;
    
    let extractedData;
    try {
      extractedData = JSON.parse(textResult.trim());
    } catch (e) {
      throw new Error("Gagal membaca struktur KTP. Pastikan gambar jelas dan Groq mengembalikan JSON murni.");
    }

    const imageBuffer = Buffer.from(base64_image, 'base64');
    const image = await Jimp.read(imageBuffer);
    const font = await Jimp.loadFont(Jimp.FONT_SANS_32_BLACK);
    
    const namaKtp = extractedData.nama_lengkap || "Tidak Diketahui";
    const watermarkText = `KTP Asli Milik: ${namaKtp}`;
    
    image.print(font, 20, 20, watermarkText);
    const watermarkedBuffer = await image.getBufferAsync(Jimp.MIME_JPEG);

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '' 
    );

    const fileName = `${uid_nfc}-${Date.now()}.jpg`;
    const { error: storageError } = await supabase
      .storage
      .from('ktp_images')
      .upload(fileName, watermarkedBuffer, {
        contentType: 'image/jpeg',
        upsert: true
      });

    if (storageError) throw storageError;

    const { data: publicUrlData } = supabase
      .storage
      .from('ktp_images')
      .getPublicUrl(fileName);
    
    const photoUrl = publicUrlData.publicUrl;

    const { error: dbError } = await supabase
      .from('users_warga')
      .insert({
        uid_nfc: uid_nfc,
        nik: extractedData.nik || "-",
        nama_lengkap: namaKtp,
        alamat: extractedData.alamat || "-",
        link_foto: photoUrl
      });

    if (dbError) throw dbError;

    return new Response(
      JSON.stringify({ 
        status: "success", 
        message: "Data KTP berhasil diekstrak otomatis dan disimpan dengan watermark!",
        data: {
          ...extractedData,
          foto_url: photoUrl
        }
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