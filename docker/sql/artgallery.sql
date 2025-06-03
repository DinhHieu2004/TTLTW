-- MySQL dump 10.13  Distrib 8.0.42, for Linux (x86_64)
--
-- Host: localhost    Database: ArtGallery
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `artists`
--

DROP TABLE IF EXISTS `artists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artists` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `bio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `birthDate` date DEFAULT NULL,
  `nationality` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photoUrl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `imageUrlCloud` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artists`
--

LOCK TABLES `artists` WRITE;
/*!40000 ALTER TABLE `artists` DISABLE KEYS */;
INSERT INTO `artists` VALUES (1,'Quỳnh Hoa','Quỳnh Hoa là một họa sĩ tranh cát ở Việt Nam.','0014-08-30','Việt Nam','assets/images/artists/1-nghe-si-tranh-cat-quynh-hoa-2024-scaled.jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514398/assets/images/artists/egoyo0vfa4tcrtvjzpxb.jpg'),(2,'Trí Đức','Trí Đức là 1 họa sĩ tranh cát nỗi tiếng ở Việt Nam.','1980-03-30','Việt Nam','assets/images/artists/Tri Duc.jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514530/assets/images/artists/pup9q2uqbloxqne3ezkg.jpg'),(3,'Nguyễn Tiến ','Nguyễn Tiến, sinh năm 1990 tại Nam Định, là một họa sĩ trẻ đầy tài năng và sáng tạo. Anh được biết đến rộng rãi với khả năng trình diễn vẽ tranh cát chuyên nghiệp, mang đến những tác phẩm nghệ thuật độc đáo và ấn tượng.\n\nTuổi thơ gắn liền với cát\n\nSinh ra và lớn lên tại vùng quê ven biển, tuổi thơ của Nguyễn Tiến gắn liền với những bãi cát trắng mịn. Chính những trò chơi vẽ lên cát lúc nhỏ đã khơi dậy trong anh niềm đam mê nghệ thuật và trở thành nguồn cảm hứng bất tận cho những tác phẩm sau này.','1881-10-25','Việt Nam','assets/images/artists/OIP (2).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514461/assets/images/artists/scgt1fzajsg1gqf60pwk.jpg'),(4,'Phan Anh Vũ','Phan Anh Vũ - bậc thầy nghệ thuật tranh cát','2000-01-01','Việt Nam','assets/images/artists/Hoa-si-Nguyen-Tien-1.jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514404/assets/images/artists/qe8prq8i6thg88gvlg2d.jpg');
/*!40000 ALTER TABLE `artists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `daily_statistics`
--

DROP TABLE IF EXISTS `daily_statistics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily_statistics` (
  `id` int NOT NULL AUTO_INCREMENT,
  `statDate` date NOT NULL,
  `totalSales` int DEFAULT '0',
  `totalOrders` int DEFAULT '0',
  `totalUsers` int DEFAULT '0',
  `totalRevenue` decimal(10,2) DEFAULT '0.00',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `statDate` (`statDate`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_statistics`
--

LOCK TABLES `daily_statistics` WRITE;
/*!40000 ALTER TABLE `daily_statistics` DISABLE KEYS */;
/*!40000 ALTER TABLE `daily_statistics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discount_code`
--

DROP TABLE IF EXISTS `discount_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discount_code` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `discount_percent` int NOT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `trigger_event` enum('TIME_BASED','ORDER_SUCCESS') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discount_code`
--

LOCK TABLES `discount_code` WRITE;
/*!40000 ALTER TABLE `discount_code` DISABLE KEYS */;
INSERT INTO `discount_code` VALUES (1,'GIOVANG2025','Giảm giá giờ vàng 8h tối',20,'2025-04-10 20:00:00','2025-04-10 21:00:00','TIME_BASED',1,'2025-04-10 20:37:39'),(2,'THANKU231Z','Cảm ơn bạn đã đặt hàng!',10,NULL,NULL,'ORDER_SUCCESS',1,'2025-04-10 20:37:39');
/*!40000 ALTER TABLE `discount_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discount_paintings`
--

DROP TABLE IF EXISTS `discount_paintings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discount_paintings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `discountId` int NOT NULL,
  `paintingId` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `discountId` (`discountId`,`paintingId`) USING BTREE,
  KEY `discount_paintings_ibfk_2` (`paintingId`) USING BTREE,
  KEY `idx_dp_paintingId` (`paintingId`) USING BTREE,
  KEY `idx_dp_discountId` (`discountId`) USING BTREE,
  CONSTRAINT `discount_paintings_ibfk_1` FOREIGN KEY (`discountId`) REFERENCES `discounts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `discount_paintings_ibfk_2` FOREIGN KEY (`paintingId`) REFERENCES `paintings` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discount_paintings`
--

LOCK TABLES `discount_paintings` WRITE;
/*!40000 ALTER TABLE `discount_paintings` DISABLE KEYS */;
INSERT INTO `discount_paintings` VALUES (1,1,2),(2,1,3),(3,1,4),(4,1,5),(8,1,10),(11,1,13),(6,1,15),(9,2,7),(10,2,9),(14,2,31),(13,2,55),(15,2,61),(16,3,1),(17,3,21),(19,3,24),(18,3,25);
/*!40000 ALTER TABLE `discount_paintings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discounts`
--

DROP TABLE IF EXISTS `discounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `imageUrl` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `imageUrlCloud` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discountName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `discountPercentage` decimal(5,2) NOT NULL,
  `startDate` date NOT NULL,
  `endDate` date NOT NULL,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  CONSTRAINT `discounts_chk_1` CHECK ((`discountPercentage` between 0 and 100))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discounts`
--

LOCK TABLES `discounts` WRITE;
/*!40000 ALTER TABLE `discounts` DISABLE KEYS */;
INSERT INTO `discounts` VALUES (1,'assets/images/artists/th.jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514510/assets/images/artists/ysfsbxeswka9lnn9azzb.jpg','Tri ân khách hàng',25.00,'2024-12-12','2026-04-14','2024-12-15 01:19:44'),(2,'assets/images/artists/th.jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514510/assets/images/artists/ysfsbxeswka9lnn9azzb.jpg','Chương trình giảm giá mùa xuân',10.00,'2025-01-16','2026-04-14','2025-01-15 15:20:24'),(3,'assets/images/artists/th.jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514510/assets/images/artists/ysfsbxeswka9lnn9azzb.jpg','Flash Sale',50.00,'2025-04-11','2026-04-30','2025-04-11 19:07:03');
/*!40000 ALTER TABLE `discounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `logTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `logWhere` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `resource` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `who` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `preData` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `flowData` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `level` enum('INFO','ALERT','WARNING','DANGER') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log`
--

LOCK TABLES `log` WRITE;
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
INSERT INTO `log` VALUES (26,'2025-04-04 22:44:34',NULL,'/web_war/admin/reviews/update','admin','Không xác định','','WARNING'),(27,'2025-04-04 22:44:38',NULL,'/web_war/admin/reviews/update','admin','Không xác định','','WARNING'),(28,'2025-04-07 11:03:55',NULL,'/web_war/admin/reviews/update','admin','Không xác định','','WARNING'),(29,'2025-04-09 16:57:51',NULL,'/web_war/admin/reviews/update','admin','Không xác định','','WARNING');
/*!40000 ALTER TABLE `log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `orderId` int DEFAULT NULL,
  `paintingId` int DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `sizeId` int NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `sizeId` (`sizeId`) USING BTREE,
  KEY `order_items_ibfk_1` (`orderId`) USING BTREE,
  KEY `order_items_ibfk_2` (`paintingId`) USING BTREE,
  KEY `idx_order_items_orderId` (`orderId`) USING BTREE,
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`orderId`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`paintingId`) REFERENCES `paintings` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `order_items_ibfk_3` FOREIGN KEY (`sizeId`) REFERENCES `sizes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=396 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (237,210,15,3750000.00,1,1),(238,210,3,750000.00,3,1),(366,335,1,500000.00,1,1),(367,335,3,1500000.00,3,2),(368,336,1,1000000.00,2,2),(369,337,1,500000.00,1,1),(370,338,1,500000.00,1,1),(371,338,3,1500000.00,2,2),(372,339,5,2250000.00,1,2),(373,340,1,500000.00,1,1),(374,341,1,500000.00,1,1),(375,342,1,500000.00,1,1),(376,343,1,500000.00,1,1),(377,344,1,500000.00,1,1),(378,345,1,500000.00,1,1),(379,345,3,750000.00,1,1),(380,346,1,500000.00,1,1),(381,347,1,500000.00,1,1),(382,348,1,500000.00,1,1),(383,349,1,500000.00,1,1),(384,350,1,500000.00,1,1),(385,350,21,250000.00,1,1),(386,351,1,500000.00,1,1),(387,351,21,250000.00,1,1),(388,352,1,500000.00,1,1),(389,352,21,250000.00,1,1),(390,353,1,500000.00,1,1),(391,354,1,500000.00,1,1),(392,354,2,1500000.00,1,1),(393,355,1,1000000.00,1,2),(394,355,2,1500000.00,1,1),(395,356,1,2000000.00,1,4);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int DEFAULT NULL,
  `orderDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `totalAmount` decimal(10,2) NOT NULL,
  `paymentStatus` enum('thanh toán thất bại','đã hủy thanh toán','đã thanh toán','chưa thanh toán') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deliveryStatus` enum('chờ','hoàn thành','giao hàng thất bại','đã hủy giao hàng','đang giao') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'đang giao',
  `deliveryDate` date DEFAULT NULL,
  `recipientName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deliveryAddress` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `recipientPhone` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paymentMethod` enum('COD','VNPay') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'COD',
  `vnpTxnRef` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `shippingFee` decimal(10,2) DEFAULT NULL,
  `appliedVoucherIds` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `totalPrice` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `userId` (`userId`) USING BTREE,
  KEY `idx_orders_user_status` (`userId`,`deliveryStatus`,`paymentStatus`) USING BTREE,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=357 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (210,4,'2025-04-11 19:03:47',4500000.00,'đã thanh toán','hoàn thành','2025-04-11','Thượng Đình Hiệu','vĩnh phú 25, thuận an, Bình dương','0909900900','COD',NULL,315000.00,NULL,4815000.00),(335,11,'2025-05-06 23:57:40',2000000.00,'chưa thanh toán','đang giao',NULL,'Đỗ Khắc Hảo','vĩnh phú 25, thuận an, Bình dương','0987654321','COD',NULL,495000.00,NULL,2495000.00),(336,11,'2025-05-07 00:00:39',1000000.00,'chưa thanh toán','đang giao',NULL,'Đỗ Khắc Hảo','vĩnh phú 25, thuận an, Bình dương','0987654321','COD',NULL,315000.00,NULL,1315000.00),(337,11,'2025-05-07 16:13:07',500000.00,'đã thanh toán','hoàn thành','2025-05-05','Đỗ Khắc Hảo','vĩnh phú 25, thuận an, Bình dương','0987654321','COD',NULL,135000.00,'85,46',450000.00),(338,11,'2025-05-07 16:16:22',2000000.00,'đã thanh toán','hoàn thành','2025-05-06','Đỗ Khắc Hảo','vĩnh phú 25, thuận an, Bình dương','0987654321','VNPay','89537891',415000.00,'85,47,75',1520000.00),(339,11,'2025-05-07 16:29:52',2250000.00,'chưa thanh toán','đang giao',NULL,'Đỗ Khắc Hảo','vĩnh phú 25, thuận an, Bình dương','0987654321','COD',NULL,235000.00,NULL,2485000.00),(340,11,'2025-05-12 15:26:44',500000.00,'chưa thanh toán','chờ',NULL,'Đỗ Khắc Hảo','vĩnh phú 25, thuận an, binh dương','0987654321','COD',NULL,135000.00,NULL,635000.00),(341,4,'2025-05-12 16:11:47',500000.00,'chưa thanh toán','chờ',NULL,'Thượng Đình Hiệu','vĩnh phú 25, thuận an, binh dương','0909900900','COD',NULL,135000.00,NULL,635000.00),(342,11,'2025-05-12 16:12:57',500000.00,'chưa thanh toán','chờ',NULL,'Đỗ Khắc Hảo','vĩnh phú 25, thuận an, Bình dương','0987654321','COD',NULL,135000.00,NULL,635000.00),(343,11,'2025-05-12 16:54:52',500000.00,'đã thanh toán','chờ',NULL,'Đỗ Khắc Hảo','vĩnh phú 25, thuận an, binh dương','0987654321','VNPay','58200552',135000.00,NULL,635000.00),(344,11,'2025-05-12 17:01:34',500000.00,'đã thanh toán','chờ',NULL,'Đỗ Khắc Hảo','vĩnh phú 25, thuận an, binh dương','0987654321','VNPay','20160271',135000.00,NULL,635000.00),(345,11,'2025-05-12 21:37:01',1250000.00,'chưa thanh toán','chờ',NULL,'Đỗ Khắc Hảo','vĩnh phú 25, thuận an, binh dương','0987654321','COD',NULL,235000.00,NULL,1485000.00),(346,11,'2025-05-12 21:41:47',500000.00,'chưa thanh toán','chờ',NULL,'Đỗ Khắc Hảo','vĩnh phú 25, thuận an, Bình dương','0987654321','COD',NULL,135000.00,NULL,635000.00),(347,11,'2025-05-14 20:32:22',500000.00,'chưa thanh toán','chờ',NULL,'Đỗ Khắc Hảo','vĩnh phú 25, thuận an, Bình dương','0987654321','COD',NULL,135000.00,'15',575000.00),(348,4,'2025-05-28 23:03:10',500000.00,'đã thanh toán','chờ',NULL,'Thượng Đình Hiệu','vĩnh phú 25, thuận an, Bình dương','0909900900','VNPay','57473330',135000.00,'4',585000.00),(349,4,'2025-05-28 23:07:17',500000.00,'đã thanh toán','chờ',NULL,'Thượng Đình Hiệu','vĩnh phú 25, thuận an, Bình dương','0909900900','VNPay','97906785',135000.00,NULL,635000.00),(350,20,'2025-06-02 08:42:37',750000.00,'chưa thanh toán','hoàn thành','2025-06-02','Đỗ Khắc Hảo','vĩnh phú 25, thuận an, binh dương','0111131111','COD',NULL,235000.00,NULL,985000.00),(351,20,'2025-06-02 09:00:23',750000.00,'đã thanh toán','hoàn thành','2025-06-02','Đỗ Khắc Hảo','vĩnh phú 25, thuận an, Bình dương','0111131111','VNPay','53570467',235000.00,NULL,985000.00),(352,20,'2025-06-02 09:06:14',750000.00,'chưa thanh toán','đang giao',NULL,'Đỗ Khắc Hảo','vĩnh phú 25, thuận an, Bình dương','0111131111','COD',NULL,235000.00,NULL,985000.00),(353,20,'2025-06-02 09:13:03',500000.00,'chưa thanh toán','hoàn thành','2025-06-02','Đỗ Khắc Hảo','vĩnh phú 25, thuận an, Hà Nội','0111131111','COD',NULL,32000.00,NULL,532000.00),(354,20,'2025-06-02 09:21:35',2000000.00,'chưa thanh toán','hoàn thành','2025-06-02','Đỗ Khắc Hảo','vĩnh phú 25, thuận an, Bình dương','0111131111','COD',NULL,235000.00,NULL,2235000.00),(355,4,'2025-06-02 16:07:07',2500000.00,'chưa thanh toán','đã hủy giao hàng',NULL,'','','','COD',NULL,335000.00,'10',2585000.00),(356,35,'2025-06-02 16:53:27',2000000.00,'chưa thanh toán','chờ',NULL,'Hhhh Hhhh','19/7a, Thủ Đức, Hồ Chí Minh','0909900900','COD',NULL,430000.00,NULL,2430000.00);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `painting_sizes`
--

DROP TABLE IF EXISTS `painting_sizes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `painting_sizes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `paintingId` int NOT NULL,
  `sizeId` int NOT NULL,
  `totalQuantity` int DEFAULT NULL,
  `displayQuantity` int DEFAULT NULL,
  `reservedQuantity` int DEFAULT '0',
  `sizeDescription` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `weight` double DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `paintingId` (`paintingId`,`sizeId`) USING BTREE,
  KEY `sizeId` (`sizeId`) USING BTREE,
  CONSTRAINT `painting_sizes_ibfk_1` FOREIGN KEY (`paintingId`) REFERENCES `paintings` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `painting_sizes_ibfk_2` FOREIGN KEY (`sizeId`) REFERENCES `sizes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=397 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `painting_sizes`
--

LOCK TABLES `painting_sizes` WRITE;
/*!40000 ALTER TABLE `painting_sizes` DISABLE KEYS */;
INSERT INTO `painting_sizes` VALUES (4,2,1,100,79,1,NULL,NULL),(5,2,2,100,80,0,NULL,NULL),(6,2,3,100,80,0,NULL,NULL),(10,4,1,100,80,0,NULL,NULL),(11,4,2,100,80,0,NULL,NULL),(12,4,3,100,80,0,NULL,NULL),(19,7,1,100,80,0,NULL,NULL),(20,7,2,100,80,0,NULL,NULL),(21,7,3,100,80,0,NULL,NULL),(22,8,1,100,80,0,NULL,NULL),(23,8,2,100,80,0,NULL,NULL),(24,8,3,100,80,0,NULL,NULL),(25,9,1,100,80,0,NULL,NULL),(26,9,2,100,80,0,NULL,NULL),(27,9,3,100,80,0,NULL,NULL),(64,15,3,100,80,0,NULL,NULL),(65,15,1,100,80,0,NULL,NULL),(66,15,2,100,80,0,NULL,NULL),(79,3,3,98,80,0,NULL,NULL),(80,3,1,100,79,1,NULL,NULL),(81,3,2,100,78,0,NULL,NULL),(94,20,3,100,80,0,NULL,NULL),(95,20,1,100,80,0,NULL,NULL),(96,20,2,100,80,0,NULL,NULL),(100,22,3,100,80,0,NULL,NULL),(101,22,1,100,80,0,NULL,NULL),(102,22,2,100,80,0,NULL,NULL),(106,16,3,100,80,0,NULL,NULL),(107,16,1,100,80,0,NULL,NULL),(108,16,2,100,80,0,NULL,NULL),(118,21,3,100,80,0,NULL,NULL),(119,21,1,100,77,3,NULL,NULL),(120,21,2,100,80,0,NULL,NULL),(157,24,3,100,80,0,NULL,NULL),(158,24,1,111,91,0,NULL,NULL),(159,24,2,100,80,0,NULL,NULL),(160,25,3,100,80,0,NULL,NULL),(161,25,1,100,80,0,NULL,NULL),(162,25,2,100,80,0,NULL,NULL),(163,26,3,100,80,0,NULL,NULL),(164,26,1,100,80,0,NULL,NULL),(165,26,2,100,80,0,NULL,NULL),(166,27,3,100,80,0,NULL,NULL),(167,27,1,100,80,0,NULL,NULL),(168,27,2,100,80,0,NULL,NULL),(169,28,3,100,80,0,NULL,NULL),(170,28,1,100,80,0,NULL,NULL),(171,28,2,100,80,0,NULL,NULL),(172,29,3,100,80,0,NULL,NULL),(173,29,1,100,80,0,NULL,NULL),(174,29,2,100,80,0,NULL,NULL),(175,30,3,100,80,0,NULL,NULL),(176,30,1,100,80,0,NULL,NULL),(177,30,2,100,80,0,NULL,NULL),(178,31,3,100,80,0,NULL,NULL),(179,31,1,100,80,0,NULL,NULL),(180,31,2,100,80,0,NULL,NULL),(181,32,3,100,80,0,NULL,NULL),(182,32,1,100,80,0,NULL,NULL),(183,32,2,100,80,0,NULL,NULL),(184,33,3,100,80,0,NULL,NULL),(185,33,1,110,90,0,NULL,NULL),(186,33,2,100,80,0,NULL,NULL),(187,1,3,100,80,0,NULL,NULL),(188,1,1,99,60,18,NULL,NULL),(189,1,2,98,80,0,NULL,NULL),(190,34,3,100,80,0,NULL,NULL),(191,34,1,100,80,0,NULL,NULL),(192,34,2,100,80,0,NULL,NULL),(193,35,3,100,80,0,NULL,NULL),(194,35,1,100,80,0,NULL,NULL),(195,35,2,100,80,0,NULL,NULL),(196,36,3,100,80,0,NULL,NULL),(197,36,1,100,80,0,NULL,NULL),(198,36,2,100,80,0,NULL,NULL),(199,10,3,100,80,0,NULL,NULL),(200,10,1,100,80,0,NULL,NULL),(201,10,2,100,80,0,NULL,NULL),(202,5,3,100,80,0,NULL,NULL),(203,5,1,98,78,0,NULL,NULL),(204,5,2,100,80,0,NULL,NULL),(205,12,3,100,80,0,NULL,NULL),(206,12,1,100,80,0,NULL,NULL),(207,12,2,100,80,0,NULL,NULL),(208,13,3,100,80,0,NULL,NULL),(209,13,1,100,80,0,NULL,NULL),(210,13,2,100,80,0,NULL,NULL),(217,19,3,100,80,0,NULL,NULL),(218,19,1,100,80,0,NULL,NULL),(219,19,2,100,80,0,NULL,NULL),(241,18,3,100,80,0,NULL,NULL),(242,18,1,100,80,0,NULL,NULL),(243,18,2,100,80,0,NULL,NULL);
/*!40000 ALTER TABLE `painting_sizes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paintings`
--

DROP TABLE IF EXISTS `paintings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paintings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `themeId` int DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `artistId` int DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `imageUrl` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `imageUrlCloud` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isSold` tinyint(1) DEFAULT '0',
  `isFeatured` tinyint(1) DEFAULT '0',
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `themeId` (`themeId`) USING BTREE,
  KEY `artistId` (`artistId`) USING BTREE,
  KEY `idx_painting_title` (`title`) USING BTREE,
  KEY `idx_painting_price` (`price`) USING BTREE,
  KEY `idx_painting_createdAt` (`createdAt`) USING BTREE,
  KEY `idx_painting_artistId` (`artistId`) USING BTREE,
  KEY `idx_painting_themeId` (`themeId`) USING BTREE,
  KEY `idx_painting_isSold` (`isSold`) USING BTREE,
  KEY `idx_painting_isFeatured` (`isFeatured`) USING BTREE,
  KEY `idx_theme_artist_price` (`themeId`,`artistId`,`price`) USING BTREE,
  CONSTRAINT `paintings_ibfk_1` FOREIGN KEY (`themeId`) REFERENCES `themes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `paintings_ibfk_2` FOREIGN KEY (`artistId`) REFERENCES `artists` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paintings`
--

LOCK TABLES `paintings` WRITE;
/*!40000 ALTER TABLE `paintings` DISABLE KEYS */;
INSERT INTO `paintings` VALUES (1,'Tranh cảnh biển',3,1000000.00,3,'Tranh cảnh biển được họa sĩ Tri Đức vẽ lại khi đi giả ngoại','assets/images/artists/OIP.jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514463/assets/images/artists/h3ptcvhb1jzad9ges9w5.jpg',0,1,'2024-12-14 14:44:08'),(2,'Làng',3,2000000.00,1,'Tranh cảnh biển được họa sĩ Quỳnh Hoa vẽ lại khi về thăm nhà','assets/images/artists/DSC01805.JPG','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514401/assets/images/artists/gmivqc7lsptqput0r5rn.jpg',0,1,'2024-12-14 14:44:08'),(3,'Quê tôi',2,1000000.00,2,'Tranh quê được họa sĩ Quỳnh Hoa vẽ lại khi về thăm nhà','assets/images/artists/DSC01805.JPG','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514401/assets/images/artists/gmivqc7lsptqput0r5rn.jpg',0,1,'2024-12-14 14:44:08'),(4,'Quê hương',1,1000000.00,4,'Tác phẩm quê hương được họa sĩ Phan Anh Vẽ lại khi vè thăm nhà','assets/images/artists/tranh-cat-6.jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514517/assets/images/artists/wgfslo03vhlxrj9udqvm.jpg',0,0,'2024-12-14 14:44:08'),(5,'chăn trâu',1,1500000.00,4,'Tác phẩm hoa sen được họa sĩ Phan Anh Vẽ lại khi vè thăm nhà','assets/images/artists/R.jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514467/assets/images/artists/tsthwkfmda7hgb3oqef7.jpg',0,0,'2024-12-14 14:44:08'),(7,'Huế',2,1500000.00,3,'Tác phẩm Huế  được họa sĩ Phan Anh Vẽ lại khi vè thăm nhà','assets/images/artists/OIP (1).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514464/assets/images/artists/rythppicjefr0ly1u7w3.jpg',0,0,'2024-12-14 14:44:08'),(8,'Đi học',1,2000000.00,1,'Tác phẩm Đi Học  được họa sĩ Phan Anh Vẽ lại khi vè thăm nhà','assets/images/artists/tranh-cat-phu-nu-viet-nam.jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514524/assets/images/artists/aciwpr0fantw13ahflzk.jpg',0,0,'2024-12-14 14:44:08'),(9,'Chiến thắng',3,2000000.00,3,'Tác phẩm Chiến Thắng  được họa sĩ Phan Anh Vẽ lại khi vè thăm nhà','assets/images/artists/tranh-cat-phong-canh6-1024x930.jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514519/assets/images/artists/xnjgnacra15xzb8iyeor.jpg',0,0,'2024-12-14 14:44:08'),(10,'Hoa sen',1,2000000.00,3,'Tác phẩm Chăn Trâu  được họa sĩ Trí Đức Vẽ lại khi vè thăm nhà','assets/images/artists/tranh-cat-phong-thuy-ca-sen2-1024x930.jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514522/assets/images/artists/ntoe967anzjy8bctmjro.jpg',0,0,'2024-12-14 14:44:08'),(12,'Quê tôi',3,200000.00,2,'Để am hiểu những bức tranh trừu tượng độc đáo, bạn cần phải hiểu rõ khái niệm về tranh trừu tượng, những ý nghĩa ẩn sâu bên trong từng nét vẽ của người họa sĩ. Nếu bạn nắm rõ những điều căn bản trên, nghệ thuật trừu tượng đảm bảo sẽ đem đến cái nhìn khác cho người xem, chinh phục được cả những người đam mê nghệ thuật khó tính nhất.','assets/images/artists/OIP.jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514463/assets/images/artists/h3ptcvhb1jzad9ges9w5.jpg',0,0,'2025-01-13 13:13:03'),(13,'Bà tôi',3,500000.00,2,'Để am hiểu những bức tranh trừu tượng độc đáo, bạn cần phải hiểu rõ khái niệm về tranh trừu tượng, những ý nghĩa ẩn sâu bên trong từng nét vẽ của người họa sĩ. Nếu bạn nắm rõ những điều căn bản trên, nghệ thuật trừu tượng đảm bảo sẽ đem đến cái nhìn khác cho người xem, chinh phục được cả những người đam mê nghệ thuật khó tính nhất.','assets/images/artists/OIP_(1).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514464/assets/images/artists/rythppicjefr0ly1u7w3.jpg',0,0,'2025-01-13 13:15:26'),(15,'Phố Xa',2,5000000.00,4,'Cảnh phố được nhìn thì góc của họa sĩ khi đang ở trong tù','assets/images/artists/R.jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514467/assets/images/artists/tsthwkfmda7hgb3oqef7.jpg',0,1,'2025-01-13 16:38:22'),(16,'Tranh cát chảy vàng',2,200000.00,4,'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ','assets/images/artists/shopping_(1).webp','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514504/assets/images/artists/e61n3bxhzej9grqy73oz.webp',0,0,'2025-01-16 04:00:51'),(18,'Tranh cát chảy đỏ',4,250000.00,1,'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ','assets/images/artists/shopping.webp','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514503/assets/images/artists/jltkkjkvcthzi7nrwkxw.webp',0,0,'2025-01-16 04:03:12'),(19,'Tranh cát lục bảo',4,400000.00,1,'','assets/images/artists/shopping_(3).webp','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514507/assets/images/artists/cnxza6ei3iptkme8b3nv.webp',0,0,'2025-01-16 04:04:16'),(20,'Gia đình',1,2000000.00,2,'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ','assets/images/artists/images_(2).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514430/assets/images/artists/mdl9t2fluc5jtqxg6pxj.jpg',0,0,'2025-01-16 04:05:10'),(21,'Tình yêu',1,500000.00,2,'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ','assets/images/artists/images_(1).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514410/assets/images/artists/lzccq8yj7x6jrgmd5fh0.jpg',0,0,'2025-01-16 04:05:55'),(22,'Anh hùng',1,500000.00,3,'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ','assets/images/artists/images.jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514409/assets/images/artists/irvfhw7jrj9215s9lezg.jpg',0,0,'2025-01-16 04:07:06'),(24,'Anh em',1,500000.00,4,'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.','assets/images/artists/images_(11).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514414/assets/images/artists/hsuqn0j8qydr28kfvkks.jpg',0,0,'2025-01-16 16:32:50'),(25,'Ngày ta mười tám',4,400000.00,1,'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.','assets/images/artists/images_(10).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514412/assets/images/artists/uhpdhwhyb2sjniirsyoc.jpg',0,0,'2025-01-16 16:33:56'),(26,'Bà ơi',4,300000.00,2,'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.','assets/images/artists/images_(9).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514456/assets/images/artists/wraxrvplj1zxutj4l4ce.jpg',0,0,'2025-01-16 16:34:52'),(27,'Mẹ con',4,400000.00,1,'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.','assets/images/artists/images_(8).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514455/assets/images/artists/itddfl3ejrlrdo7aimle.jpg',0,0,'2025-01-16 16:35:43'),(28,'Lâu đài cát',4,600000.00,1,'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.','assets/images/artists/images_(7).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514453/assets/images/artists/tp0x3wuapa6tre00gvwz.jpg',0,0,'2025-01-16 16:36:23'),(29,'Núi bạc kim',3,700000.00,1,'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.','assets/images/artists/images_(6).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514452/assets/images/artists/k8zdxmw4ejkhtvgfplqj.jpg',0,0,'2025-01-16 16:37:18'),(30,'Chị em',2,600000.00,4,'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.','assets/images/artists/images_(5).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514451/assets/images/artists/kjzprt1xrb3rzftpwtiw.jpg',0,0,'2025-01-16 16:45:24'),(31,'Sống dai',1,300000.00,3,'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.','assets/images/artists/images_(4).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514450/assets/images/artists/sopvjecmhqr9jk8cjrto.jpg',0,0,'2025-01-16 16:46:12'),(32,'Mắc biếc',2,200000.00,4,'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.','assets/images/artists/images_(3).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514445/assets/images/artists/gnh7gxnzekp2mc1ukqtf.jpg',0,0,'2025-01-16 16:47:05'),(33,'Sóng',4,400000.00,4,'Tranh cát nghệ thuật là hình thức tạo hình nghệ thuật sử dụng cát màu, bột khoáng chất, tinh thể hoặc các sắc tố khác có nguồn gốc tự nhiên hay chất liệu tổng hợp để phối hợp tạo hình theo ý đồ nghệ thuật của người họa sĩ.','assets/images/artists/images_(6).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514452/assets/images/artists/k8zdxmw4ejkhtvgfplqj.jpg',0,0,'2025-01-16 16:47:59'),(34,'Tranh cát chảy hồng',3,400000.00,2,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(12).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514415/assets/images/artists/djykzhvqxdnr2xjacuyg.jpg',0,0,'2025-01-16 22:39:27'),(35,'tranh cát chảy tím',3,200000.00,2,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(31).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514448/assets/images/artists/agsvwnkzose3pbj2yl0y.jpg',0,0,'2025-01-16 22:41:08'),(36,'Hàng xóm',4,400000.00,4,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(30).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514447/assets/images/artists/bmhdmruebadyqnkkwt9a.jpg',0,0,'2025-01-16 22:42:47'),(54,'Bồ câu',1,600000.00,1,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(29).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514444/assets/images/artists/rty2xexe7nwhbhc2vr0b.jpg',0,0,'2025-01-16 22:58:56'),(55,'Nguời lính',2,600000.00,2,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(28).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514443/assets/images/artists/p2d34rhuskcj78tl48u7.jpg',0,0,'2025-01-16 22:58:56'),(56,'Gánh',3,600000.00,3,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(27).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514442/assets/images/artists/bvirlcgjnkgoiai4sh2r.jpg',0,0,'2025-01-16 22:58:56'),(57,'Gỉa gạo',4,600000.00,4,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(26).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514440/assets/images/artists/rthbhsgrl9ncgnwfxwhy.jpg',0,0,'2025-01-16 22:58:56'),(58,'Hải quân',1,600000.00,1,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(25).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514438/assets/images/artists/wh7izkl6zhgkfvleh8ub.jpg',0,0,'2025-01-16 22:58:56'),(59,'Cắm cờ trên nóc dinh độc lập',2,600000.00,3,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(24).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514437/assets/images/artists/ij41gbbc5ltisp3q6rsc.jpg',0,0,'2025-01-16 22:58:56'),(60,'Phật',4,600000.00,2,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(23).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514435/assets/images/artists/jegtcf5c8itr1ksemxrb.jpg',0,0,'2025-01-16 22:58:56'),(61,'Phụ nữ',4,600000.00,4,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(22).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514434/assets/images/artists/itbtdckjxslrpuh8mo4g.jpg',0,0,'2025-01-16 22:58:56'),(62,'Thánh gióng',1,600000.00,1,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(21).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514432/assets/images/artists/hcubp7o2k9x8wpmz5rul.jpg',0,0,'2025-01-16 22:58:56'),(63,'Vọng phu',2,600000.00,2,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(20).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514431/assets/images/artists/hvxvdgfnqdx8izyzmoxj.jpg',0,0,'2025-01-16 22:58:56'),(64,'Tình mẹ',2,600000.00,3,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(19).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514428/assets/images/artists/ry7yt44qegv0p8g5ma76.jpg',0,0,'2025-01-16 22:58:56'),(65,'Khởi nghĩa',3,600000.00,4,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(18).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514424/assets/images/artists/ysgzhztayp2imcwfzsfq.jpg',0,0,'2025-01-16 22:58:56'),(66,'Ước mơ',3,600000.00,1,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(17).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514422/assets/images/artists/ilgs1k0cxq7ircklgkwp.jpg',0,0,'2025-01-16 22:58:56'),(67,'Chăn trâu',4,600000.00,2,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(16).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514421/assets/images/artists/d40dlucjkfl1gm2jkisw.jpg',0,0,'2025-01-16 22:58:56'),(68,'Cảnh chìu',1,600000.00,3,'Là loại hình tranh cát mà người nghệ nhân rải cát trong một khung kính với nhiều lớp cát màu chồng lấp lên nhau. Sự khác nhau cơ bản đó là một loại sử dụng nguyên tắc ngược sáng của cùng một loại cát và một loại dùng màu sắc của nhiều loại cát để tạo nên hình hoạ. Để cho ra một tác phẩm tranh cát tĩnh sẽ mất khoảng ','assets/images/artists/images_(15).jpg','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514420/assets/images/artists/hr58diojgtm8ec7oeq9f.jpg',0,0,'2025-01-16 22:58:56');
/*!40000 ALTER TABLE `paintings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  CONSTRAINT `password_reset_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
INSERT INTO `password_reset_tokens` VALUES (2,2,'22310096-1d9b-4671-9b17-5f2b8468a53c','2025-01-17 02:14:32');
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_methods`
--

DROP TABLE IF EXISTS `payment_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_methods` (
  `id` int NOT NULL AUTO_INCREMENT,
  `methodName` enum('Online','COD') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `methodName` (`methodName`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_methods`
--

LOCK TABLES `payment_methods` WRITE;
/*!40000 ALTER TABLE `payment_methods` DISABLE KEYS */;
INSERT INTO `payment_methods` VALUES (2,'Online'),(1,'COD');
/*!40000 ALTER TABLE `payment_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `orderId` int DEFAULT NULL,
  `userId` int DEFAULT NULL,
  `methodId` int DEFAULT NULL,
  `paymentStatus` enum('chờ','đã thanh toán','thất bại','đã hủy') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'chờ',
  `paymentDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `transactionId` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `userId` (`userId`) USING BTREE,
  KEY `methodId` (`methodId`) USING BTREE,
  KEY `payments_ibfk_1` (`orderId`) USING BTREE,
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`orderId`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `payments_ibfk_3` FOREIGN KEY (`methodId`) REFERENCES `payment_methods` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=339 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (192,210,4,1,'đã thanh toán','2025-04-11 19:03:48',NULL),(317,335,11,1,'đã thanh toán','2025-05-06 23:57:40',NULL),(318,336,11,1,'đã thanh toán','2025-05-07 00:00:39',NULL),(319,337,11,1,'đã thanh toán','2025-05-07 16:13:08',NULL),(320,338,11,2,'chờ','2025-05-07 16:16:22',NULL),(321,339,11,1,'đã thanh toán','2025-05-07 16:29:52',NULL),(322,340,11,1,'đã thanh toán','2025-05-12 15:26:44',NULL),(323,341,4,1,'đã thanh toán','2025-05-12 16:11:48',NULL),(324,342,11,1,'đã thanh toán','2025-05-12 16:12:57',NULL),(325,343,11,2,'chờ','2025-05-12 16:54:52',NULL),(326,344,11,2,'chờ','2025-05-12 17:01:34',NULL),(327,345,11,1,'đã thanh toán','2025-05-12 21:37:01',NULL),(328,346,11,1,'đã thanh toán','2025-05-12 21:41:48',NULL),(329,347,11,1,'đã thanh toán','2025-05-14 20:32:22',NULL),(330,348,4,2,'chờ','2025-05-28 23:03:11',NULL),(331,349,4,2,'chờ','2025-05-28 23:07:18',NULL),(332,350,20,1,'đã thanh toán','2025-06-02 08:42:38',NULL),(333,351,20,2,'chờ','2025-06-02 09:00:24',NULL),(334,352,20,1,'đã thanh toán','2025-06-02 09:06:15',NULL),(335,353,20,1,'đã thanh toán','2025-06-02 09:13:04',NULL),(336,354,20,1,'đã thanh toán','2025-06-02 09:21:35',NULL),(337,355,4,1,'đã thanh toán','2025-06-02 16:07:07',NULL),(338,356,35,1,'đã thanh toán','2025-06-02 16:53:28',NULL);
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (3,'BUY_PRODUCTS','can buy products'),(4,'VIEW_USERS','can view users'),(5,'VIEW_PREVIEWS','can view preview'),(6,'DELETE_PRODUCTS','can detete products'),(7,'UPDATE_PRODUCTS','can update products'),(8,'ADD_PRODUCTS','can add products'),(9,'VIEW_PRODUCTS','can view products'),(10,'DELETE_ORDERS','can delete orders'),(11,'UPDATE_ORDERS','can update order'),(12,'VIEW_ORDERS','can view orders'),(13,'ADD_THEMEs','can add theme'),(14,'VIEW_ARTISTS','can view artists'),(15,'VIEW_DISCOUNTS','can view discounts'),(16,'VIEW_VOUCHERS','can view vouchers'),(17,'UPDATE_ARTISTS','can update artists'),(18,'DELETE_ARTISTS','can delete artists'),(19,'ADD_ARTISIS','can add artists'),(20,'ADD_DISCOUNTS','can add discount'),(21,'UPDATE_DISCOUNTS','can update discount'),(22,'DELETE_DISCOUNT','can delete discount'),(23,'ADD_VOUCHERS','can add vouchers'),(24,'UPDATE_SIZES','can update size'),(25,'ADD_SIZES','can add size'),(26,'DELETE_SIZES','can delete size'),(27,'DELETE_VOUCHERS','can delete voucher'),(28,'DELETE_THEMES','can delete theme'),(29,'UPDATE_VOUCHERS','can update voucher');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_reviews`
--

DROP TABLE IF EXISTS `product_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `paintingId` int NOT NULL,
  `orderItemId` int NOT NULL,
  `rating` int NOT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `userId` (`userId`,`paintingId`,`orderItemId`) USING BTREE,
  KEY `orderItemId` (`orderItemId`) USING BTREE,
  KEY `product_reviews_ibfk_2` (`paintingId`) USING BTREE,
  KEY `idx_reviews_paintingId` (`paintingId`) USING BTREE,
  KEY `idx_userId` (`userId`) USING BTREE,
  CONSTRAINT `product_reviews_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `product_reviews_ibfk_2` FOREIGN KEY (`paintingId`) REFERENCES `paintings` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `product_reviews_ibfk_3` FOREIGN KEY (`orderItemId`) REFERENCES `order_items` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `product_reviews_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_reviews`
--

LOCK TABLES `product_reviews` WRITE;
/*!40000 ALTER TABLE `product_reviews` DISABLE KEYS */;
INSERT INTO `product_reviews` VALUES (89,4,15,237,4,'Tranh đẹp','2025-04-11 19:04:32'),(90,4,3,238,3,'Tranh tệ','2025-04-11 19:04:59');
/*!40000 ALTER TABLE `product_reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permissions` (
  `roleId` int NOT NULL,
  `permissionId` int NOT NULL,
  PRIMARY KEY (`roleId`,`permissionId`) USING BTREE,
  KEY `permissionId` (`permissionId`) USING BTREE,
  CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`roleId`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `role_permissions_ibfk_2` FOREIGN KEY (`permissionId`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permissions`
--

LOCK TABLES `role_permissions` WRITE;
/*!40000 ALTER TABLE `role_permissions` DISABLE KEYS */;
INSERT INTO `role_permissions` VALUES (1,3),(2,3),(5,3),(13,3),(1,4),(1,5),(1,6),(3,6),(1,7),(3,7),(1,8),(3,8),(1,9),(3,9),(1,10),(1,11),(1,12),(1,13),(3,13),(5,13),(1,14),(3,14),(1,15),(1,16),(1,17),(3,17),(1,18),(3,18),(1,19),(3,19),(1,20),(1,21),(1,22),(1,23),(1,24),(3,24),(1,25),(3,25),(1,26),(3,26),(1,27),(1,28),(3,28),(1,29);
/*!40000 ALTER TABLE `role_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'ADMIN'),(4,'MANAGER_ORDER'),(3,'MANAGER_PRODUCT'),(13,'MANAGER_REVIEWS'),(5,'MANAGER_THEME'),(2,'USER');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shop_reviews`
--

DROP TABLE IF EXISTS `shop_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `createdAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `userId` (`userId`) USING BTREE,
  CONSTRAINT `shop_reviews_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `shop_reviews_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shop_reviews`
--

LOCK TABLES `shop_reviews` WRITE;
/*!40000 ALTER TABLE `shop_reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `shop_reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sizes`
--

DROP TABLE IF EXISTS `sizes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sizes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sizeDescription` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `weight` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `sizeDescription` (`sizeDescription`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sizes`
--

LOCK TABLES `sizes` WRITE;
/*!40000 ALTER TABLE `sizes` DISABLE KEYS */;
INSERT INTO `sizes` VALUES (1,'Nhỏ (20x30 cm)',5000.00),(2,'Vừa (40x60 cm)',7000.00),(3,'Lớn (80x100 cm)',9000.00);
/*!40000 ALTER TABLE `sizes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_in`
--

DROP TABLE IF EXISTS `stock_in`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_in` (
  `id` int NOT NULL AUTO_INCREMENT,
  `createdId` int NOT NULL,
  `supplier` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `importDate` date DEFAULT NULL,
  `totalPrice` decimal(10,2) DEFAULT NULL,
  `status` enum('Đã áp dụng','Chưa áp dụng') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `createBy` (`createdId`) USING BTREE,
  CONSTRAINT `stock_in_ibfk_1` FOREIGN KEY (`createdId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_in`
--

LOCK TABLES `stock_in` WRITE;
/*!40000 ALTER TABLE `stock_in` DISABLE KEYS */;
INSERT INTO `stock_in` VALUES (19,4,'NCC01',NULL,'2025-05-04',200000.00,NULL),(20,4,'NCC01','Nhập hàng','2025-05-07',4000000.00,'Đã áp dụng'),(21,4,'fff','','2025-05-27',121.00,'Đã áp dụng');
/*!40000 ALTER TABLE `stock_in` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_in_items`
--

DROP TABLE IF EXISTS `stock_in_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_in_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `stockInId` int NOT NULL,
  `paintingId` int NOT NULL,
  `sizeId` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `quantity` int NOT NULL,
  `totalPrice` decimal(10,2) DEFAULT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `stockInId` (`stockInId`) USING BTREE,
  KEY `paintingId` (`paintingId`) USING BTREE,
  KEY `sizeId` (`sizeId`) USING BTREE,
  CONSTRAINT `stock_in_items_ibfk_1` FOREIGN KEY (`stockInId`) REFERENCES `stock_in` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `stock_in_items_ibfk_2` FOREIGN KEY (`paintingId`) REFERENCES `paintings` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `stock_in_items_ibfk_3` FOREIGN KEY (`sizeId`) REFERENCES `sizes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_in_items`
--

LOCK TABLES `stock_in_items` WRITE;
/*!40000 ALTER TABLE `stock_in_items` DISABLE KEYS */;
INSERT INTO `stock_in_items` VALUES (24,19,61,1,200000.00,1,200000.00,'Sp1'),(25,20,33,1,400000.00,10,4000000.00,''),(26,21,24,1,11.00,11,121.00,'');
/*!40000 ALTER TABLE `stock_in_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_out`
--

DROP TABLE IF EXISTS `stock_out`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_out` (
  `id` int NOT NULL AUTO_INCREMENT,
  `createdId` int NOT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `orderId` int DEFAULT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `exportDate` date DEFAULT NULL,
  `totalPrice` decimal(10,2) DEFAULT NULL,
  `status` enum('Đã áp dụng','Chưa áp dụng') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `createdId` (`createdId`) USING BTREE,
  KEY `orderId` (`orderId`) USING BTREE,
  CONSTRAINT `stock_out_ibfk_1` FOREIGN KEY (`createdId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `stock_out_ibfk_2` FOREIGN KEY (`orderId`) REFERENCES `orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_out`
--

LOCK TABLES `stock_out` WRITE;
/*!40000 ALTER TABLE `stock_out` DISABLE KEYS */;
INSERT INTO `stock_out` VALUES (16,4,'Giao hàng',336,'Giao hàng','2025-05-07',2000000.00,'Đã áp dụng'),(17,4,'Giao hàng',335,'Giao hàng','2025-05-07',3500000.00,'Đã áp dụng'),(18,4,'Giao hàng',339,'','2025-05-07',4500000.00,'Đã áp dụng');
/*!40000 ALTER TABLE `stock_out` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_out_items`
--

DROP TABLE IF EXISTS `stock_out_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_out_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `stockOutId` int NOT NULL,
  `paintingId` int NOT NULL,
  `sizeId` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `quantity` int NOT NULL,
  `totalPrice` decimal(10,2) DEFAULT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `stockOutId` (`stockOutId`) USING BTREE,
  KEY `paintingId` (`paintingId`) USING BTREE,
  KEY `sizeId` (`sizeId`) USING BTREE,
  CONSTRAINT `stock_out_items_ibfk_1` FOREIGN KEY (`stockOutId`) REFERENCES `stock_out` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `stock_out_items_ibfk_2` FOREIGN KEY (`paintingId`) REFERENCES `paintings` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `stock_out_items_ibfk_3` FOREIGN KEY (`sizeId`) REFERENCES `sizes` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_out_items`
--

LOCK TABLES `stock_out_items` WRITE;
/*!40000 ALTER TABLE `stock_out_items` DISABLE KEYS */;
INSERT INTO `stock_out_items` VALUES (18,16,1,2,1000000.00,2,2000000.00,''),(19,17,1,1,500000.00,1,500000.00,''),(20,17,3,3,1500000.00,2,3000000.00,''),(21,18,5,1,2250000.00,2,4500000.00,'');
/*!40000 ALTER TABLE `stock_out_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `themes`
--

DROP TABLE IF EXISTS `themes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `themes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `themeName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `themeName` (`themeName`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=344 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `themes`
--

LOCK TABLES `themes` WRITE;
/*!40000 ALTER TABLE `themes` DISABLE KEYS */;
INSERT INTO `themes` VALUES (4,'Dân gian'),(1,'Đời sống'),(2,'Tĩnh vật'),(3,'Trừu tượng');
/*!40000 ALTER TABLE `themes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tokens`
--

DROP TABLE IF EXISTS `tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiredAt` datetime NOT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_token_type` (`token`,`type`) USING BTREE,
  KEY `idx_tokens_user_type_expire` (`userId`,`type`,`expiredAt`) USING BTREE,
  CONSTRAINT `tokens_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tokens`
--

LOCK TABLES `tokens` WRITE;
/*!40000 ALTER TABLE `tokens` DISABLE KEYS */;
INSERT INTO `tokens` VALUES (2,20,'392a4de4-4860-4998-99c6-161e5df3186d','2025-06-03 08:40:23','register');
/*!40000 ALTER TABLE `tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `userId` int NOT NULL,
  `roleId` int NOT NULL,
  PRIMARY KEY (`userId`,`roleId`) USING BTREE,
  KEY `roleId` (`roleId`) USING BTREE,
  KEY `idx_userId` (`userId`) USING BTREE,
  CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`roleId`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES (4,1),(11,1),(7,2),(21,2),(33,2),(35,2),(2,3),(1,4),(2,4),(4,5),(2,13);
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_vouchers`
--

DROP TABLE IF EXISTS `user_vouchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_vouchers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `voucher_id` int NOT NULL,
  `is_used` tinyint(1) DEFAULT '0',
  `assigned_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `used_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `voucher_id` (`voucher_id`) USING BTREE,
  CONSTRAINT `user_vouchers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `user_vouchers_ibfk_2` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_vouchers`
--

LOCK TABLES `user_vouchers` WRITE;
/*!40000 ALTER TABLE `user_vouchers` DISABLE KEYS */;
INSERT INTO `user_vouchers` VALUES (2,4,4,1,'2025-04-16 17:01:21',NULL),(3,4,6,1,'2025-04-16 20:24:23',NULL),(4,4,7,1,'2025-04-17 09:15:04',NULL),(5,4,4,1,'2025-04-17 16:01:40',NULL),(6,4,6,0,'2025-04-17 16:02:07',NULL),(7,4,8,1,'2025-04-18 22:52:08',NULL),(14,4,9,0,'2025-04-20 13:58:05',NULL),(15,4,19,1,'2025-04-20 15:05:31',NULL),(16,4,44,1,'2025-04-20 15:06:09',NULL),(17,4,98,1,'2025-04-20 15:35:57',NULL),(18,4,89,0,'2025-04-20 16:31:21',NULL),(19,4,92,0,'2025-04-20 16:59:08',NULL),(20,4,10,0,'2025-04-25 20:28:27',NULL),(21,11,27,1,'2025-05-06 19:19:44',NULL),(22,11,84,1,'2025-05-06 19:21:25',NULL),(23,11,18,1,'2025-05-06 19:49:23',NULL),(24,11,29,1,'2025-05-06 19:58:14',NULL),(25,11,49,1,'2025-05-06 20:03:06',NULL),(26,11,47,1,'2025-05-06 20:07:18',NULL),(27,11,101,0,'2025-05-06 20:22:11',NULL),(28,11,78,1,'2025-05-06 21:13:57',NULL),(29,11,19,1,'2025-05-06 21:31:59',NULL),(30,11,46,0,'2025-05-06 22:01:09',NULL),(31,11,75,1,'2025-05-06 23:40:01',NULL),(32,11,85,1,'2025-05-06 23:42:35',NULL),(33,11,95,0,'2025-05-06 23:44:27',NULL),(34,11,15,0,'2025-05-12 16:12:59',NULL),(35,11,98,0,'2025-05-14 20:32:24',NULL);
/*!40000 ALTER TABLE `user_vouchers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fullName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` enum('admin','user') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'user',
  `gg_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fb_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('Hoạt động','Chưa kích hoạt','Bị khóa','Chờ xóa','Đã xóa') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Chưa kích hoạt',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `email` (`email`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE,
  KEY `idx_email` (`email`) USING BTREE,
  KEY `idx_username` (`username`) USING BTREE,
  KEY `idx_gg_id` (`gg_id`) USING BTREE,
  KEY `idx_fb_id` (`fb_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Thượng Đình Hiệu','dinhHieu','5b9b13a02966b27f060a43d276705b95','Thuận An, Bình Dương, HCM','22130082@gmail.com','0909090909','admin',NULL,NULL,'Hoạt động'),(2,'Thượng Đình Hiệu ','hieuhieu','8ab4c089690ef2d9cb7cf48ce34a6269','Điện An 1','hieuthuong113@gmail.com','09090909','user',NULL,NULL,'Hoạt động'),(4,'Thượng Đình Hiệu','admin','$2a$12$evzTLhvG/Offc6KyJWcv4uhJiAhDFEvwO3h8gzVOvVVF2yumpBmw6','Thuân An','hieuthuong13@gmail.com','0909900900','admin',NULL,NULL,'Hoạt động'),(7,'Nguyên Van A','vana','8ab4c089690ef2d9cb7cf48ce34a6269','Điên An','2213008@gmail.com','0909090909','user',NULL,NULL,'Hoạt động'),(10,'ddd','aaaa','ceedb854f1f65aa21a59e6e651cd26a8','nul','teacher1@gmail.com','0909090909','user',NULL,NULL,'Hoạt động'),(11,'Đỗ Khắc Hảo','haoxt04','43c51c4d90db42512f4c09d162484b05','ĐH Nông Lâm','k42.dkhao@gmail.com','0987654321','admin',NULL,NULL,'Hoạt động'),(12,'Đỗ Khắc Hảo','haodo04','43c51c4d90db42512f4c09d162484b05','TP. Hồ Chí Minh','haodo04@gmail.com','0931931311','user',NULL,NULL,'Hoạt động'),(20,'Đỗ Khắc Hảo','abc123','$2a$12$daoJIdmFPbqcyHEK0axOGuPTELHdwjZdimCKn.wBEkbOQTbW4N.wm',NULL,'abc123@gmail.com','0111131111','user',NULL,NULL,'Bị khóa'),(21,'Phước Ân',NULL,NULL,NULL,'votranphuocan@gmail.com',NULL,'user','102993532393503171401',NULL,'Đã xóa'),(33,'Ân Võ Trần Phước',NULL,NULL,NULL,'22130004@st.hcmuaf.edu.vn',NULL,'user','116803581594500450408',NULL,'Đã xóa'),(35,'Hhhh Hhhh',NULL,NULL,NULL,'muoi25century@gmail.com',NULL,'user','105550794514550874979',NULL,'Hoạt động');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vouchers`
--

DROP TABLE IF EXISTS `vouchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vouchers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount` decimal(5,2) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `startDate` date NOT NULL,
  `endDate` date NOT NULL,
  `imageUrl` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `imageUrlCloud` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` enum('order','shipping') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'order',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vouchers`
--

LOCK TABLES `vouchers` WRITE;
/*!40000 ALTER TABLE `vouchers` DISABLE KEYS */;
INSERT INTO `vouchers` VALUES (4,'Voucher 10%',10.00,1,'2025-01-16 02:16:30','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','12310','order'),(6,'Voucher 12%',12.00,1,'2025-01-16 02:58:39','2025-01-14','2030-02-14','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','12312','order'),(7,'Voucher 15%',15.00,1,'2025-01-16 03:02:56','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','12315','order'),(8,'Voucher freeship',100.00,1,'2025-04-17 09:46:50','2025-04-17','2030-04-29','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','123SHIP','shipping'),(9,'Gift 10%',10.00,1,'2025-04-20 10:07:33','2025-04-20','2030-04-20','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','GIFT10','order'),(10,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO15793_0','order'),(11,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO75424_1','order'),(12,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO43069_2','order'),(13,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO83371_3','shipping'),(14,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO61096_4','order'),(15,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO35748_5','order'),(16,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO92327_6','order'),(17,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO72008_7','shipping'),(18,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO25078_8','order'),(19,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO70929_9','order'),(20,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO86146_10','order'),(21,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO87007_11','shipping'),(22,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO24572_12','order'),(23,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO98173_13','order'),(24,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO67398_14','order'),(25,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO94620_15','shipping'),(26,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO75780_16','order'),(27,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO55360_17','order'),(28,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO36650_18','order'),(29,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO52863_19','shipping'),(30,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO46465_20','order'),(31,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO18075_21','order'),(32,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO40762_22','order'),(33,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO99916_23','shipping'),(34,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO92477_24','order'),(35,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO40453_25','order'),(36,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO91741_26','order'),(37,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO13162_27','shipping'),(38,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO17678_28','order'),(39,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO31637_29','order'),(40,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO63500_30','order'),(41,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO82647_31','shipping'),(42,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO26823_32','order'),(43,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO93185_33','order'),(44,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO39658_34','order'),(45,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO14687_35','shipping'),(46,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO52792_36','order'),(47,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO56998_37','order'),(48,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO79306_38','order'),(49,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO73682_39','shipping'),(50,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO85492_40','order'),(51,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO28711_41','order'),(52,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO47889_42','order'),(53,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO56963_43','shipping'),(54,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO34683_44','order'),(55,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO13963_45','order'),(56,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO12675_46','order'),(57,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO52776_47','shipping'),(58,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO20070_48','order'),(59,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO79901_49','order'),(60,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO12146_50','order'),(61,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO81748_51','shipping'),(62,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO93675_52','order'),(63,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO76703_53','order'),(64,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO52976_54','order'),(65,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO30291_55','shipping'),(66,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO30397_56','order'),(67,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO43427_57','order'),(68,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO80196_58','order'),(69,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO78338_59','shipping'),(70,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO51137_60','order'),(71,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO54923_61','order'),(72,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO42625_62','order'),(73,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO30936_63','shipping'),(74,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO78377_64','order'),(75,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO70442_65','order'),(76,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO42248_66','order'),(77,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO15755_67','shipping'),(78,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO28767_68','order'),(79,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO91885_69','order'),(80,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO16961_70','order'),(81,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO16420_71','shipping'),(82,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO49446_72','order'),(83,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO83515_73','order'),(84,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO95958_74','order'),(85,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO70706_75','shipping'),(86,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO39761_76','order'),(87,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO17567_77','order'),(88,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO81670_78','order'),(89,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO19681_79','shipping'),(90,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO66521_80','order'),(91,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO43144_81','order'),(92,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO63197_82','order'),(93,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO41518_83','shipping'),(94,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO86558_84','order'),(95,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO74648_85','order'),(96,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO31555_86','order'),(97,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO88596_87','shipping'),(98,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO73008_88','order'),(99,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO31129_89','order'),(100,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO47618_90','order'),(101,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO42081_91','shipping'),(102,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO89323_92','order'),(103,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO55054_93','order'),(104,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO43435_94','order'),(105,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO87129_95','shipping'),(106,'Voucher 10%',10.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_10percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514170/assets/images/vouchers/voucher_10percent.png.png','AUTO82116_96','order'),(107,'Voucher 12%',12.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_12percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514172/assets/images/vouchers/voucher_12percent.png.png','AUTO34266_97','order'),(108,'Voucher 15%',15.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_15percent.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514173/assets/images/vouchers/voucher_15percent.png.png','AUTO82999_98','order'),(109,'Voucher freeship',100.00,1,'2025-04-16 10:00:00','2025-04-16','2030-04-16','assets/images/vouchers/voucher_freeship.png','https://res.cloudinary.com/dz32nqnp3/image/upload/v1745514175/assets/images/vouchers/voucher_freeship.png.png','AUTO91465_99','shipping');
/*!40000 ALTER TABLE `vouchers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-03  3:00:51
