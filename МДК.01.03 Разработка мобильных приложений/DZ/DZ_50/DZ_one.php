<?php
// tasks_2.php - Рефакторинг с применением DIP

interface DatabaseInterface {
    public function connect();
    public function query(string $sql);
    public function close();
}

class MySQLDatabase implements DatabaseInterface {
    private $conn;

    public function __construct() {
        $this->conn = new mysqli("localhost", "root", "", "flutter_db2");
        $this->conn->set_charset("utf8");
    }

    public function connect() {
        return $this->conn->connect_errno ? false : true;
    }

    public function query(string $sql) {
        return $this->conn->query($sql);
    }

    public function close() {
        $this->conn->close();
    }
}

class TaskRepository {
    private $db;

    public function __construct(DatabaseInterface $db) {
        $this->db = $db;
    }

    public function getTasks(string $favorite = 'all') {
        $sql = "SELECT * FROM tasks";
        if ($favorite === 'true') {
            $sql .= " WHERE is_favorite = 1";
        }
        $result = $this->db->query($sql);
        $tasks = [];
        while ($row = $result->fetch_assoc()) {
            $tasks[] = $row;
        }
        return $tasks;
    }

    public function createTask(string $title) {
        $title = $this->db->conn->real_escape_string($title);
        return $this->db->query("INSERT INTO tasks (title) VALUES ('$title')");
    }

    public function deleteTask(int $id) {
        return $this->db->query("DELETE FROM tasks WHERE id = $id");
    }

    public function updateTask(int $id, string $title) {
        $title = $this->db->conn->real_escape_string($title);
        return $this->db->query("UPDATE tasks SET title = '$title' WHERE id = $id");
    }

    public function toggleFavorite(int $id) {
        return $this->db->query("UPDATE tasks SET is_favorite = 1 WHERE id = $id");
    }
}

header('Content-Type: application/json; charset=utf-8');

$db = new MySQLDatabase();
$repository = new TaskRepository($db);

$action = $_POST['action'] ?? $_GET['action'] ?? '';

if ($action === 'read' || $action === '') {
    $favorite = $_POST['favorite'] ?? 'all';
    $tasks = $repository->getTasks($favorite);
    echo json_encode(["tasks" => $tasks], JSON_UNESCAPED_UNICODE);
}

if ($action === 'create') {
    $title = $_POST['title'] ?? '';
    $repository->createTask($title);
    echo json_encode(["success" => true], JSON_UNESCAPED_UNICODE);
}

if ($action === 'delete') {
    $id = $_POST['id'] ?? 0;
    $repository->deleteTask((int)$id);
    echo json_encode(["success" => true], JSON_UNESCAPED_UNICODE);
}

if ($action === 'update') {
    $id = $_POST['id'] ?? 0;
    $title = $_POST['title'] ?? '';
    $repository->updateTask((int)$id, $title);
    echo json_encode(["success" => true], JSON_UNESCAPED_UNICODE);
}

if ($action === 'toggle_favorite') {
    $id = $_POST['id'] ?? 0;
    $repository->toggleFavorite((int)$id);
    echo json_encode(["success" => true], JSON_UNESCAPED_UNICODE);
}

$db->close();
?>