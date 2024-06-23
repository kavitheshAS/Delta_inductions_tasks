<?php
$servername = "db";
$username = "user1";
$password = "userpassword";
$dbname = "mydb";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Fetch users
$sql = "SELECT rollno, name, task_no, task_status FROM users";
$result = $conn->query($sql);
?>
<!DOCTYPE html>
<html>
<head>
    <title>User Details</title>
    <style>
        table {
            width: 50%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h1>User Details</h1>
    <table>
        <tr>
            <th>Roll No</th>
            <th>Name</th>
            <th>Task No</th>
            <th>Task Status</th>
        </tr>
        <?php
        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                echo "<tr>";
                echo "<td>" . $row["rollno"] . "</td>";
                echo "<td>" . $row["name"] . "</td>";
                echo "<td>" . $row["task_no"] . "</td>";
                echo "<td>" . ($row["task_status"] ? "Completed" : "Pending") . "</td>";
                echo "</tr>";
            }
        } else {
            echo "<tr><td colspan='4'>No users found</td></tr>";
        }
        $conn->close();
        ?>
    </table>
</body>
</html>
