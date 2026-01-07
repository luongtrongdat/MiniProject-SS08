CREATE DATABASE mini_project_ss08;
USE mini_project_ss08;

-- Xóa bảng nếu đã tồn tại (để chạy lại nhiều lần)
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS guests;

-- Bảng khách hàng
CREATE TABLE guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_name VARCHAR(100),
    phone VARCHAR(20)
);

-- Bảng phòng
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_type VARCHAR(50),
    price_per_day DECIMAL(10,0)
);

-- Bảng đặt phòng
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

INSERT INTO guests (guest_name, phone) VALUES
('Nguyễn Văn An', '0901111111'),
('Trần Thị Bình', '0902222222'),
('Lê Văn Cường', '0903333333'),
('Phạm Thị Dung', '0904444444'),
('Hoàng Văn Em', '0905555555');

INSERT INTO rooms (room_type, price_per_day) VALUES
('Standard', 500000),
('Standard', 500000),
('Deluxe', 800000),
('Deluxe', 800000),
('VIP', 1500000),
('VIP', 2000000);

INSERT INTO bookings (guest_id, room_id, check_in, check_out) VALUES
(1, 1, '2024-01-10', '2024-01-12'), -- 2 ngày
(1, 3, '2024-03-05', '2024-03-10'), -- 5 ngày
(2, 2, '2024-02-01', '2024-02-03'), -- 2 ngày
(2, 5, '2024-04-15', '2024-04-18'), -- 3 ngày
(3, 4, '2023-12-20', '2023-12-25'), -- 5 ngày
(3, 6, '2024-05-01', '2024-05-06'), -- 5 ngày
(4, 1, '2024-06-10', '2024-06-11'); -- 1 ngày
-- TRUY VẤN DỮ LIỆU CƠ BẢN
-- Liệt kê tên khách và số điện thoại của tất cả khách hàng
SELECT guest_name, phone
FROM guests;
-- Liệt kê các loại phòng khác nhau trong khách sạn
SELECT room_type
FROM rooms
GROUP BY room_type;
-- Hiển thị loại phòng và giá thuê theo ngày, sắp xếp theo giá tăng dần
SELECT *
FROM rooms
ORDER BY price_per_day;
-- Hiển thị các phòng có giá thuê lớn hơn 1.000.000
SELECT *
FROM rooms
WHERE price_per_day > 1000000;
-- Liệt kê các lần đặt phòng diễn ra trong năm 2024
SELECT *
FROM bookings
WHERE check_in >= '2024-01-01';
-- Cho biết số lượng phòng của từng loại phòng
SELECT room_type, COUNT(room_type) AS count_room
FROM rooms
GROUP BY room_type;
-- TRUY VẤN NÂNG CAO
/*
●	Hãy liệt kê danh sách các lần đặt phòng, Với mỗi lần đặt phòng, hãy hiển thị:
○	Tên khách hàng
○	Loại phòng đã đặt
○	Ngày nhận phòng (check_in)
*/
SELECT q.guest_name, r.room_type, b.check_in
FROM bookings b
JOIN guests q ON b.guest_id = q.guest_id
JOIN rooms r ON b.room_id = r.room_id;
-- Cho biết mỗi khách đã đặt phòng bao nhiêu lần
SELECT q.guest_name, COUNT(b.booking_id) AS count_time
FROM guests q
LEFT JOIN bookings b ON b.guest_id = q.guest_id
GROUP BY q.guest_id;
-- Tính doanh thu của mỗi phòng, với công thức: “Doanh thu = số ngày ở × giá thuê theo ngày”
SELECT room_id, SUM(DATEDIFF(check_out, check_in) * price_per_day) AS doanh_thu
FROM bookings
JOIN rooms USING (room_id)
GROUP BY room_id;
-- Hiển thị tổng doanh thu của từng loại phòng
SELECT room_type, SUM(DATEDIFF(check_out, check_in) * price_per_day) AS tong_doanh_thu
FROM bookings
JOIN rooms USING (room_id)
GROUP BY room_type;
-- Tìm những khách đã đặt phòng từ 2 lần trở lên
SELECT q.guest_name, COUNT(b.booking_id) AS count_time
FROM guests q
LEFT JOIN bookings b ON b.guest_id = q.guest_id
GROUP BY q.guest_id having count_time>=2;
-- Tìm loại phòng có số lượt đặt phòng nhiều nhất
SELECT room_type, COUNT(*) AS so_luot_dat
FROM bookings
JOIN rooms USING (room_id)
GROUP BY room_type
ORDER BY so_luot_dat DESC
LIMIT 1;
-- TRUY VẤN LỒNG
-- Phòng có giá thuê cao hơn giá trung bình của tất cả phòng
SELECT *
FROM rooms
WHERE price_per_day > (
    SELECT AVG(price_per_day)
    FROM rooms
);

-- Những khách chưa từng đặt phòng
SELECT *
FROM guests
WHERE guest_id NOT IN (
    SELECT DISTINCT guest_id
    FROM booking
);

-- Phòng được đặt nhiều lần nhất
SELECT *
FROM rooms
WHERE room_id = (
    SELECT room_id
    FROM booking
    GROUP BY room_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);
