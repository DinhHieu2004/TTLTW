/*
 Navicat Premium Dump SQL

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80300 (8.3.0)
 Source Host           : localhost:3306
 Source Schema         : artgallery

 Target Server Type    : MySQL
 Target Server Version : 80300 (8.3.0)
 File Encoding         : 65001

 Date: 03/06/2025 19:42:48
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for artists
-- ----------------------------
DROP TABLE IF EXISTS `artists`;
CREATE TABLE `artists`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `bio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `birthDate` date NULL DEFAULT NULL,
  `nationality` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `photoUrl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `imageUrlCloud` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 85 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of artists
-- ----------------------------
INSERT INTO `artists` VALUES (1, 'Quỳnh Hoa', 'Quỳnh Hoa là một họa sĩ tranh cát ở Việt Nam.', '0014-08-30', 'Việt Nam', 'assets/images/artists/1-nghe-si-tranh-cat-quynh-hoa-2024-scaled.jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514398/assets/images/artists/egoyo0vfa4tcrtvjzpxb.jpg');
INSERT INTO `artists` VALUES (2, 'Trí Đức', 'Trí Đức là 1 họa sĩ tranh cát nỗi tiếng ở Việt Nam.', '1980-03-30', 'Việt Nam', 'assets/images/artists/Tri Duc.jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514530/assets/images/artists/pup9q2uqbloxqne3ezkg.jpg');
INSERT INTO `artists` VALUES (3, 'Nguyễn Tiến ', 'Nguyễn Tiến, sinh năm 1990 tại Nam Định, là một họa sĩ trẻ đầy tài năng và sáng tạo. Anh được biết đến rộng rãi với khả năng trình diễn vẽ tranh cát chuyên nghiệp, mang đến những tác phẩm nghệ thuật độc đáo và ấn tượng.\n\nTuổi thơ gắn liền với cát\n\nSinh ra và lớn lên tại vùng quê ven biển, tuổi thơ của Nguyễn Tiến gắn liền với những bãi cát trắng mịn. Chính những trò chơi vẽ lên cát lúc nhỏ đã khơi dậy trong anh niềm đam mê nghệ thuật và trở thành nguồn cảm hứng bất tận cho những tác phẩm sau này.', '1881-10-25', 'Việt Nam', 'assets/images/artists/OIP (2).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514461/assets/images/artists/scgt1fzajsg1gqf60pwk.jpg');
INSERT INTO `artists` VALUES (4, 'Phan Anh Vũ', 'Phan Anh Vũ - bậc thầy nghệ thuật tranh cát', '2000-01-01', 'Việt Nam', 'assets/images/artists/Hoa-si-Nguyen-Tien-1.jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514404/assets/images/artists/qe8prq8i6thg88gvlg2d.jpg');

-- ----------------------------
-- Table structure for daily_statistics
-- ----------------------------
DROP TABLE IF EXISTS `daily_statistics`;
CREATE TABLE `daily_statistics`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `totalSales` int NULL DEFAULT 0,
  `totalOrders` int NULL DEFAULT 0,
  `totalUsers` int NULL DEFAULT 0,
  `totalRevenue` decimal(10, 2) NULL DEFAULT 0.00,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `statDate`(`statDate` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of daily_statistics
-- ----------------------------

-- ----------------------------
-- Table structure for discount_code
-- ----------------------------
DROP TABLE IF EXISTS `discount_code`;
CREATE TABLE `discount_code`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `discount_percent` int NOT NULL,
  `start_time` datetime NULL DEFAULT NULL,
  `end_time` datetime NULL DEFAULT NULL,
  `trigger_event` enum('TIME_BASED','ORDER_SUCCESS') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of discount_code
-- ----------------------------
INSERT INTO `discount_code` VALUES (1, 'GIOVANG2025', 'Giảm giá giờ vàng 8h tối', 20, '2025-04-10 20:00:00', '2025-04-10 21:00:00', 'TIME_BASED', 1, '2025-04-10 20:37:39');
INSERT INTO `discount_code` VALUES (2, 'THANKU231Z', 'Cảm ơn bạn đã đặt hàng!', 10, NULL, NULL, 'ORDER_SUCCESS', 1, '2025-04-10 20:37:39');

-- ----------------------------
-- Table structure for discount_paintings
-- ----------------------------
DROP TABLE IF EXISTS `discount_paintings`;
CREATE TABLE `discount_paintings`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `discountId` int NOT NULL,
  `paintingId` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `discountId`(`discountId` ASC, `paintingId` ASC) USING BTREE,
  INDEX `discount_paintings_ibfk_2`(`paintingId` ASC) USING BTREE,
  INDEX `idx_dp_paintingId`(`paintingId` ASC) USING BTREE,
  INDEX `idx_dp_discountId`(`discountId` ASC) USING BTREE,
  CONSTRAINT `discount_paintings_ibfk_1` FOREIGN KEY (`discountId`) REFERENCES `discounts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `discount_paintings_ibfk_2` FOREIGN KEY (`paintingId`) REFERENCES `paintings` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of discount_paintings
-- ----------------------------
INSERT INTO `discount_paintings` VALUES (1, 1, 2);
INSERT INTO `discount_paintings` VALUES (2, 1, 3);
INSERT INTO `discount_paintings` VALUES (3, 1, 4);
INSERT INTO `discount_paintings` VALUES (4, 1, 5);
INSERT INTO `discount_paintings` VALUES (8, 1, 10);
INSERT INTO `discount_paintings` VALUES (11, 1, 13);
INSERT INTO `discount_paintings` VALUES (6, 1, 15);
INSERT INTO `discount_paintings` VALUES (9, 2, 7);
INSERT INTO `discount_paintings` VALUES (10, 2, 9);
INSERT INTO `discount_paintings` VALUES (14, 2, 31);
INSERT INTO `discount_paintings` VALUES (13, 2, 55);
INSERT INTO `discount_paintings` VALUES (15, 2, 61);
INSERT INTO `discount_paintings` VALUES (16, 3, 1);
INSERT INTO `discount_paintings` VALUES (17, 3, 21);
INSERT INTO `discount_paintings` VALUES (19, 3, 24);
INSERT INTO `discount_paintings` VALUES (18, 3, 25);

-- ----------------------------
-- Table structure for discounts
-- ----------------------------
DROP TABLE IF EXISTS `discounts`;
CREATE TABLE `discounts`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `imageUrl` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `imageUrlCloud` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `discountName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `discountPercentage` decimal(5, 2) NOT NULL,
  `startDate` date NOT NULL,
  `endDate` date NOT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  CONSTRAINT `discounts_chk_1` CHECK (`discountPercentage` between 0 and 100)
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of discounts
-- ----------------------------
INSERT INTO `discounts` VALUES (1, 'assets/images/artists/th.jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514510/assets/images/artists/ysfsbxeswka9lnn9azzb.jpg', 'Tri ân khách hàng', 25.00, '2024-12-12', '2026-04-14', '2024-12-15 01:19:44');
INSERT INTO `discounts` VALUES (2, 'assets/images/artists/th.jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514510/assets/images/artists/ysfsbxeswka9lnn9azzb.jpg', 'Chương trình giảm giá mùa xuân', 10.00, '2025-01-16', '2026-04-14', '2025-01-15 15:20:24');
INSERT INTO `discounts` VALUES (3, 'assets/images/artists/th.jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514510/assets/images/artists/ysfsbxeswka9lnn9azzb.jpg', 'Flash Sale', 50.00, '2025-04-11', '2026-04-30', '2025-04-11 19:07:03');

-- ----------------------------
-- Table structure for log
-- ----------------------------
DROP TABLE IF EXISTS `log`;
CREATE TABLE `log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `logTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `logWhere` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `resource` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `who` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `preData` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `flowData` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `level` enum('INFO','ALERT','WARNING','DANGER') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of log
-- ----------------------------
INSERT INTO `log` VALUES (26, '2025-04-04 22:44:34', NULL, '/web_war/admin/reviews/update', 'admin', 'Không xác định', '', 'WARNING');
INSERT INTO `log` VALUES (27, '2025-04-04 22:44:38', NULL, '/web_war/admin/reviews/update', 'admin', 'Không xác định', '', 'WARNING');
INSERT INTO `log` VALUES (28, '2025-04-07 11:03:55', NULL, '/web_war/admin/reviews/update', 'admin', 'Không xác định', '', 'WARNING');
INSERT INTO `log` VALUES (29, '2025-04-09 16:57:51', NULL, '/web_war/admin/reviews/update', 'admin', 'Không xác định', '', 'WARNING');

-- ----------------------------
-- Table structure for order_items
-- ----------------------------
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `orderId` int NULL DEFAULT NULL,
  `paintingId` int NULL DEFAULT NULL,
  `price` decimal(10, 2) NOT NULL,
  `sizeId` int NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sizeId`(`sizeId` ASC) USING BTREE,
  INDEX `order_items_ibfk_1`(`orderId` ASC) USING BTREE,
  INDEX `order_items_ibfk_2`(`paintingId` ASC) USING BTREE,
  INDEX `idx_order_items_orderId`(`orderId` ASC) USING BTREE,
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`orderId`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`paintingId`) REFERENCES `paintings` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `order_items_ibfk_3` FOREIGN KEY (`sizeId`) REFERENCES `sizes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 405 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of order_items
-- ----------------------------
INSERT INTO `order_items` VALUES (237, 210, 15, 3750000.00, 1, 1);
INSERT INTO `order_items` VALUES (238, 210, 3, 750000.00, 3, 1);
INSERT INTO `order_items` VALUES (366, 335, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (367, 335, 3, 1500000.00, 3, 2);
INSERT INTO `order_items` VALUES (368, 336, 1, 1000000.00, 2, 2);
INSERT INTO `order_items` VALUES (369, 337, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (370, 338, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (371, 338, 3, 1500000.00, 2, 2);
INSERT INTO `order_items` VALUES (372, 339, 5, 2250000.00, 1, 2);
INSERT INTO `order_items` VALUES (373, 340, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (374, 341, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (375, 342, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (376, 343, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (377, 344, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (378, 345, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (379, 345, 3, 750000.00, 1, 1);
INSERT INTO `order_items` VALUES (380, 346, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (381, 347, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (382, 348, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (383, 349, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (384, 350, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (385, 350, 21, 250000.00, 1, 1);
INSERT INTO `order_items` VALUES (386, 351, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (387, 351, 21, 250000.00, 1, 1);
INSERT INTO `order_items` VALUES (388, 352, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (389, 352, 21, 250000.00, 1, 1);
INSERT INTO `order_items` VALUES (390, 353, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (391, 354, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (392, 354, 2, 1500000.00, 1, 1);
INSERT INTO `order_items` VALUES (393, 355, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (397, 358, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (398, 358, 21, 250000.00, 1, 1);
INSERT INTO `order_items` VALUES (399, 359, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (400, 359, 2, 1500000.00, 1, 1);
INSERT INTO `order_items` VALUES (401, 360, 4, 750000.00, 1, 1);
INSERT INTO `order_items` VALUES (402, 361, 3, 1500000.00, 1, 2);
INSERT INTO `order_items` VALUES (403, 362, 1, 500000.00, 1, 1);
INSERT INTO `order_items` VALUES (404, 362, 2, 1500000.00, 1, 1);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int NULL DEFAULT NULL,
  `orderDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `totalAmount` decimal(10, 2) NOT NULL,
  `paymentStatus` enum('thanh toán thất bại','đã hủy thanh toán','đã thanh toán','chưa thanh toán') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `deliveryStatus` enum('chờ','hoàn thành','giao hàng thất bại','đã hủy giao hàng','đang giao') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'đang giao',
  `deliveryDate` date NULL DEFAULT NULL,
  `recipientName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `deliveryAddress` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `recipientPhone` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `paymentMethod` enum('COD','VNPay') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'COD',
  `vnpTxnRef` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `shippingFee` decimal(10, 2) NULL DEFAULT NULL,
  `appliedVoucherIds` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `totalPrice` decimal(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `userId`(`userId` ASC) USING BTREE,
  INDEX `idx_orders_user_status`(`userId` ASC, `deliveryStatus` ASC, `paymentStatus` ASC) USING BTREE,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 363 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (210, 4, '2025-04-11 19:03:47', 4500000.00, 'đã thanh toán', 'hoàn thành', '2025-04-11', 'Thượng Đình Hiệu', 'vĩnh phú 25, thuận an, Bình dương', '0909900900', 'COD', NULL, 315000.00, NULL, 4815000.00);
INSERT INTO `orders` VALUES (335, 11, '2025-05-06 23:57:40', 2000000.00, 'chưa thanh toán', 'đang giao', NULL, 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Bình dương', '0987654321', 'COD', NULL, 495000.00, NULL, 2495000.00);
INSERT INTO `orders` VALUES (336, 11, '2025-05-07 00:00:39', 1000000.00, 'chưa thanh toán', 'đang giao', NULL, 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Bình dương', '0987654321', 'COD', NULL, 315000.00, NULL, 1315000.00);
INSERT INTO `orders` VALUES (337, 11, '2025-05-07 16:13:07', 500000.00, 'đã thanh toán', 'hoàn thành', '2025-05-05', 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Bình dương', '0987654321', 'COD', NULL, 135000.00, '85,46', 450000.00);
INSERT INTO `orders` VALUES (338, 11, '2025-05-07 16:16:22', 2000000.00, 'đã thanh toán', 'hoàn thành', '2025-05-06', 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Bình dương', '0987654321', 'VNPay', '89537891', 415000.00, '85,47,75', 1520000.00);
INSERT INTO `orders` VALUES (339, 11, '2025-05-07 16:29:52', 2250000.00, 'chưa thanh toán', 'đang giao', NULL, 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Bình dương', '0987654321', 'COD', NULL, 235000.00, NULL, 2485000.00);
INSERT INTO `orders` VALUES (340, 11, '2025-05-12 15:26:44', 500000.00, 'chưa thanh toán', 'chờ', NULL, 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, binh dương', '0987654321', 'COD', NULL, 135000.00, NULL, 635000.00);
INSERT INTO `orders` VALUES (341, 4, '2025-05-12 16:11:47', 500000.00, 'chưa thanh toán', 'chờ', NULL, 'Thượng Đình Hiệu', 'vĩnh phú 25, thuận an, binh dương', '0909900900', 'COD', NULL, 135000.00, NULL, 635000.00);
INSERT INTO `orders` VALUES (342, 11, '2025-05-12 16:12:57', 500000.00, 'chưa thanh toán', 'chờ', NULL, 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Bình dương', '0987654321', 'COD', NULL, 135000.00, NULL, 635000.00);
INSERT INTO `orders` VALUES (343, 11, '2025-05-12 16:54:52', 500000.00, 'đã thanh toán', 'chờ', NULL, 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, binh dương', '0987654321', 'VNPay', '58200552', 135000.00, NULL, 635000.00);
INSERT INTO `orders` VALUES (344, 11, '2025-05-12 17:01:34', 500000.00, 'đã thanh toán', 'hoàn thành', '2025-06-03', 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, binh dương', '0987654321', 'VNPay', '20160271', 135000.00, NULL, 635000.00);
INSERT INTO `orders` VALUES (345, 11, '2025-05-12 21:37:01', 1250000.00, 'chưa thanh toán', 'chờ', NULL, 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, binh dương', '0987654321', 'COD', NULL, 235000.00, NULL, 1485000.00);
INSERT INTO `orders` VALUES (346, 11, '2025-05-12 21:41:47', 500000.00, 'chưa thanh toán', 'hoàn thành', '2025-06-03', 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Bình dương', '0987654321', 'COD', NULL, 135000.00, NULL, 635000.00);
INSERT INTO `orders` VALUES (347, 11, '2025-05-14 20:32:22', 500000.00, 'chưa thanh toán', 'đang giao', NULL, 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Bình dương', '0987654321', 'COD', NULL, 135000.00, '15', 575000.00);
INSERT INTO `orders` VALUES (348, 4, '2025-05-28 23:03:10', 500000.00, 'đã thanh toán', 'chờ', NULL, 'Thượng Đình Hiệu', 'vĩnh phú 25, thuận an, Bình dương', '0909900900', 'VNPay', '57473330', 135000.00, '4', 585000.00);
INSERT INTO `orders` VALUES (349, 4, '2025-05-28 23:07:17', 500000.00, 'đã thanh toán', 'chờ', NULL, 'Thượng Đình Hiệu', 'vĩnh phú 25, thuận an, Bình dương', '0909900900', 'VNPay', '97906785', 135000.00, NULL, 635000.00);
INSERT INTO `orders` VALUES (350, 20, '2025-06-02 08:42:37', 750000.00, 'chưa thanh toán', 'hoàn thành', '2025-06-02', 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, binh dương', '0111131111', 'COD', NULL, 235000.00, NULL, 985000.00);
INSERT INTO `orders` VALUES (351, 20, '2025-06-02 09:00:23', 750000.00, 'đã thanh toán', 'hoàn thành', '2025-06-02', 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Bình dương', '0111131111', 'VNPay', '53570467', 235000.00, NULL, 985000.00);
INSERT INTO `orders` VALUES (352, 20, '2025-06-02 09:06:14', 750000.00, 'chưa thanh toán', 'hoàn thành', '2025-06-03', 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Bình dương', '0111131111', 'COD', NULL, 235000.00, NULL, 985000.00);
INSERT INTO `orders` VALUES (353, 20, '2025-06-02 09:13:03', 500000.00, 'chưa thanh toán', 'hoàn thành', '2025-06-02', 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Hà Nội', '0111131111', 'COD', NULL, 32000.00, NULL, 532000.00);
INSERT INTO `orders` VALUES (354, 20, '2025-06-02 09:21:35', 2000000.00, 'chưa thanh toán', 'hoàn thành', '2025-06-02', 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Bình dương', '0111131111', 'COD', NULL, 235000.00, NULL, 2235000.00);
INSERT INTO `orders` VALUES (355, 20, '2025-06-03 08:45:03', 500000.00, 'đã thanh toán', 'hoàn thành', '2025-06-03', 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Bình dương', '0111131111', 'VNPay', '01342878', 135000.00, NULL, 635000.00);
INSERT INTO `orders` VALUES (358, 20, '2025-06-03 16:37:19', 750000.00, 'chưa thanh toán', 'hoàn thành', '2025-06-03', 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Bình dương', '0111131111', 'COD', NULL, 235000.00, NULL, 985000.00);
INSERT INTO `orders` VALUES (359, 20, '2025-06-03 17:01:39', 2000000.00, 'chưa thanh toán', 'đang giao', NULL, 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Bình dương', '0111131111', 'COD', NULL, 235000.00, NULL, 2235000.00);
INSERT INTO `orders` VALUES (360, 20, '2025-06-03 17:31:42', 750000.00, 'chưa thanh toán', 'hoàn thành', '2025-06-03', 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Bình dương', '0111131111', 'COD', NULL, 135000.00, NULL, 885000.00);
INSERT INTO `orders` VALUES (361, 20, '2025-06-03 17:42:04', 1500000.00, 'chưa thanh toán', 'chờ', NULL, 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Bình dương', '0111131111', 'COD', NULL, 235000.00, NULL, 1735000.00);
INSERT INTO `orders` VALUES (362, 20, '2025-06-03 17:45:44', 2000000.00, 'chưa thanh toán', 'chờ', NULL, 'Đỗ Khắc Hảo', 'vĩnh phú 25, thuận an, Bình dương', '0111131111', 'COD', NULL, 235000.00, NULL, 2235000.00);

-- ----------------------------
-- Table structure for painting_sizes
-- ----------------------------
DROP TABLE IF EXISTS `painting_sizes`;
CREATE TABLE `painting_sizes`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `paintingId` int NOT NULL,
  `sizeId` int NOT NULL,
  `totalQuantity` int NULL DEFAULT NULL,
  `displayQuantity` int NULL DEFAULT NULL,
  `reservedQuantity` int NULL DEFAULT 0,
  `sizeDescription` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `weight` double NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `paintingId`(`paintingId` ASC, `sizeId` ASC) USING BTREE,
  INDEX `sizeId`(`sizeId` ASC) USING BTREE,
  CONSTRAINT `painting_sizes_ibfk_1` FOREIGN KEY (`paintingId`) REFERENCES `paintings` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `painting_sizes_ibfk_2` FOREIGN KEY (`sizeId`) REFERENCES `sizes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 397 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of painting_sizes
-- ----------------------------
INSERT INTO `painting_sizes` VALUES (4, 2, 1, 100, 77, 3, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (5, 2, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (6, 2, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (10, 4, 1, 100, 78, 2, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (11, 4, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (12, 4, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (19, 7, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (20, 7, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (21, 7, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (22, 8, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (23, 8, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (24, 8, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (25, 9, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (26, 9, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (27, 9, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (64, 15, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (65, 15, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (66, 15, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (79, 3, 3, 98, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (80, 3, 1, 100, 77, 3, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (81, 3, 2, 100, 78, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (94, 20, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (95, 20, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (96, 20, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (100, 22, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (101, 22, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (102, 22, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (106, 16, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (107, 16, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (108, 16, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (118, 21, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (119, 21, 1, 100, 76, 4, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (120, 21, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (157, 24, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (158, 24, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (159, 24, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (160, 25, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (161, 25, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (162, 25, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (163, 26, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (164, 26, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (165, 26, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (166, 27, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (167, 27, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (168, 27, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (169, 28, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (170, 28, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (171, 28, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (172, 29, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (173, 29, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (174, 29, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (175, 30, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (176, 30, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (177, 30, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (178, 31, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (179, 31, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (180, 31, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (181, 32, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (182, 32, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (183, 32, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (184, 33, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (185, 33, 1, 110, 90, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (186, 33, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (187, 1, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (188, 1, 1, 99, 60, 18, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (189, 1, 2, 98, 79, 1, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (190, 34, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (191, 34, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (192, 34, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (193, 35, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (194, 35, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (195, 35, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (196, 36, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (197, 36, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (198, 36, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (199, 10, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (200, 10, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (201, 10, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (202, 5, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (203, 5, 1, 98, 77, 1, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (204, 5, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (205, 12, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (206, 12, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (207, 12, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (208, 13, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (209, 13, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (210, 13, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (217, 19, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (218, 19, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (219, 19, 2, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (241, 18, 3, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (242, 18, 1, 100, 80, 0, NULL, NULL);
INSERT INTO `painting_sizes` VALUES (243, 18, 2, 100, 80, 0, NULL, NULL);

-- ----------------------------
-- Table structure for paintings
-- ----------------------------
DROP TABLE IF EXISTS `paintings`;
CREATE TABLE `paintings`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `themeId` int NULL DEFAULT NULL,
  `price` decimal(10, 2) NOT NULL,
  `artistId` int NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `imageUrl` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `imageUrlCloud` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `isSold` tinyint(1) NULL DEFAULT 0,
  `isFeatured` tinyint(1) NULL DEFAULT 0,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `themeId`(`themeId` ASC) USING BTREE,
  INDEX `artistId`(`artistId` ASC) USING BTREE,
  INDEX `idx_painting_title`(`title` ASC) USING BTREE,
  INDEX `idx_painting_price`(`price` ASC) USING BTREE,
  INDEX `idx_painting_createdAt`(`createdAt` ASC) USING BTREE,
  INDEX `idx_painting_artistId`(`artistId` ASC) USING BTREE,
  INDEX `idx_painting_themeId`(`themeId` ASC) USING BTREE,
  INDEX `idx_painting_isSold`(`isSold` ASC) USING BTREE,
  INDEX `idx_painting_isFeatured`(`isFeatured` ASC) USING BTREE,
  INDEX `idx_theme_artist_price`(`themeId` ASC, `artistId` ASC, `price` ASC) USING BTREE,
  CONSTRAINT `paintings_ibfk_1` FOREIGN KEY (`themeId`) REFERENCES `themes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `paintings_ibfk_2` FOREIGN KEY (`artistId`) REFERENCES `artists` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 110 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of paintings
-- ----------------------------
INSERT INTO `paintings` VALUES (1, 'Tranh cảnh biển', 3, 1000000.00, 3, 'Tranh cảnh biển được họa sĩ Tri Đức vẽ lại khi đi giả ngoại', 'assets/images/artists/OIP.jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514463/assets/images/artists/h3ptcvhb1jzad9ges9w5.jpg', 0, 1, '2024-12-14 14:44:08');
INSERT INTO `paintings` VALUES (2, 'Làng', 3, 2000000.00, 1, 'Tranh cảnh biển được họa sĩ Quỳnh Hoa vẽ lại khi về thăm nhà', 'assets/images/artists/DSC01805.JPG', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514401/assets/images/artists/gmivqc7lsptqput0r5rn.jpg', 0, 1, '2024-12-14 14:44:08');
INSERT INTO `paintings` VALUES (3, 'Quê tôi', 2, 1000000.00, 2, 'Tranh quê được họa sĩ Quỳnh Hoa vẽ lại khi về thăm nhà', 'assets/images/artists/DSC01805.JPG', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514401/assets/images/artists/gmivqc7lsptqput0r5rn.jpg', 0, 1, '2024-12-14 14:44:08');
INSERT INTO `paintings` VALUES (4, 'Quê hương', 1, 1000000.00, 4, 'Tác phẩm quê hương được họa sĩ Phan Anh Vẽ lại khi vè thăm nhà', 'assets/images/artists/tranh-cat-6.jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514517/assets/images/artists/wgfslo03vhlxrj9udqvm.jpg', 0, 0, '2024-12-14 14:44:08');
INSERT INTO `paintings` VALUES (5, 'chăn trâu', 1, 1500000.00, 4, 'Tác phẩm hoa sen được họa sĩ Phan Anh Vẽ lại khi vè thăm nhà', 'assets/images/artists/R.jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514467/assets/images/artists/tsthwkfmda7hgb3oqef7.jpg', 0, 0, '2024-12-14 14:44:08');
INSERT INTO `paintings` VALUES (7, 'Huế', 2, 1500000.00, 3, 'Tác phẩm Huế  được họa sĩ Phan Anh Vẽ lại khi vè thăm nhà', 'assets/images/artists/OIP (1).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514464/assets/images/artists/rythppicjefr0ly1u7w3.jpg', 0, 0, '2024-12-14 14:44:08');
INSERT INTO `paintings` VALUES (8, 'Đi học', 1, 2000000.00, 1, 'Tác phẩm Đi Học  được họa sĩ Phan Anh Vẽ lại khi vè thăm nhà', 'assets/images/artists/tranh-cat-phu-nu-viet-nam.jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514524/assets/images/artists/aciwpr0fantw13ahflzk.jpg', 0, 0, '2024-12-14 14:44:08');
INSERT INTO `paintings` VALUES (9, 'Chiến thắng', 3, 2000000.00, 3, 'Tác phẩm Chiến Thắng  được họa sĩ Phan Anh Vẽ lại khi vè thăm nhà', 'assets/images/artists/tranh-cat-phong-canh6-1024x930.jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514519/assets/images/artists/xnjgnacra15xzb8iyeor.jpg', 0, 0, '2024-12-14 14:44:08');
INSERT INTO `paintings` VALUES (10, 'Hoa sen', 1, 2000000.00, 3, 'Tác phẩm Chăn Trâu  được họa sĩ Trí Đức Vẽ lại khi vè thăm nhà', 'assets/images/artists/tranh-cat-phong-thuy-ca-sen2-1024x930.jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514522/assets/images/artists/ntoe967anzjy8bctmjro.jpg', 0, 0, '2024-12-14 14:44:08');
INSERT INTO `paintings` VALUES (12, 'Quê tôi', 3, 200000.00, 2, 'Để am hiểu những bức tranh trừu tượng độc đáo, bạn cần phải hiểu rõ khái niệm về tranh trừu tượng, những ý nghĩa ẩn sâu bên trong từng nét vẽ của người họa sĩ. Nếu bạn nắm rõ những điều căn bản trên, nghệ thuật trừu tượng đảm bảo sẽ đem đến cái nhìn khác cho người xem, chinh phục được cả những người đam mê nghệ thuật khó tính nhất.', 'assets/images/artists/OIP.jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514463/assets/images/artists/h3ptcvhb1jzad9ges9w5.jpg', 0, 0, '2025-01-13 13:13:03');
INSERT INTO `paintings` VALUES (13, 'Bà tôi', 3, 500000.00, 2, 'Để am hiểu những bức tranh trừu tượng độc đáo, bạn cần phải hiểu rõ khái niệm về tranh trừu tượng, những ý nghĩa ẩn sâu bên trong từng nét vẽ của người họa sĩ. Nếu bạn nắm rõ những điều căn bản trên, nghệ thuật trừu tượng đảm bảo sẽ đem đến cái nhìn khác cho người xem, chinh phục được cả những người đam mê nghệ thuật khó tính nhất.', 'assets/images/artists/OIP_(1).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514464/assets/images/artists/rythppicjefr0ly1u7w3.jpg', 0, 0, '2025-01-13 13:15:26');
INSERT INTO `paintings` VALUES (15, 'Phố Xa', 2, 5000000.00, 4, 'Cảnh phố được nhìn thì góc của họa sĩ khi đang ở trong tù', 'assets/images/artists/R.jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514467/assets/images/artists/tsthwkfmda7hgb3oqef7.jpg', 0, 1, '2025-01-13 16:38:22');
INSERT INTO `paintings` VALUES (16, 'Tranh cát chảy vàng', 2, 200000.00, 4, 'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ', 'assets/images/artists/shopping_(1).webp', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514504/assets/images/artists/e61n3bxhzej9grqy73oz.webp', 0, 0, '2025-01-16 04:00:51');
INSERT INTO `paintings` VALUES (18, 'Tranh cát chảy đỏ', 4, 250000.00, 1, 'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ', 'assets/images/artists/shopping.webp', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514503/assets/images/artists/jltkkjkvcthzi7nrwkxw.webp', 0, 0, '2025-01-16 04:03:12');
INSERT INTO `paintings` VALUES (19, 'Tranh cát lục bảo', 4, 400000.00, 1, '', 'assets/images/artists/shopping_(3).webp', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514507/assets/images/artists/cnxza6ei3iptkme8b3nv.webp', 0, 0, '2025-01-16 04:04:16');
INSERT INTO `paintings` VALUES (20, 'Gia đình', 1, 2000000.00, 2, 'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ', 'assets/images/artists/images_(2).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514430/assets/images/artists/mdl9t2fluc5jtqxg6pxj.jpg', 0, 0, '2025-01-16 04:05:10');
INSERT INTO `paintings` VALUES (21, 'Tình yêu', 1, 500000.00, 2, 'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ', 'assets/images/artists/images_(1).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514410/assets/images/artists/lzccq8yj7x6jrgmd5fh0.jpg', 0, 0, '2025-01-16 04:05:55');
INSERT INTO `paintings` VALUES (22, 'Anh hùng', 1, 500000.00, 3, 'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ', 'assets/images/artists/images.jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514409/assets/images/artists/irvfhw7jrj9215s9lezg.jpg', 0, 0, '2025-01-16 04:07:06');
INSERT INTO `paintings` VALUES (24, 'Anh em', 1, 500000.00, 4, 'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.', 'assets/images/artists/images_(11).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514414/assets/images/artists/hsuqn0j8qydr28kfvkks.jpg', 0, 0, '2025-01-16 16:32:50');
INSERT INTO `paintings` VALUES (25, 'Ngày ta mười tám', 4, 400000.00, 1, 'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.', 'assets/images/artists/images_(10).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514412/assets/images/artists/uhpdhwhyb2sjniirsyoc.jpg', 0, 0, '2025-01-16 16:33:56');
INSERT INTO `paintings` VALUES (26, 'Bà ơi', 4, 300000.00, 2, 'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.', 'assets/images/artists/images_(9).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514456/assets/images/artists/wraxrvplj1zxutj4l4ce.jpg', 0, 0, '2025-01-16 16:34:52');
INSERT INTO `paintings` VALUES (27, 'Mẹ con', 4, 400000.00, 1, 'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.', 'assets/images/artists/images_(8).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514455/assets/images/artists/itddfl3ejrlrdo7aimle.jpg', 0, 0, '2025-01-16 16:35:43');
INSERT INTO `paintings` VALUES (28, 'Lâu đài cát', 4, 600000.00, 1, 'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.', 'assets/images/artists/images_(7).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514453/assets/images/artists/tp0x3wuapa6tre00gvwz.jpg', 0, 0, '2025-01-16 16:36:23');
INSERT INTO `paintings` VALUES (29, 'Núi bạc kim', 3, 700000.00, 1, 'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.', 'assets/images/artists/images_(6).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514452/assets/images/artists/k8zdxmw4ejkhtvgfplqj.jpg', 0, 0, '2025-01-16 16:37:18');
INSERT INTO `paintings` VALUES (30, 'Chị em', 2, 600000.00, 4, 'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.', 'assets/images/artists/images_(5).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514451/assets/images/artists/kjzprt1xrb3rzftpwtiw.jpg', 0, 0, '2025-01-16 16:45:24');
INSERT INTO `paintings` VALUES (31, 'Sống dai', 1, 300000.00, 3, 'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.', 'assets/images/artists/images_(4).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514450/assets/images/artists/sopvjecmhqr9jk8cjrto.jpg', 0, 0, '2025-01-16 16:46:12');
INSERT INTO `paintings` VALUES (32, 'Mắc biếc', 2, 200000.00, 4, 'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.', 'assets/images/artists/images_(3).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514445/assets/images/artists/gnh7gxnzekp2mc1ukqtf.jpg', 0, 0, '2025-01-16 16:47:05');
INSERT INTO `paintings` VALUES (33, 'Sóng', 4, 400000.00, 4, 'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.', 'assets/images/artists/images_(6).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514452/assets/images/artists/k8zdxmw4ejkhtvgfplqj.jpg', 0, 0, '2025-01-16 16:47:59');
INSERT INTO `paintings` VALUES (34, 'Tranh cát chảy hồng', 3, 400000.00, 2, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(12).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514415/assets/images/artists/djykzhvqxdnr2xjacuyg.jpg', 0, 0, '2025-01-16 22:39:27');
INSERT INTO `paintings` VALUES (35, 'tranh cát chảy tím', 3, 200000.00, 2, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(31).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514448/assets/images/artists/agsvwnkzose3pbj2yl0y.jpg', 0, 0, '2025-01-16 22:41:08');
INSERT INTO `paintings` VALUES (36, 'Hàng xóm', 4, 400000.00, 4, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(30).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514447/assets/images/artists/bmhdmruebadyqnkkwt9a.jpg', 0, 0, '2025-01-16 22:42:47');
INSERT INTO `paintings` VALUES (54, 'Bồ câu', 1, 600000.00, 1, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(29).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514444/assets/images/artists/rty2xexe7nwhbhc2vr0b.jpg', 0, 0, '2025-01-16 22:58:56');
INSERT INTO `paintings` VALUES (55, 'Nguời lính', 2, 600000.00, 2, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(28).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514443/assets/images/artists/p2d34rhuskcj78tl48u7.jpg', 0, 0, '2025-01-16 22:58:56');
INSERT INTO `paintings` VALUES (56, 'Gánh', 3, 600000.00, 3, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(27).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514442/assets/images/artists/bvirlcgjnkgoiai4sh2r.jpg', 0, 0, '2025-01-16 22:58:56');
INSERT INTO `paintings` VALUES (57, 'Gỉa gạo', 4, 600000.00, 4, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(26).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514440/assets/images/artists/rthbhsgrl9ncgnwfxwhy.jpg', 0, 0, '2025-01-16 22:58:56');
INSERT INTO `paintings` VALUES (58, 'Hải quân', 1, 600000.00, 1, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(25).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514438/assets/images/artists/wh7izkl6zhgkfvleh8ub.jpg', 0, 0, '2025-01-16 22:58:56');
INSERT INTO `paintings` VALUES (59, 'Cắm cờ trên nóc dinh độc lập', 2, 600000.00, 3, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(24).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514437/assets/images/artists/ij41gbbc5ltisp3q6rsc.jpg', 0, 0, '2025-01-16 22:58:56');
INSERT INTO `paintings` VALUES (60, 'Phật', 4, 600000.00, 2, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(23).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514435/assets/images/artists/jegtcf5c8itr1ksemxrb.jpg', 0, 0, '2025-01-16 22:58:56');
INSERT INTO `paintings` VALUES (61, 'Phụ nữ', 4, 600000.00, 4, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(22).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514434/assets/images/artists/itbtdckjxslrpuh8mo4g.jpg', 0, 0, '2025-01-16 22:58:56');
INSERT INTO `paintings` VALUES (62, 'Thánh gióng', 1, 600000.00, 1, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(21).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514432/assets/images/artists/hcubp7o2k9x8wpmz5rul.jpg', 0, 0, '2025-01-16 22:58:56');
INSERT INTO `paintings` VALUES (63, 'Vọng phu', 2, 600000.00, 2, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(20).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514431/assets/images/artists/hvxvdgfnqdx8izyzmoxj.jpg', 0, 0, '2025-01-16 22:58:56');
INSERT INTO `paintings` VALUES (64, 'Tình mẹ', 2, 600000.00, 3, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(19).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514428/assets/images/artists/ry7yt44qegv0p8g5ma76.jpg', 0, 0, '2025-01-16 22:58:56');
INSERT INTO `paintings` VALUES (65, 'Khởi nghĩa', 3, 600000.00, 4, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(18).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514424/assets/images/artists/ysgzhztayp2imcwfzsfq.jpg', 0, 0, '2025-01-16 22:58:56');
INSERT INTO `paintings` VALUES (66, 'Ước mơ', 3, 600000.00, 1, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(17).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514422/assets/images/artists/ilgs1k0cxq7ircklgkwp.jpg', 0, 0, '2025-01-16 22:58:56');
INSERT INTO `paintings` VALUES (67, 'Chăn trâu', 4, 600000.00, 2, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(16).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514421/assets/images/artists/d40dlucjkfl1gm2jkisw.jpg', 0, 0, '2025-01-16 22:58:56');
INSERT INTO `paintings` VALUES (68, 'Cảnh chìu', 1, 600000.00, 3, 'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ', 'assets/images/artists/images_(15).jpg', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514420/assets/images/artists/hr58diojgtm8ec7oeq9f.jpg', 0, 0, '2025-01-16 22:58:56');

-- ----------------------------
-- Table structure for password_reset_tokens
-- ----------------------------
DROP TABLE IF EXISTS `password_reset_tokens`;
CREATE TABLE `password_reset_tokens`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `password_reset_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of password_reset_tokens
-- ----------------------------
INSERT INTO `password_reset_tokens` VALUES (2, 2, '22310096-1d9b-4671-9b17-5f2b8468a53c', '2025-01-17 02:14:32');

-- ----------------------------
-- Table structure for payment_methods
-- ----------------------------
DROP TABLE IF EXISTS `payment_methods`;
CREATE TABLE `payment_methods`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `methodName` enum('Online','COD') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `methodName`(`methodName` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of payment_methods
-- ----------------------------
INSERT INTO `payment_methods` VALUES (2, 'Online');
INSERT INTO `payment_methods` VALUES (1, 'COD');

-- ----------------------------
-- Table structure for payments
-- ----------------------------
DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `orderId` int NULL DEFAULT NULL,
  `userId` int NULL DEFAULT NULL,
  `methodId` int NULL DEFAULT NULL,
  `paymentStatus` enum('chờ','đã thanh toán','thất bại','đã hủy') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'chờ',
  `paymentDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `transactionId` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `userId`(`userId` ASC) USING BTREE,
  INDEX `methodId`(`methodId` ASC) USING BTREE,
  INDEX `payments_ibfk_1`(`orderId` ASC) USING BTREE,
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`orderId`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `payments_ibfk_3` FOREIGN KEY (`methodId`) REFERENCES `payment_methods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 345 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of payments
-- ----------------------------
INSERT INTO `payments` VALUES (192, 210, 4, 1, 'đã thanh toán', '2025-04-11 19:03:48', NULL);
INSERT INTO `payments` VALUES (317, 335, 11, 1, 'đã thanh toán', '2025-05-06 23:57:40', NULL);
INSERT INTO `payments` VALUES (318, 336, 11, 1, 'đã thanh toán', '2025-05-07 00:00:39', NULL);
INSERT INTO `payments` VALUES (319, 337, 11, 1, 'đã thanh toán', '2025-05-07 16:13:08', NULL);
INSERT INTO `payments` VALUES (320, 338, 11, 2, 'chờ', '2025-05-07 16:16:22', NULL);
INSERT INTO `payments` VALUES (321, 339, 11, 1, 'đã thanh toán', '2025-05-07 16:29:52', NULL);
INSERT INTO `payments` VALUES (322, 340, 11, 1, 'đã thanh toán', '2025-05-12 15:26:44', NULL);
INSERT INTO `payments` VALUES (323, 341, 4, 1, 'đã thanh toán', '2025-05-12 16:11:48', NULL);
INSERT INTO `payments` VALUES (324, 342, 11, 1, 'đã thanh toán', '2025-05-12 16:12:57', NULL);
INSERT INTO `payments` VALUES (325, 343, 11, 2, 'chờ', '2025-05-12 16:54:52', NULL);
INSERT INTO `payments` VALUES (326, 344, 11, 2, 'chờ', '2025-05-12 17:01:34', NULL);
INSERT INTO `payments` VALUES (327, 345, 11, 1, 'đã thanh toán', '2025-05-12 21:37:01', NULL);
INSERT INTO `payments` VALUES (328, 346, 11, 1, 'đã thanh toán', '2025-05-12 21:41:48', NULL);
INSERT INTO `payments` VALUES (329, 347, 11, 1, 'đã thanh toán', '2025-05-14 20:32:22', NULL);
INSERT INTO `payments` VALUES (330, 348, 4, 2, 'chờ', '2025-05-28 23:03:11', NULL);
INSERT INTO `payments` VALUES (331, 349, 4, 2, 'chờ', '2025-05-28 23:07:18', NULL);
INSERT INTO `payments` VALUES (332, 350, 20, 1, 'đã thanh toán', '2025-06-02 08:42:38', NULL);
INSERT INTO `payments` VALUES (333, 351, 20, 2, 'chờ', '2025-06-02 09:00:24', NULL);
INSERT INTO `payments` VALUES (334, 352, 20, 1, 'đã thanh toán', '2025-06-02 09:06:15', NULL);
INSERT INTO `payments` VALUES (335, 353, 20, 1, 'đã thanh toán', '2025-06-02 09:13:04', NULL);
INSERT INTO `payments` VALUES (336, 354, 20, 1, 'đã thanh toán', '2025-06-02 09:21:35', NULL);
INSERT INTO `payments` VALUES (337, 355, 20, 2, 'chờ', '2025-06-03 08:45:03', NULL);
INSERT INTO `payments` VALUES (340, 358, 20, 1, 'đã thanh toán', '2025-06-03 16:37:19', NULL);
INSERT INTO `payments` VALUES (341, 359, 20, 1, 'đã thanh toán', '2025-06-03 17:01:39', NULL);
INSERT INTO `payments` VALUES (342, 360, 20, 1, 'đã thanh toán', '2025-06-03 17:31:43', NULL);
INSERT INTO `payments` VALUES (343, 361, 20, 1, 'đã thanh toán', '2025-06-03 17:42:04', NULL);
INSERT INTO `payments` VALUES (344, 362, 20, 1, 'đã thanh toán', '2025-06-03 17:45:45', NULL);

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of permissions
-- ----------------------------
INSERT INTO `permissions` VALUES (3, 'BUY_PRODUCTS', 'can buy products');
INSERT INTO `permissions` VALUES (4, 'VIEW_USERS', 'can view users');
INSERT INTO `permissions` VALUES (5, 'VIEW_PREVIEWS', 'can view preview');
INSERT INTO `permissions` VALUES (6, 'DELETE_PRODUCTS', 'can detete products');
INSERT INTO `permissions` VALUES (7, 'UPDATE_PRODUCTS', 'can update products');
INSERT INTO `permissions` VALUES (8, 'ADD_PRODUCTS', 'can add products');
INSERT INTO `permissions` VALUES (9, 'VIEW_PRODUCTS', 'can view products');
INSERT INTO `permissions` VALUES (10, 'DELETE_ORDERS', 'can delete orders');
INSERT INTO `permissions` VALUES (11, 'UPDATE_ORDERS', 'can update order');
INSERT INTO `permissions` VALUES (12, 'VIEW_ORDERS', 'can view orders');
INSERT INTO `permissions` VALUES (13, 'ADD_THEMEs', 'can add theme');
INSERT INTO `permissions` VALUES (14, 'VIEW_ARTISTS', 'can view artists');
INSERT INTO `permissions` VALUES (15, 'VIEW_DISCOUNTS', 'can view discounts');
INSERT INTO `permissions` VALUES (16, 'VIEW_VOUCHERS', 'can view vouchers');
INSERT INTO `permissions` VALUES (17, 'UPDATE_ARTISTS', 'can update artists');
INSERT INTO `permissions` VALUES (18, 'DELETE_ARTISTS', 'can delete artists');
INSERT INTO `permissions` VALUES (19, 'ADD_ARTISIS', 'can add artists');
INSERT INTO `permissions` VALUES (20, 'ADD_DISCOUNTS', 'can add discount');
INSERT INTO `permissions` VALUES (21, 'UPDATE_DISCOUNTS', 'can update discount');
INSERT INTO `permissions` VALUES (22, 'DELETE_DISCOUNT', 'can delete discount');
INSERT INTO `permissions` VALUES (23, 'ADD_VOUCHERS', 'can add vouchers');
INSERT INTO `permissions` VALUES (24, 'UPDATE_SIZES', 'can update size');
INSERT INTO `permissions` VALUES (25, 'ADD_SIZES', 'can add size');
INSERT INTO `permissions` VALUES (26, 'DELETE_SIZES', 'can delete size');
INSERT INTO `permissions` VALUES (27, 'DELETE_VOUCHERS', 'can delete voucher');
INSERT INTO `permissions` VALUES (28, 'DELETE_THEMES', 'can delete theme');
INSERT INTO `permissions` VALUES (29, 'UPDATE_VOUCHERS', 'can update voucher');

-- ----------------------------
-- Table structure for product_reviews
-- ----------------------------
DROP TABLE IF EXISTS `product_reviews`;
CREATE TABLE `product_reviews`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `paintingId` int NOT NULL,
  `orderItemId` int NOT NULL,
  `rating` int NOT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `userId`(`userId` ASC, `paintingId` ASC, `orderItemId` ASC) USING BTREE,
  INDEX `orderItemId`(`orderItemId` ASC) USING BTREE,
  INDEX `product_reviews_ibfk_2`(`paintingId` ASC) USING BTREE,
  INDEX `idx_reviews_paintingId`(`paintingId` ASC) USING BTREE,
  INDEX `idx_userId`(`userId` ASC) USING BTREE,
  CONSTRAINT `product_reviews_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `product_reviews_ibfk_2` FOREIGN KEY (`paintingId`) REFERENCES `paintings` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `product_reviews_ibfk_3` FOREIGN KEY (`orderItemId`) REFERENCES `order_items` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `product_reviews_chk_1` CHECK (`rating` between 1 and 5)
) ENGINE = InnoDB AUTO_INCREMENT = 94 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product_reviews
-- ----------------------------
INSERT INTO `product_reviews` VALUES (89, 4, 15, 237, 4, 'Tranh đẹp', '2025-04-11 19:04:32');
INSERT INTO `product_reviews` VALUES (90, 4, 3, 238, 3, 'Tranh tệ', '2025-04-11 19:04:59');
INSERT INTO `product_reviews` VALUES (91, 20, 1, 393, 5, 'Hài lòng!', '2025-06-03 08:47:23');

-- ----------------------------
-- Table structure for role_permissions
-- ----------------------------
DROP TABLE IF EXISTS `role_permissions`;
CREATE TABLE `role_permissions`  (
  `roleId` int NOT NULL,
  `permissionId` int NOT NULL,
  PRIMARY KEY (`roleId`, `permissionId`) USING BTREE,
  INDEX `permissionId`(`permissionId` ASC) USING BTREE,
  CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`roleId`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `role_permissions_ibfk_2` FOREIGN KEY (`permissionId`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of role_permissions
-- ----------------------------
INSERT INTO `role_permissions` VALUES (1, 3);
INSERT INTO `role_permissions` VALUES (2, 3);
INSERT INTO `role_permissions` VALUES (5, 3);
INSERT INTO `role_permissions` VALUES (13, 3);
INSERT INTO `role_permissions` VALUES (1, 4);
INSERT INTO `role_permissions` VALUES (1, 5);
INSERT INTO `role_permissions` VALUES (1, 6);
INSERT INTO `role_permissions` VALUES (3, 6);
INSERT INTO `role_permissions` VALUES (1, 7);
INSERT INTO `role_permissions` VALUES (3, 7);
INSERT INTO `role_permissions` VALUES (1, 8);
INSERT INTO `role_permissions` VALUES (3, 8);
INSERT INTO `role_permissions` VALUES (1, 9);
INSERT INTO `role_permissions` VALUES (3, 9);
INSERT INTO `role_permissions` VALUES (1, 10);
INSERT INTO `role_permissions` VALUES (1, 11);
INSERT INTO `role_permissions` VALUES (1, 12);
INSERT INTO `role_permissions` VALUES (1, 13);
INSERT INTO `role_permissions` VALUES (3, 13);
INSERT INTO `role_permissions` VALUES (5, 13);
INSERT INTO `role_permissions` VALUES (1, 14);
INSERT INTO `role_permissions` VALUES (3, 14);
INSERT INTO `role_permissions` VALUES (1, 15);
INSERT INTO `role_permissions` VALUES (1, 16);
INSERT INTO `role_permissions` VALUES (1, 17);
INSERT INTO `role_permissions` VALUES (3, 17);
INSERT INTO `role_permissions` VALUES (1, 18);
INSERT INTO `role_permissions` VALUES (3, 18);
INSERT INTO `role_permissions` VALUES (1, 19);
INSERT INTO `role_permissions` VALUES (3, 19);
INSERT INTO `role_permissions` VALUES (1, 20);
INSERT INTO `role_permissions` VALUES (1, 21);
INSERT INTO `role_permissions` VALUES (1, 22);
INSERT INTO `role_permissions` VALUES (1, 23);
INSERT INTO `role_permissions` VALUES (1, 24);
INSERT INTO `role_permissions` VALUES (3, 24);
INSERT INTO `role_permissions` VALUES (1, 25);
INSERT INTO `role_permissions` VALUES (3, 25);
INSERT INTO `role_permissions` VALUES (1, 26);
INSERT INTO `role_permissions` VALUES (3, 26);
INSERT INTO `role_permissions` VALUES (1, 27);
INSERT INTO `role_permissions` VALUES (1, 28);
INSERT INTO `role_permissions` VALUES (3, 28);
INSERT INTO `role_permissions` VALUES (1, 29);

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of roles
-- ----------------------------
INSERT INTO `roles` VALUES (1, 'ADMIN');
INSERT INTO `roles` VALUES (4, 'MANAGER_ORDER');
INSERT INTO `roles` VALUES (3, 'MANAGER_PRODUCT');
INSERT INTO `roles` VALUES (13, 'MANAGER_REVIEWS');
INSERT INTO `roles` VALUES (5, 'MANAGER_THEME');
INSERT INTO `roles` VALUES (2, 'USER');

-- ----------------------------
-- Table structure for shop_reviews
-- ----------------------------
DROP TABLE IF EXISTS `shop_reviews`;
CREATE TABLE `shop_reviews`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int NULL DEFAULT NULL,
  `rating` int NULL DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `userId`(`userId` ASC) USING BTREE,
  CONSTRAINT `shop_reviews_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `shop_reviews_chk_1` CHECK (`rating` between 1 and 5)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of shop_reviews
-- ----------------------------

-- ----------------------------
-- Table structure for sizes
-- ----------------------------
DROP TABLE IF EXISTS `sizes`;
CREATE TABLE `sizes`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `sizeDescription` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `weight` decimal(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `sizeDescription`(`sizeDescription` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sizes
-- ----------------------------
INSERT INTO `sizes` VALUES (1, 'Nhỏ (20x30 cm)', 5000.00);
INSERT INTO `sizes` VALUES (2, 'Vừa (40x60 cm)', 7000.00);
INSERT INTO `sizes` VALUES (3, 'Lớn (80x100 cm)', 9000.00);

-- ----------------------------
-- Table structure for stock_in
-- ----------------------------
DROP TABLE IF EXISTS `stock_in`;
CREATE TABLE `stock_in`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `createdId` int NOT NULL,
  `supplier` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `importDate` date NULL DEFAULT NULL,
  `totalPrice` decimal(10, 2) NULL DEFAULT NULL,
  `status` enum('Đã áp dụng','Chưa áp dụng') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `createBy`(`createdId` ASC) USING BTREE,
  CONSTRAINT `stock_in_ibfk_1` FOREIGN KEY (`createdId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stock_in
-- ----------------------------
INSERT INTO `stock_in` VALUES (19, 4, 'NCC01', NULL, '2025-05-04', 200000.00, NULL);
INSERT INTO `stock_in` VALUES (20, 4, 'NCC01', 'Nhập hàng', '2025-05-07', 4000000.00, 'Đã áp dụng');

-- ----------------------------
-- Table structure for stock_in_items
-- ----------------------------
DROP TABLE IF EXISTS `stock_in_items`;
CREATE TABLE `stock_in_items`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `stockInId` int NOT NULL,
  `paintingId` int NOT NULL,
  `sizeId` int NOT NULL,
  `price` decimal(10, 2) NOT NULL,
  `quantity` int NOT NULL,
  `totalPrice` decimal(10, 2) NULL DEFAULT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `stockInId`(`stockInId` ASC) USING BTREE,
  INDEX `paintingId`(`paintingId` ASC) USING BTREE,
  INDEX `sizeId`(`sizeId` ASC) USING BTREE,
  CONSTRAINT `stock_in_items_ibfk_1` FOREIGN KEY (`stockInId`) REFERENCES `stock_in` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `stock_in_items_ibfk_2` FOREIGN KEY (`paintingId`) REFERENCES `paintings` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `stock_in_items_ibfk_3` FOREIGN KEY (`sizeId`) REFERENCES `sizes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stock_in_items
-- ----------------------------
INSERT INTO `stock_in_items` VALUES (24, 19, 61, 1, 200000.00, 1, 200000.00, 'Sp1');
INSERT INTO `stock_in_items` VALUES (25, 20, 33, 1, 400000.00, 10, 4000000.00, '');

-- ----------------------------
-- Table structure for stock_out
-- ----------------------------
DROP TABLE IF EXISTS `stock_out`;
CREATE TABLE `stock_out`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `createdId` int NOT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `orderId` int NULL DEFAULT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `exportDate` date NULL DEFAULT NULL,
  `totalPrice` decimal(10, 2) NULL DEFAULT NULL,
  `status` enum('Đã áp dụng','Chưa áp dụng') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `createdId`(`createdId` ASC) USING BTREE,
  INDEX `orderId`(`orderId` ASC) USING BTREE,
  CONSTRAINT `stock_out_ibfk_1` FOREIGN KEY (`createdId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `stock_out_ibfk_2` FOREIGN KEY (`orderId`) REFERENCES `orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stock_out
-- ----------------------------
INSERT INTO `stock_out` VALUES (16, 4, 'Giao hàng', 336, 'Giao hàng', '2025-05-07', 2000000.00, 'Đã áp dụng');
INSERT INTO `stock_out` VALUES (17, 4, 'Giao hàng', 335, 'Giao hàng', '2025-05-07', 3500000.00, 'Đã áp dụng');
INSERT INTO `stock_out` VALUES (18, 4, 'Giao hàng', 339, '', '2025-05-07', 4500000.00, 'Đã áp dụng');

-- ----------------------------
-- Table structure for stock_out_items
-- ----------------------------
DROP TABLE IF EXISTS `stock_out_items`;
CREATE TABLE `stock_out_items`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `stockOutId` int NOT NULL,
  `paintingId` int NOT NULL,
  `sizeId` int NOT NULL,
  `price` decimal(10, 2) NOT NULL,
  `quantity` int NOT NULL,
  `totalPrice` decimal(10, 2) NULL DEFAULT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `stockOutId`(`stockOutId` ASC) USING BTREE,
  INDEX `paintingId`(`paintingId` ASC) USING BTREE,
  INDEX `sizeId`(`sizeId` ASC) USING BTREE,
  CONSTRAINT `stock_out_items_ibfk_1` FOREIGN KEY (`stockOutId`) REFERENCES `stock_out` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `stock_out_items_ibfk_2` FOREIGN KEY (`paintingId`) REFERENCES `paintings` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `stock_out_items_ibfk_3` FOREIGN KEY (`sizeId`) REFERENCES `sizes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stock_out_items
-- ----------------------------
INSERT INTO `stock_out_items` VALUES (18, 16, 1, 2, 1000000.00, 2, 2000000.00, '');
INSERT INTO `stock_out_items` VALUES (19, 17, 1, 1, 500000.00, 1, 500000.00, '');
INSERT INTO `stock_out_items` VALUES (20, 17, 3, 3, 1500000.00, 2, 3000000.00, '');
INSERT INTO `stock_out_items` VALUES (21, 18, 5, 1, 2250000.00, 2, 4500000.00, '');

-- ----------------------------
-- Table structure for themes
-- ----------------------------
DROP TABLE IF EXISTS `themes`;
CREATE TABLE `themes`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `themeName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `themeName`(`themeName` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 344 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of themes
-- ----------------------------
INSERT INTO `themes` VALUES (4, 'Dân gian');
INSERT INTO `themes` VALUES (1, 'Đời sống');
INSERT INTO `themes` VALUES (2, 'Tĩnh vật');
INSERT INTO `themes` VALUES (3, 'Trừu tượng');

-- ----------------------------
-- Table structure for tokens
-- ----------------------------
DROP TABLE IF EXISTS `tokens`;
CREATE TABLE `tokens`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiredAt` datetime NOT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_token_type`(`token` ASC, `type` ASC) USING BTREE,
  INDEX `idx_tokens_user_type_expire`(`userId` ASC, `type` ASC, `expiredAt` ASC) USING BTREE,
  CONSTRAINT `tokens_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tokens
-- ----------------------------
INSERT INTO `tokens` VALUES (2, 20, '392a4de4-4860-4998-99c6-161e5df3186d', '2025-06-03 08:40:23', 'register');

-- ----------------------------
-- Table structure for user_roles
-- ----------------------------
DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles`  (
  `userId` int NOT NULL,
  `roleId` int NOT NULL,
  PRIMARY KEY (`userId`, `roleId`) USING BTREE,
  INDEX `roleId`(`roleId` ASC) USING BTREE,
  INDEX `idx_userId`(`userId` ASC) USING BTREE,
  CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`roleId`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_roles
-- ----------------------------
INSERT INTO `user_roles` VALUES (4, 1);
INSERT INTO `user_roles` VALUES (11, 1);
INSERT INTO `user_roles` VALUES (4, 2);
INSERT INTO `user_roles` VALUES (7, 2);
INSERT INTO `user_roles` VALUES (2, 3);
INSERT INTO `user_roles` VALUES (4, 3);
INSERT INTO `user_roles` VALUES (1, 4);
INSERT INTO `user_roles` VALUES (2, 4);
INSERT INTO `user_roles` VALUES (4, 4);
INSERT INTO `user_roles` VALUES (4, 5);
INSERT INTO `user_roles` VALUES (2, 13);
INSERT INTO `user_roles` VALUES (4, 13);

-- ----------------------------
-- Table structure for user_vouchers
-- ----------------------------
DROP TABLE IF EXISTS `user_vouchers`;
CREATE TABLE `user_vouchers`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `voucher_id` int NOT NULL,
  `is_used` tinyint(1) NULL DEFAULT 0,
  `assigned_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `used_at` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `voucher_id`(`voucher_id` ASC) USING BTREE,
  CONSTRAINT `user_vouchers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `user_vouchers_ibfk_2` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_vouchers
-- ----------------------------
INSERT INTO `user_vouchers` VALUES (2, 4, 4, 1, '2025-04-16 17:01:21', NULL);
INSERT INTO `user_vouchers` VALUES (3, 4, 6, 1, '2025-04-16 20:24:23', NULL);
INSERT INTO `user_vouchers` VALUES (4, 4, 7, 1, '2025-04-17 09:15:04', NULL);
INSERT INTO `user_vouchers` VALUES (5, 4, 4, 1, '2025-04-17 16:01:40', NULL);
INSERT INTO `user_vouchers` VALUES (6, 4, 6, 0, '2025-04-17 16:02:07', NULL);
INSERT INTO `user_vouchers` VALUES (7, 4, 8, 1, '2025-04-18 22:52:08', NULL);
INSERT INTO `user_vouchers` VALUES (14, 4, 9, 0, '2025-04-20 13:58:05', NULL);
INSERT INTO `user_vouchers` VALUES (15, 4, 19, 1, '2025-04-20 15:05:31', NULL);
INSERT INTO `user_vouchers` VALUES (16, 4, 44, 1, '2025-04-20 15:06:09', NULL);
INSERT INTO `user_vouchers` VALUES (17, 4, 98, 1, '2025-04-20 15:35:57', NULL);
INSERT INTO `user_vouchers` VALUES (18, 4, 89, 0, '2025-04-20 16:31:21', NULL);
INSERT INTO `user_vouchers` VALUES (19, 4, 92, 0, '2025-04-20 16:59:08', NULL);
INSERT INTO `user_vouchers` VALUES (20, 4, 10, 0, '2025-04-25 20:28:27', NULL);
INSERT INTO `user_vouchers` VALUES (21, 11, 27, 1, '2025-05-06 19:19:44', NULL);
INSERT INTO `user_vouchers` VALUES (22, 11, 84, 1, '2025-05-06 19:21:25', NULL);
INSERT INTO `user_vouchers` VALUES (23, 11, 18, 1, '2025-05-06 19:49:23', NULL);
INSERT INTO `user_vouchers` VALUES (24, 11, 29, 1, '2025-05-06 19:58:14', NULL);
INSERT INTO `user_vouchers` VALUES (25, 11, 49, 1, '2025-05-06 20:03:06', NULL);
INSERT INTO `user_vouchers` VALUES (26, 11, 47, 1, '2025-05-06 20:07:18', NULL);
INSERT INTO `user_vouchers` VALUES (27, 11, 101, 0, '2025-05-06 20:22:11', NULL);
INSERT INTO `user_vouchers` VALUES (28, 11, 78, 1, '2025-05-06 21:13:57', NULL);
INSERT INTO `user_vouchers` VALUES (29, 11, 19, 1, '2025-05-06 21:31:59', NULL);
INSERT INTO `user_vouchers` VALUES (30, 11, 46, 0, '2025-05-06 22:01:09', NULL);
INSERT INTO `user_vouchers` VALUES (31, 11, 75, 1, '2025-05-06 23:40:01', NULL);
INSERT INTO `user_vouchers` VALUES (32, 11, 85, 1, '2025-05-06 23:42:35', NULL);
INSERT INTO `user_vouchers` VALUES (33, 11, 95, 0, '2025-05-06 23:44:27', NULL);
INSERT INTO `user_vouchers` VALUES (34, 11, 15, 0, '2025-05-12 16:12:59', NULL);
INSERT INTO `user_vouchers` VALUES (35, 11, 98, 0, '2025-05-14 20:32:24', NULL);
INSERT INTO `user_vouchers` VALUES (36, 20, 97, 0, '2025-06-03 08:58:47', NULL);
INSERT INTO `user_vouchers` VALUES (37, 20, 90, 0, '2025-06-03 16:37:20', NULL);
INSERT INTO `user_vouchers` VALUES (38, 20, 20, 0, '2025-06-03 17:01:41', NULL);
INSERT INTO `user_vouchers` VALUES (39, 20, 62, 0, '2025-06-03 17:31:44', NULL);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `fullName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `role` enum('admin','user') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'user',
  `gg_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `fb_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` enum('Hoạt động','Chưa kích hoạt','Bị khóa','Chờ xóa','Đã xóa') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'Chưa kích hoạt',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `email`(`email` ASC) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  INDEX `idx_email`(`email` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE,
  INDEX `idx_gg_id`(`gg_id` ASC) USING BTREE,
  INDEX `idx_fb_id`(`fb_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'Thượng Đình Hiệu', 'dinhHieu', '5b9b13a02966b27f060a43d276705b95', 'Thuận An, Bình Dương, HCM', '22130082@gmail.com', '0909090909', 'admin', NULL, NULL, 'Hoạt động');
INSERT INTO `users` VALUES (2, 'Thượng Đình Hiệu ', 'hieuhieu', '8ab4c089690ef2d9cb7cf48ce34a6269', 'Điện An 1', 'hieuthuong113@gmail.com', '09090909', 'user', NULL, NULL, 'Hoạt động');
INSERT INTO `users` VALUES (4, 'Thượng Đình Hiệu', 'admin', '$2a$12$evzTLhvG/Offc6KyJWcv4uhJiAhDFEvwO3h8gzVOvVVF2yumpBmw6', 'Thuân An', 'hieuthuong13@gmail.com', '0909900900', 'admin', NULL, NULL, 'Hoạt động');
INSERT INTO `users` VALUES (7, 'Nguyên Van A', 'vana', '8ab4c089690ef2d9cb7cf48ce34a6269', 'Điên An', '2213008@gmail.com', '0909090909', 'user', NULL, NULL, 'Hoạt động');
INSERT INTO `users` VALUES (10, 'ddd', 'aaaa', 'ceedb854f1f65aa21a59e6e651cd26a8', 'nul', 'teacher1@gmail.com', '0909090909', 'user', NULL, NULL, 'Hoạt động');
INSERT INTO `users` VALUES (11, 'Đỗ Khắc Hảo', 'haoxt04', '43c51c4d90db42512f4c09d162484b05', 'ĐH Nông Lâm', 'k42.dkhao@gmail.com', '0987654321', 'admin', NULL, NULL, 'Hoạt động');
INSERT INTO `users` VALUES (12, 'Đỗ Khắc Hảo', 'haodo04', '43c51c4d90db42512f4c09d162484b05', 'TP. Hồ Chí Minh', 'haodo04@gmail.com', '0931931311', 'user', NULL, NULL, 'Hoạt động');
INSERT INTO `users` VALUES (20, 'Đỗ Khắc Hảo', 'abc123', '$2a$12$daoJIdmFPbqcyHEK0axOGuPTELHdwjZdimCKn.wBEkbOQTbW4N.wm', NULL, 'abc123@gmail.com', '0111131111', 'user', NULL, NULL, 'Bị khóa');

-- ----------------------------
-- Table structure for vouchers
-- ----------------------------
DROP TABLE IF EXISTS `vouchers`;
CREATE TABLE `vouchers`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount` decimal(5, 2) NOT NULL,
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `startDate` date NOT NULL,
  `endDate` date NOT NULL,
  `imageUrl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `imageUrlCloud` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `type` enum('order','shipping') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'order',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 110 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of vouchers
-- ----------------------------
INSERT INTO `vouchers` VALUES (4, 'Voucher 10%', 10.00, 1, '2025-01-16 02:16:30', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', '12310', 'order');
INSERT INTO `vouchers` VALUES (6, 'Voucher 12%', 12.00, 1, '2025-01-16 02:58:39', '2025-01-14', '2030-02-14', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', '12312', 'order');
INSERT INTO `vouchers` VALUES (7, 'Voucher 15%', 15.00, 1, '2025-01-16 03:02:56', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', '12315', 'order');
INSERT INTO `vouchers` VALUES (8, 'Voucher freeship', 100.00, 1, '2025-04-17 09:46:50', '2025-04-17', '2030-04-29', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', '123SHIP', 'shipping');
INSERT INTO `vouchers` VALUES (9, 'Gift 10%', 10.00, 1, '2025-04-20 10:07:33', '2025-04-20', '2030-04-20', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'GIFT10', 'order');
INSERT INTO `vouchers` VALUES (10, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO15793_0', 'order');
INSERT INTO `vouchers` VALUES (11, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO75424_1', 'order');
INSERT INTO `vouchers` VALUES (12, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO43069_2', 'order');
INSERT INTO `vouchers` VALUES (13, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO83371_3', 'shipping');
INSERT INTO `vouchers` VALUES (14, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO61096_4', 'order');
INSERT INTO `vouchers` VALUES (15, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO35748_5', 'order');
INSERT INTO `vouchers` VALUES (16, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO92327_6', 'order');
INSERT INTO `vouchers` VALUES (17, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO72008_7', 'shipping');
INSERT INTO `vouchers` VALUES (18, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO25078_8', 'order');
INSERT INTO `vouchers` VALUES (19, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO70929_9', 'order');
INSERT INTO `vouchers` VALUES (20, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO86146_10', 'order');
INSERT INTO `vouchers` VALUES (21, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO87007_11', 'shipping');
INSERT INTO `vouchers` VALUES (22, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO24572_12', 'order');
INSERT INTO `vouchers` VALUES (23, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO98173_13', 'order');
INSERT INTO `vouchers` VALUES (24, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO67398_14', 'order');
INSERT INTO `vouchers` VALUES (25, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO94620_15', 'shipping');
INSERT INTO `vouchers` VALUES (26, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO75780_16', 'order');
INSERT INTO `vouchers` VALUES (27, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO55360_17', 'order');
INSERT INTO `vouchers` VALUES (28, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO36650_18', 'order');
INSERT INTO `vouchers` VALUES (29, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO52863_19', 'shipping');
INSERT INTO `vouchers` VALUES (30, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO46465_20', 'order');
INSERT INTO `vouchers` VALUES (31, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO18075_21', 'order');
INSERT INTO `vouchers` VALUES (32, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO40762_22', 'order');
INSERT INTO `vouchers` VALUES (33, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO99916_23', 'shipping');
INSERT INTO `vouchers` VALUES (34, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO92477_24', 'order');
INSERT INTO `vouchers` VALUES (35, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO40453_25', 'order');
INSERT INTO `vouchers` VALUES (36, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO91741_26', 'order');
INSERT INTO `vouchers` VALUES (37, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO13162_27', 'shipping');
INSERT INTO `vouchers` VALUES (38, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO17678_28', 'order');
INSERT INTO `vouchers` VALUES (39, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO31637_29', 'order');
INSERT INTO `vouchers` VALUES (40, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO63500_30', 'order');
INSERT INTO `vouchers` VALUES (41, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO82647_31', 'shipping');
INSERT INTO `vouchers` VALUES (42, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO26823_32', 'order');
INSERT INTO `vouchers` VALUES (43, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO93185_33', 'order');
INSERT INTO `vouchers` VALUES (44, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO39658_34', 'order');
INSERT INTO `vouchers` VALUES (45, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO14687_35', 'shipping');
INSERT INTO `vouchers` VALUES (46, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO52792_36', 'order');
INSERT INTO `vouchers` VALUES (47, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO56998_37', 'order');
INSERT INTO `vouchers` VALUES (48, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO79306_38', 'order');
INSERT INTO `vouchers` VALUES (49, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO73682_39', 'shipping');
INSERT INTO `vouchers` VALUES (50, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO85492_40', 'order');
INSERT INTO `vouchers` VALUES (51, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO28711_41', 'order');
INSERT INTO `vouchers` VALUES (52, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO47889_42', 'order');
INSERT INTO `vouchers` VALUES (53, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO56963_43', 'shipping');
INSERT INTO `vouchers` VALUES (54, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO34683_44', 'order');
INSERT INTO `vouchers` VALUES (55, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO13963_45', 'order');
INSERT INTO `vouchers` VALUES (56, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO12675_46', 'order');
INSERT INTO `vouchers` VALUES (57, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO52776_47', 'shipping');
INSERT INTO `vouchers` VALUES (58, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO20070_48', 'order');
INSERT INTO `vouchers` VALUES (59, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO79901_49', 'order');
INSERT INTO `vouchers` VALUES (60, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO12146_50', 'order');
INSERT INTO `vouchers` VALUES (61, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO81748_51', 'shipping');
INSERT INTO `vouchers` VALUES (62, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO93675_52', 'order');
INSERT INTO `vouchers` VALUES (63, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO76703_53', 'order');
INSERT INTO `vouchers` VALUES (64, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO52976_54', 'order');
INSERT INTO `vouchers` VALUES (65, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO30291_55', 'shipping');
INSERT INTO `vouchers` VALUES (66, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO30397_56', 'order');
INSERT INTO `vouchers` VALUES (67, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO43427_57', 'order');
INSERT INTO `vouchers` VALUES (68, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO80196_58', 'order');
INSERT INTO `vouchers` VALUES (69, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO78338_59', 'shipping');
INSERT INTO `vouchers` VALUES (70, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO51137_60', 'order');
INSERT INTO `vouchers` VALUES (71, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO54923_61', 'order');
INSERT INTO `vouchers` VALUES (72, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO42625_62', 'order');
INSERT INTO `vouchers` VALUES (73, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO30936_63', 'shipping');
INSERT INTO `vouchers` VALUES (74, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO78377_64', 'order');
INSERT INTO `vouchers` VALUES (75, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO70442_65', 'order');
INSERT INTO `vouchers` VALUES (76, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO42248_66', 'order');
INSERT INTO `vouchers` VALUES (77, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO15755_67', 'shipping');
INSERT INTO `vouchers` VALUES (78, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO28767_68', 'order');
INSERT INTO `vouchers` VALUES (79, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO91885_69', 'order');
INSERT INTO `vouchers` VALUES (80, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO16961_70', 'order');
INSERT INTO `vouchers` VALUES (81, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO16420_71', 'shipping');
INSERT INTO `vouchers` VALUES (82, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO49446_72', 'order');
INSERT INTO `vouchers` VALUES (83, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO83515_73', 'order');
INSERT INTO `vouchers` VALUES (84, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO95958_74', 'order');
INSERT INTO `vouchers` VALUES (85, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO70706_75', 'shipping');
INSERT INTO `vouchers` VALUES (86, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO39761_76', 'order');
INSERT INTO `vouchers` VALUES (87, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO17567_77', 'order');
INSERT INTO `vouchers` VALUES (88, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO81670_78', 'order');
INSERT INTO `vouchers` VALUES (89, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO19681_79', 'shipping');
INSERT INTO `vouchers` VALUES (90, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO66521_80', 'order');
INSERT INTO `vouchers` VALUES (91, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO43144_81', 'order');
INSERT INTO `vouchers` VALUES (92, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO63197_82', 'order');
INSERT INTO `vouchers` VALUES (93, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO41518_83', 'shipping');
INSERT INTO `vouchers` VALUES (94, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO86558_84', 'order');
INSERT INTO `vouchers` VALUES (95, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO74648_85', 'order');
INSERT INTO `vouchers` VALUES (96, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO31555_86', 'order');
INSERT INTO `vouchers` VALUES (97, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO88596_87', 'shipping');
INSERT INTO `vouchers` VALUES (98, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO73008_88', 'order');
INSERT INTO `vouchers` VALUES (99, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO31129_89', 'order');
INSERT INTO `vouchers` VALUES (100, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO47618_90', 'order');
INSERT INTO `vouchers` VALUES (101, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO42081_91', 'shipping');
INSERT INTO `vouchers` VALUES (102, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO89323_92', 'order');
INSERT INTO `vouchers` VALUES (103, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO55054_93', 'order');
INSERT INTO `vouchers` VALUES (104, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO43435_94', 'order');
INSERT INTO `vouchers` VALUES (105, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO87129_95', 'shipping');
INSERT INTO `vouchers` VALUES (106, 'Voucher 10%', 10.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_10percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png', 'AUTO82116_96', 'order');
INSERT INTO `vouchers` VALUES (107, 'Voucher 12%', 12.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_12percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png', 'AUTO34266_97', 'order');
INSERT INTO `vouchers` VALUES (108, 'Voucher 15%', 15.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_15percent.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png', 'AUTO82999_98', 'order');
INSERT INTO `vouchers` VALUES (109, 'Voucher freeship', 100.00, 1, '2025-04-16 10:00:00', '2025-04-16', '2030-04-16', 'assets/images/vouchers/voucher_freeship.png', 'https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png', 'AUTO91465_99', 'shipping');

SET FOREIGN_KEY_CHECKS = 1;
