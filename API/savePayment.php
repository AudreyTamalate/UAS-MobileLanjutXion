<?php
require_once "payment.php";

class SavePaymentController {
    public function handle_payment_request($data) {
        // Instantiate the Payment class
        $payment = new Payment();
        $response = $payment->payment($data);

        // Output JSON response
        header('Content-Type: application/json');
        echo json_encode($response);
        exit; // Ensure no further output
    }
}

// Read the raw POST data from request body
$data = json_decode(file_get_contents("php://input"), true);

if ($_SERVER['REQUEST_METHOD'] === 'POST' && $data) {
    // Pass data to the SavePaymentController
    $paymentController = new SavePaymentController();
    $paymentController->handle_payment_request($data);
} else {
    // Invalid request or method not allowed
    header('Content-Type: application/json');
    echo json_encode([
        'status' => 400,
        'message' => 'Payment failed.'
    ]);
    exit; // Ensure no further output
}
?>
