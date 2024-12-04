<?php
require_once "koneksi.php";

class Payment {
    // Payment processing method
    public function payment($data) {
        global $mysqli;

        // Extract and sanitize input
        $film = $mysqli->real_escape_string($data['film']);
        $studio = $mysqli->real_escape_string($data['studio']);
        $day = $mysqli->real_escape_string($data['day']);
        $time = $mysqli->real_escape_string($data['time']);
        $seats = $data['seats']; // Array of seats
        $total = (int)$data['total'];
        $payment = $mysqli->real_escape_string($data['payment']);

        // Step 1: Check if the seats are already booked
        $stmt_check = $mysqli->prepare("SELECT seats FROM purchase WHERE film = ? AND studio = ? AND day = ? AND time = ?");
        $stmt_check->bind_param('ssss', $film, $studio, $day, $time);
        $stmt_check->execute();
        $result_check = $stmt_check->get_result();

        $booked_seats = [];
        while ($row = $result_check->fetch_assoc()) {
            $booked_seats = array_merge($booked_seats, explode(", ", $row['seats']));
        }

        $overlap = array_intersect($seats, $booked_seats);
        if (!empty($overlap)) {
            return [
                'status' => 400,
                'message' => 'Some seats are already booked: ' . implode(", ", $overlap)
            ];
        }

        // Step 2: Insert new booking if seats are available
        $seats_string = $mysqli->real_escape_string(implode(", ", $seats)); // Convert array to string
        $stmt = $mysqli->prepare("INSERT INTO purchase (film, studio, day, time, seats, total, payment) VALUES (?, ?, ?, ?, ?, ?, ?)");

        if ($stmt) {
            $stmt->bind_param('sssssis', $film, $studio, $day, $time, $seats_string, $total, $payment);

            if ($stmt->execute()) {
                return [
                    'status' => 200,
                    'message' => 'Payment success.'
                ];
            }
        }

        return [
            'status' => 400,
            'message' => 'Payment failed.'
        ];
    }

    // Method to fetch purchase history
    public function getPurchaseHistory() {
        global $mysqli;
        
        $sql = "SELECT * FROM purchase";
        $result = $mysqli->query($sql);
        
        $purchaseHistory = [];

        while ($row = $result->fetch_assoc()) {
            $purchaseHistory[] = $row;
        }
        
        return $purchaseHistory;
    }
}

// Handle API request
$data = json_decode(file_get_contents("php://input"), true);

if ($_SERVER['REQUEST_METHOD'] === 'POST' && $data) {
    // Handle payment request
    $payment = new Payment();
    $response = $payment->payment($data);

    // Output JSON response for payment
    header('Content-Type: application/json');
    echo json_encode($response);
    exit;
} elseif ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Handle purchase history request
    $payment = new Payment();
    $history = $payment->getPurchaseHistory();

    // Output JSON response for purchase history
    header('Content-Type: application/json');
    echo json_encode($history);
    exit;
} else {
    // Handle invalid request
    header('Content-Type: application/json');
    echo json_encode([
        'status' => 400,
        'message' => 'Invalid request.'
    ]);
    exit;
}
?>
