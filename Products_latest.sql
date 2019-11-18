-- MySQL dump 10.13  Distrib 8.0.17, for macos10.14 (x86_64)
--
-- Host: localhost    Database: product_management
-- ------------------------------------------------------
-- Server version	8.0.17

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Manufacturers`
--

DROP TABLE IF EXISTS `Manufacturers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Manufacturers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Manufacturers`
--

LOCK TABLES `Manufacturers` WRITE;
/*!40000 ALTER TABLE `Manufacturers` DISABLE KEYS */;
INSERT INTO `Manufacturers` (`id`, `Name`) VALUES (1,'LG'),(2,'Samsung'),(3,'Apple'),(4,'HP'),(5,'Sharp'),(6,'Xiaomi'),(7,'DELL');
/*!40000 ALTER TABLE `Manufacturers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Model` varchar(100) NOT NULL,
  `ManufacturerID` int(11) NOT NULL,
  `TypeID` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Manufacturer_idx` (`ManufacturerID`),
  KEY `Product_Product_Type_idx` (`TypeID`),
  CONSTRAINT `Manufacturer` FOREIGN KEY (`ManufacturerID`) REFERENCES `manufacturers` (`id`),
  CONSTRAINT `Product_Product_Type` FOREIGN KEY (`TypeID`) REFERENCES `producttypes` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` (`id`, `Name`, `Model`, `ManufacturerID`, `TypeID`) VALUES (4,'Macbook','Pro 15 inches',3,4),(5,'Iphone','11 pro',3,3),(6,'Galaxy','S3',2,3),(8,'KIEN TRUNG 1','Pro 15 inches',3,3);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProductTypes`
--

DROP TABLE IF EXISTS `ProductTypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProductTypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProductTypes`
--

LOCK TABLES `ProductTypes` WRITE;
/*!40000 ALTER TABLE `ProductTypes` DISABLE KEYS */;
INSERT INTO `ProductTypes` (`id`, `name`) VALUES (1,'TV'),(2,'Camera'),(3,'Cellphone'),(4,'Laptop'),(5,'Smart Watch'),(6,'Tablet'),(7,'PC'),(8,'HDD');
/*!40000 ALTER TABLE `ProductTypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProtectionClaims`
--

DROP TABLE IF EXISTS `ProtectionClaims`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProtectionClaims` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Type` varchar(45) NOT NULL,
  `Date` datetime NOT NULL,
  `Description` varchar(45) NOT NULL,
  `RegistrationId` int(11) NOT NULL,
  `status` varchar(45) NOT NULL DEFAULT 'WAITING APPROVAL',
  PRIMARY KEY (`id`),
  KEY `Claim_Registration_idx` (`RegistrationId`),
  CONSTRAINT `Claim_Registration` FOREIGN KEY (`RegistrationId`) REFERENCES `protectionregistrations` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProtectionClaims`
--

LOCK TABLES `ProtectionClaims` WRITE;
/*!40000 ALTER TABLE `ProtectionClaims` DISABLE KEYS */;
INSERT INTO `ProtectionClaims` (`id`, `Type`, `Date`, `Description`, `RegistrationId`, `status`) VALUES (1,'Repair','2019-11-14 00:00:00','Test',3,'APPROVED'),(2,'Repair','2019-11-15 00:00:00','lk;k',3,'APPROVED'),(3,'Repair','2019-11-21 00:00:00','lkjlkjkj',3,'APPROVED'),(4,'Replacement','2019-11-16 00:00:00','Test',10,'WAITING APPROVAL');
/*!40000 ALTER TABLE `ProtectionClaims` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProtectionRegistrations`
--

DROP TABLE IF EXISTS `ProtectionRegistrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ProtectionRegistrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `ProductId` int(11) NOT NULL,
  `PurchaseDate` datetime NOT NULL,
  `SerialNo` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `product_idx` (`ProductId`),
  KEY `user_idx` (`username`),
  CONSTRAINT `product` FOREIGN KEY (`ProductId`) REFERENCES `products` (`id`),
  CONSTRAINT `user` FOREIGN KEY (`username`) REFERENCES `users` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProtectionRegistrations`
--

LOCK TABLES `ProtectionRegistrations` WRITE;
/*!40000 ALTER TABLE `ProtectionRegistrations` DISABLE KEYS */;
INSERT INTO `ProtectionRegistrations` (`id`, `username`, `ProductId`, `PurchaseDate`, `SerialNo`) VALUES (3,'kientran',4,'2019-09-12 00:00:00','123123'),(5,'kientran',8,'2019-11-13 00:00:00','asdfasdf'),(6,'chibui',5,'2019-11-21 00:00:00','123-34-3234-343234234'),(7,'kientran',4,'2019-11-14 00:00:00','123123'),(8,'kientran',4,'2019-11-14 00:00:00','123123'),(9,'kientran',4,'2019-11-14 00:00:00','1231234'),(10,'joinsmith',4,'2019-11-14 00:00:00','1231235');
/*!40000 ALTER TABLE `ProtectionRegistrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `username` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `phone` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `address` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `role` varchar(45) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`username`, `password`, `phone`, `email`, `address`, `name`, `role`) VALUES ('admin','admin','12323','a@b.com','Home','Kien Tran','admin'),('alex','123456','0986979753','alex@gmail.com','150 Bloor Street','Alex','user'),('chibui','34123','adf','af','af','af','user'),('joinsmith','123456','4168278425','trungkientran84@gmail.com','52 Hullen Cresent','Join Smith','user'),('kientran','123','wewe','wewew','sadad','sdsd','user');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-15 17:11:06
