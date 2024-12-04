<?php
// Konfigurasi database
$host = "localhost";
$user = "root";
$password = "";
$database = "xion-cinema";

// Koneksi menggunakan mysqli
$mysqli = new mysqli($host, $user, $password, $database);

// Periksa koneksi
if ($mysqli->connect_error) {
    die("Koneksi mysqli gagal: " . $mysqli->connect_error);
}
?>
