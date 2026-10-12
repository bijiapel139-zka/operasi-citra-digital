clear; clc; close all;
% 1. MENYIAPKAN CITRA (Ukuran Harus Sama, misal: 512x512)
% Pastikan Anda mengunggah dua citra grayscale dengan dimensi yang sama.
img1_raw = imread('cabai.jpg');
img2_raw = imread('cabai_cilik.jpg');

% Konversi ke grayscale jika citra masih RGB
if size(img1_raw, 3) == 3, img1 = rgb2gray(img1_raw); else, img1 = img1_raw; end
if size(img2_raw, 3) == 3, img2 = rgb2gray(img2_raw); else, img2 = img2_raw; end

% Resizing paksa jika ukuran ternyata berbeda (opsional, jaga-jaga)
if size(img1) ~= size(img2)
    img2 = imresize(img2, size(img1));
end

[rows, cols] = size(img1);

% Tampilkan Citra Input Asli
figure('Name', 'Poin 1: Citra Asli');
subplot(1, 2, 1); imshow(img1); title('Citra 1 (Asli)');
subplot(1, 2, 2); imshow(img2); title('Citra 2 (Asli)');

% =========================================================================
% 2. OPERASI KOMPLEMEN (NEGASI)
% =========================================================================
% Rumus: g(x,y) = 255 - f(x,y)
img_komplemen = uint8(255) - img1; 

figure('Name', 'Poin 2: Operasi Komplemen');
subplot(1, 2, 1); imshow(img1); title('Citra 1 Asli');
subplot(1, 2, 2); imshow(img_komplemen); title('Citra 1 Komplemen');

% =========================================================================
% 3. OPERASI AND DAN OR UNTUK MASKING
% =========================================================================
% Membuat mask biner berupa lingkaran di tengah citra
[X, Y] = meshgrid(1:cols, 1:rows);
centerX = cols / 2;
centerY = rows / 2;
radius = min(rows, cols) / 4;
mask = uint8((X - centerX).^2 + (Y - centerY).^2 <= radius^2) * 255;

% Operasi Bitwise AND dan OR
img_and = bitand(img1, mask);
img_or  = bitor(img1, mask);

figure('Name', 'Poin 3: Masking (AND & OR)');
subplot(2, 2, 1); imshow(img1); title('Citra 1 Asli');
subplot(2, 2, 2); imshow(mask); title('Mask Biner');
subplot(2, 2, 3); imshow(img_and); title('Hasil Operasi AND');
subplot(2, 2, 4); imshow(img_or); title('Hasil Operasi OR');

% =========================================================================
% 4. OPERASI PENJUMLAHAN + NORMALISASI
% =========================================================================
% Menggunakan double untuk menghindari clipping prematur saat penjumlahan
img1_d = double(img1);
img2_d = double(img2);

img_sum_raw = img1_d + img2_d;

% Normalisasi: Skala ke range [0, 255]
img_sum_norm = uint8(255 * (img_sum_raw - min(img_sum_raw(:))) / (max(img_sum_raw(:)) - min(img_sum_raw(:))));

figure('Name', 'Poin 4: Image Addition');
subplot(1, 2, 1); imshow(uint8(img_sum_raw)); title('Penjumlahan Biasa (Clipped)');
subplot(1, 2, 2); imshow(img_sum_norm); title('Penjumlahan Dinormalisasi');

% =========================================================================
% 5. OPERASI PENGURANGAN + DUA METODE NORMALISASI
% =========================================================================
img_sub_raw = img1_d - img2_d;

% Metode Normalisasi 1: Skala Linier [Min-Max Stretching ke rentang 0-255]
min_val = min(img_sub_raw(:));
max_val = max(img_sub_raw(:));
img_sub_norm1 = uint8(255 * (img_sub_raw - min_val) / (max_val - min_val));

% Metode Normalisasi 2: Nilai Absolut (Menghilangkan nilai negatif)
img_sub_norm2 = uint8(abs(img_sub_raw));

figure('Name', 'Poin 5: Image Subtraction');
subplot(1, 3, 1); imshow(uint8(img_sub_raw)); title('Pengurangan Biasa (Clipped)');
subplot(1, 3, 2); imshow(img_sub_norm1); title('Metode 1: Min-Max Scale');
subplot(1, 3, 3); imshow(img_sub_norm2); title('Metode 2: Absolut');
