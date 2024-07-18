<?php
require 'vendor/autoload.php'; // Đường dẫn đến autoload.php của composer

// Sử dụng các namespace của thư viện PayPal
use PayPal\Api\WebhookEvent;
use PayPal\Rest\ApiContext;
use PayPal\Auth\OAuthTokenCredential;

// Thiết lập API Context với Client ID và Secret của bạn
$apiContext = new ApiContext(
    new OAuthTokenCredential(
        'AWLnlUJDU_F6-eY-3U5i21GSDwExVXalL6anoG1YQvMu2dqoeHwpmXDQf6V9g3lCzYOoTkSrblrxFzwF',
        'EBRNnsxzsRi48qx_8U_azTA-Tfh_9k803Wj5fhwJxMHLlDIoqh3GEL9IFKX8ozBAtZRZlGtyRJtZ4g_x'
    )
);

// Lấy dữ liệu từ request
$body = file_get_contents('php://input');

// Tạo một đối tượng WebhookEvent
$webhookEvent = new WebhookEvent();
$webhookEvent->fromJson($body);

// Xử lý sự kiện dựa trên loại sự kiện
$event_type = $webhookEvent->event_type;
$resource = $webhookEvent->resource;

// Kiểm tra xem sự kiện có phải là thanh toán thành công hay không
if ($event_type === 'PAYMENT.CAPTURE.COMPLETED') {
    // Lấy thông tin về thanh toán
    $amount = $resource->amount->value;
    $currency = $resource->amount->currency_code;

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
