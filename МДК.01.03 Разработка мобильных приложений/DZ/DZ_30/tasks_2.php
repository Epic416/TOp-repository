<?php
// --- ДОБАВИТЬ ЭТИ СТРОКИ В САМОМ ВЕРХУ ---
header("Access-Control-Allow-Origin: *"); // Разрешить запросы с любого источника (для разработки)
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Разрешенные методы
header("Access-Control-Allow-Headers: Content-Type, Authorization"); // Разрешенные заголовки

// Обработка preflight-запроса (браузер спрашивает разрешение перед POST/PUT)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}
// -----------------------------------------

header('Content-Type: application/json; charset=utf-8');

$conn = new mysqli("localhost", "root", "", "flutter_db2");
$conn->set_charset("utf8");

// новый фрагмент
$action = $_POST['action'] ?? $_GET['action'] ?? '';

if ($action === 'read' || $action === '') {
    // тут новая часть
    $favorite = $_POST['favorite'] ?? 'all';
    $sql = "SELECT * FROM tasks";
    if ($favorite === 'true') {
        $sql .= " WHERE is_favorite = 1";
    }

    $result = $conn->query($sql);

    $tasks = [];
    while ($row = $result->fetch_assoc()) {
        $tasks[] = $row;
    }
    echo json_encode(["tasks" => $tasks], JSON_UNESCAPED_UNICODE);
}

// СОЗДАНИЕ (POST)
if ($action === 'create') {
    $title = $_POST['title'] ?? '';
    $conn->query("INSERT INTO tasks (title) VALUES ('$title')");
    echo json_encode(["success" => true], JSON_UNESCAPED_UNICODE);
}

// УДАЛЕНИЕ (POST)
if ($action === 'delete') {
    $id = $_POST['id'] ?? 0;
    $conn->query("DELETE FROM tasks WHERE id = $id");
    echo json_encode(["success" => true], JSON_UNESCAPED_UNICODE);
}

// ОБНОВЛЕНИЕ (POST)
if ($action === 'update') {
    $id = $_POST['id'] ?? 0;
    $title = $_POST['title'] ?? '';
    $conn->query("UPDATE tasks SET title = '$title' WHERE id = $id");
    echo json_encode(["success" => true], JSON_UNESCAPED_UNICODE);
}

// ДОБАВЛЕНИЕ В ИЗБРАННОЕ (POST)
if ($action === 'toggle_favorite') {
    $id = $_POST['id'] ?? 0;
    
    // Логика переключения: если было 1, станет 0; если 0 - станет 1
    $sql = "UPDATE tasks SET is_favorite = IF(is_favorite = 1, 0, 1) WHERE id = ?";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $id);
    $stmt->execute();
    
    echo json_encode(["success" => true], JSON_UNESCAPED_UNICODE);
}

$conn->close();
?>


