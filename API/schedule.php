<?php
require_once "koneksi.php";

class Schedule {
    private $conn;

    public function __construct($db) {
        $this->conn = $db;
    }

    public function addSchedule($film_id, $studio, $day, $time) {
        $query = "INSERT INTO schedules (film_id, studio, day, time) VALUES (?, ?, ?, ?)";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param('isss', $film_id, $studio, $day, $time);
        return $stmt->execute();
    }

    public function getSchedules($film_id) {
        $query = "SELECT * FROM schedules WHERE film_id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param('i', $film_id);
        $stmt->execute();
        $result = $stmt->get_result();
        return $result->fetch_all(MYSQLI_ASSOC);
    }

    public function deleteSchedule($id) {
        $query = "DELETE FROM schedules WHERE id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param('i', $id);
        return $stmt->execute();
    }
}
?>
