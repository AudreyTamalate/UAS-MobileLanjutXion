<?php
require_once "film.php";

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

$film = new Film($mysqli); // Menggunakan koneksi mysqli
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        try {
            $films = $film->getFilms();
            echo json_encode($films);
        } catch (Exception $e) {
            echo json_encode(["error" => $e->getMessage()]);
        }
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"));
        if (!empty($data->film_title) && !empty($data->image)) {
            $result = $film->addFilm($data->film_title, $data->image);
            echo json_encode(["message" => $result ? "Film added successfully." : "Failed to add film."]);
        } else {
            echo json_encode(["message" => "Incomplete data."]);
        }
        break;

    case 'DELETE':
        $data = json_decode(file_get_contents("php://input"));
        if (!empty($data->id)) {
            $result = $film->deleteFilm($data->id);
            echo json_encode(["message" => $result ? "Film deleted successfully." : "Failed to delete film."]);
        } else {
            echo json_encode(["message" => "ID is required to delete film."]);
        }
        break;

    case 'OPTIONS':
        http_response_code(204);
        break;

    default:
        http_response_code(405);
        echo json_encode(["message" => "Method not allowed."]);
        break;
}
?>
