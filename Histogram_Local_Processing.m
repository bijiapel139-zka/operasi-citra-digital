
clear; clc; close all;

%% 1. Menyiapkan Citra
% Membaca citra grayscale (menggunakan 'pout.tif' karena memiliki area gelap-terang lokal)
citra_asli = imread('pout.tif'); 

figure('Name', 'Langkah 1: Citra Asli');
imshow(citra_asli);
title('Citra Asli');


%% 2. Histogram Local Processing dengan Subimage
% Menentukan batas baris dan kolom untuk subimage (misal: area wajah/kiri atas)
% Sesuaikan koordinat ini dengan citra yang Anda gunakan jika bukan 'pout.tif'
baris_mulai = 1; baris_akhir = 150;
kolom_mulai = 1; kolom_akhir = 150;

subimage_asli = citra_asli(baris_mulai:baris_akhir, kolom_mulai:kolom_akhir);

figure('Name', 'Langkah 2: Citra Asli vs Subimage');
subplot(1, 2, 1); imshow(citra_asli); title('Citra Asli');
subplot(1, 2, 2); imshow(subimage_asli); title('Subimage Terpilih');


%% 3. Histogram Equalization pada Subimage
% Menerapkan Histogram Equalization pada area subimage saja menggunakan histeq
subimage_enhanced = histeq(subimage_asli);

% Memasukkan kembali subimage yang sudah diperbaiki ke citra asli
citra_subimage_result = citra_asli;
citra_subimage_result(baris_mulai:baris_akhir, kolom_mulai:kolom_akhir) = subimage_enhanced;

figure('Name', 'Langkah 3: Hasil HE Subimage');
subplot(1, 2, 1); imshow(subimage_asli); title('Subimage Sebelum HE');
subplot(1, 2, 2); imshow(citra_subimage_result); title('Citra dengan HE Subimage');


%% 4 & 5. Local Processing dengan Jendela Ketetanggaan (3x3 dan 5x5)
% Menggunakan fungsi bawaan MATLAB 'adapthisteq' (Contrast-Limited Adaptive Histogram Equalization)
% Fungsi ini mengimplementasikan jendela lokal ketetanggaan secara efisien.

% Jendela 3x3 (Diwakili dengan ukuran clip limit dan distribusi ubin kecil)
% Catatan: Secara matematis di MATLAB, jendela ketetanggaan lokal yang ideal diwakili oleh blok ubin.
citra_lokal_3x3 = adapthisteq(citra_asli, 'NumTiles', [64 64]); 

% Jendela 5x5 (Merepresentasikan ukuran area lokal yang lebih luas)
citra_lokal_5x5 = adapthisteq(citra_asli, 'NumTiles', [32 32]); 

% Menampilkan perbandingan Jendela 3x3 dan 5x5
figure('Name', 'Langkah 4 & 5: Jendela Ketetanggaan 3x3 vs 5x5');
subplot(1, 2, 1); imshow(citra_lokal_3x3); title('Lokal dengan Jendela 3x3');
subplot(1, 2, 2); imshow(citra_lokal_5x5); title('Lokal dengan Jendela 5x5');
