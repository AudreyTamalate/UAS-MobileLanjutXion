<?php
require_once "koneksi.php";

class Film {
    private $conn;

    public function __construct($db) {
        if ($db) {
            $this->conn = $db;
        } else {
            die("Database connection is not initialized.");
        }
    }

    // Menambahkan film baru ke database
    public function addFilm($film_title, $image) {
        try {
            $query = "INSERT INTO films (film_title, image) VALUES (?, ?)";
            $stmt = $this->conn->prepare($query);
            $stmt->bind_param('ss', $film_title, $image);
            return $stmt->execute();
        } catch (mysqli_sql_exception $e) {
            echo json_encode(["error" => $e->getMessage()]);
            return false;
        }
    }

    // Mengambil semua film dari database
    public function getFilms() {
        try {
            $query = "SELECT id, COALESCE(film_title, '') AS film_title, COALESCE(image, '') AS image FROM films";
            $result = $this->conn->query($query);
            return $result->fetch_all(MYSQLI_ASSOC);
        } catch (mysqli_sql_exception $e) {
            echo json_encode(["error" => $e->getMessage()]);
            return [];
        }
    }

    // Menghapus film berdasarkan ID
    public function deleteFilm($id) {
        try {
            $query = "DELETE FROM films WHERE id = ?";
            $stmt = $this->conn->prepare($query);
            $stmt->bind_param('i', $id);
            return $stmt->execute();
        } catch (mysqli_sql_exception $e) {
            echo json_encode(["error" => $e->getMessage()]);
            return false;
        }
    }
}
?>
