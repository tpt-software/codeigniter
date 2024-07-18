<?php
// Lấy dữ liệu từ request
$body = file_get_contents('php://input');
$json = json_decode($body);

// Kiểm tra xác thực từ PayPal
$headers = getallheaders();
$auth_signature = $headers['Paypal-Transmission-Sig'];
$auth_algo = $headers['Paypal-Transmission-Id'];
$transmission_id = $headers['Paypal-Transmission-Id'];

// Thay thế 'YOUR_CLIENT_ID' và 'YOUR_PAYPAL_SECRET' bằng thông tin xác thực của bạn
$client_id = 'AWLnlUJDU_F6-eY-3U5i21GSDwExVXalL6anoG1YQvMu2dqoeHwpmXDQf6V9g3lCzYOoTkSrblrxFzwF';
$paypal_secret = 'EBRNnsxzsRi48qx_8U_azTA-Tfh_9k803Wj5fhwJxMHLlDIoqh3GEL9IFKX8ozBAtZRZlGtyRJtZ4g_x';

// Xác thực thông báo sử dụng Client ID và PayPal Secret
$authString = base64_encode("{$client_id}:{$paypal_secret}");
$authHeaders = array(
    "Authorization: Basic {$authString}",
    "Paypal-Transmission-Sig: {$auth_signature}",
    "Paypal-Transmission-Id: {$transmission_id}",
);

// Gửi yêu cầu đến PayPal để xác thực chữ ký
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, "https://api.paypal.com/v1/notifications/verify-webhook-signature?auth_algo=SHA256&cert_url=");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, $body);
curl_setopt($ch, CURLOPT_HTTPHEADER, $authHeaders);

$response = curl_exec($ch);
curl_close($ch);

// Kiểm tra xác thực
if ($response === 'VERIFIED') {
    // Xác thực thành công, xử lý thông báo ở đây
    $event_type = $json->event_type;
    $event_resource = $json->resource;

    // Kiểm tra xem sự kiện có phải là thanh toán thành công hay không
    if ($event_type === 'PAYMENT.CAPTURE.COMPLETED') {
        // Lấy thông tin về thanh toán
        $amount = $event_resource->amount->value;
        $currency = $event_resource->amount->currency_code;

        // Kiểm tra xem có phải thanh toán 0.1 USD không
        if ($amount == '0.1' && $currency == 'USD') {
            // Xử lý thanh toán thành công ở đây
            // Ví dụ: hiển thị thông báo "Payment Success"
            echo "Payment Success";
        } else {
            // Xử lý thanh toán không thành công hoặc không đúng giá trị
            echo "Payment failed or invalid amount";
        }
    } else {
        // Xử lý các sự kiện khác nếu cần
        echo "Event type not handled";
    }
} else {
    // Xác thực thất bại, có thể là một tấn công
    http_response_code(403);
    echo 'Invalid signature';
}
?>
