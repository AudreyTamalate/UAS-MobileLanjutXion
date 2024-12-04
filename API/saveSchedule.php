<?php
require_once "schedule.php";

header("Content-Type: application/json");

$schedule = new Schedule($mysqli); // Menggunakan koneksi mysqli
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'POST':
        $data = json_decode(file_get_contents("php://input"));
        if (!empty($data->film_id) && !empty($data->studio) && !empty($data->day) && !empty($data->time)) {
            $result = $schedule->addSchedule($data->film_id, $data->studio, $data->day, $data->time);
            echo json_encode(["message" => $result ? "Schedule added successfully." : "Failed to add schedule."]);
        } else {
            echo json_encode(["message" => "Incomplete data."]);
        }
        break;

    case 'GET':
        if (!empty($_GET['film_id'])) {
            $schedules = $schedule->getSchedules($_GET['film_id']);
            echo json_encode($schedules);
        } else {
            echo json_encode(["message" => "Film ID is required"]);
        }
        break;

    case 'DELETE':
        $data = json_decode(file_get_contents("php://input"));
        if (!empty($data->id)) {
            $result = $schedule->deleteSchedule($data->id);
            echo json_encode(["message" => $result ? "Schedule deleted successfully." : "Failed to delete schedule."]);
        } else {
            echo json_encode(["message" => "ID is required to delete schedule."]);
        }
        break;

    default:
        http_response_code(405);
        echo json_encode(["message" => "Method not allowed."]);
        break;
}
?>
