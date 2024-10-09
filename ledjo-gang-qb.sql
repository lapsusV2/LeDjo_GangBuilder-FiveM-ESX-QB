CREATE TABLE IF NOT EXISTS `ledjo_gang` (
  `name` varchar(25) DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `level` tinyint(4) DEFAULT NULL,
  `money` int(11) DEFAULT 0,
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `ledjo_gang_gang_data` (
  `name` longtext DEFAULT NULL,
  `label` longtext DEFAULT NULL,
  `grades` longtext DEFAULT NULL,
  UNIQUE KEY `name` (`name`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


CREATE TABLE IF NOT EXISTS `ledjo_gang_garage` (
  `owner` varchar(46) DEFAULT NULL,
  `label` varchar(46) DEFAULT NULL,
  `plate` varchar(12) DEFAULT NULL,
  `vehicle` longtext NOT NULL,
  `stored` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;