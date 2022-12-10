# Digital-Lock-System


## Created By

Albertus Timothy Gunawan &nbsp;(2106651515)</br>
Eldisja Hadasa &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2106640133)</br>
Fatima Khairunnisa &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2106651515)</br>
Muhammad Fajri Alqomaril &nbsp;&nbsp;(2106651635) </br>


## Overview
`Digital Lock System adalah sistem keamanan yang memiliki dua metode diimplementasikan dengan FPGA (Field Programming Gate Array). Digital Lock System ini memiliki 6 input password dan fitur enskripsi untuk keamanan passwordnya. `

## How it works
`Digital Lock System memiliki dua metode. Metode pertama adalah pemeriksaan kesesuaian input semua password bedasarkan password yang telah disimpan di memory. Metode kedua adalah kesesuaian dua digit password yang diacak sesuai algoritma yang ditelah dibuat. Dimana jika user memasukkan password yang tepat, LED akan menyala yang menandakan slock sistem terbuka. Setelah sistem lock dibuka rangkaian akan kembali ke keadaan awal sebelum dimasukkan password oleh user.`

## Features
Berikut fitur-fitur yang digunakan


### 7-Segment
`7-Segment digunakan sebagai user interface untuk menampilkan password yang sedang diinput oleh user ke dalam Digital Lock System.`

### Debounce Algorithm
`Pada pengimplementasian Digital Lock System, digunakan button untuk memasukkan tiap angka password dan untuk me-reset rangkaian. Pada dasarnya, saat menekan button sering terjadi ketidakstablian sinyal yang disebabkan oleh button itu sendiri (saklar manual). Oleh karena itu, digunakan debounce algorithm untuk menstabilkan sinyal dari button agar dapat di proses oleh system tanpa kendala sehingga sinyal dapat diproses dengan efektif.`

### Encryption (Hashing)
`Hashing atau enkripsi password digunakan untuk mengamankan password yang dimiliki oleh user. Hashing juga digunakan untuk mempercepat proses pengecekan password dalam sistem keamanan ini. `

## Generate Random Number
`Generate Random Number digunakan untuk memilih digit kesekian yang harus dimasukkan user ke device agar lock system terbuka.`

## FSM
